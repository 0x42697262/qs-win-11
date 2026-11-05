pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import qs.src.adapters.compositor
import "../domain/capture/snip.mjs" as SnipRules
import "../domain/theme/accentFromImage.mjs" as PixelRules
import "../domain/theme/color.mjs" as ColorRules
import "../domain/system/paths.mjs" as PathRules
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/enums.mjs" as Enums
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    id: root

    readonly property var settings: Settings.values.capture
    readonly property var text: Settings.values.text.capture
    property bool overlayOpen: false
    property string kind: Enums.SnipKind.Screenshot
    property string mode: Enums.SnipMode.Region
    property bool recording: false
    property string recordingPath: ""
    property var pendingCapture: null
    readonly property string screenshotDirectory: PathRules.expandHome(settings.screenshotDirectory, Environment.home)
    readonly property string recordingDirectory: PathRules.expandHome(settings.recordingDirectory, Environment.home)
    readonly property string recorderBinary: SnipRules.pickRecorder(settings.recorder, { gpu: Capabilities.hasBinary(SystemCatalog.SystemBinary.GpuScreenRecorder), wf: Capabilities.hasBinary(SystemCatalog.SystemBinary.WfRecorder) })

    function open(newKind: string): void {
        if (newKind === Enums.SnipKind.Recording && recording) {
            stopRecording();
            return;
        }
        ShellState.close();
        kind = newKind;
        if (kind === Enums.SnipKind.Recording && mode === Enums.SnipMode.Window) {
            mode = Enums.SnipMode.Region;
        }
        overlayOpen = true;
    }

    function close(): void {
        overlayOpen = false;
    }

    function windowGeometries(): list<var> {
        return Compositor.adapter ? Compositor.adapter.windowGeometries() : [];
    }

    function finish(rect: var, screen: var): void {
        pendingCapture = { rect, screen: { x: screen.x, y: screen.y, name: screen.name }, kind };
        overlayOpen = false;
        hideDelay.restart();
    }

    function runPending(): void {
        const job = pendingCapture;
        pendingCapture = null;
        if (!job) {
            return;
        }
        if (job.kind === Enums.SnipKind.Recording) {
            startRecording(job.rect, job.screen);
        } else if (job.kind === Enums.SnipKind.Color) {
            pickAt(job.rect.x + job.screen.x, job.rect.y + job.screen.y);
        } else if (job.rect) {
            captureArea(SnipRules.grimGeometry(job.rect, job.screen.x, job.screen.y));
        } else {
            captureOutput(job.screen.name);
        }
    }

    function captureArea(geometry: string): void {
        shoot([SystemCatalog.SystemBinary.Grim, "-g", geometry]);
    }

    function captureOutput(screenName: string): void {
        shoot(screenName !== "" ? [SystemCatalog.SystemBinary.Grim, "-o", screenName] : [SystemCatalog.SystemBinary.Grim]);
    }

    function shoot(base: list<string>): void {
        const path = SnipRules.capturePath(screenshotDirectory, settings.screenshotName, new Date());
        const copy = settings.copyToClipboard && Capabilities.hasBinary(SystemCatalog.SystemBinary.WlCopy);
        shooter.path = path;
        shooter.command = [SystemCatalog.SystemBinary.Shell, "-c", copy ? "dir=$1; file=$2; shift 2; mkdir -p \"$dir\" && \"$@\" \"$file\" && wl-copy --type image/png < \"$file\"" : "dir=$1; file=$2; shift 2; mkdir -p \"$dir\" && \"$@\" \"$file\"", SystemCatalog.SystemBinary.Shell, screenshotDirectory, path].concat(base);
        shooter.running = true;
    }

    function startRecording(rect: var, screen: var): void {
        if (recorderBinary === "") {
            return;
        }
        const path = SnipRules.capturePath(recordingDirectory, settings.recordingName, new Date());
        recordingPath = path;
        recorder.command = [SystemCatalog.SystemBinary.Shell, "-c", "dir=$1; shift; mkdir -p \"$dir\" && exec \"$@\"", SystemCatalog.SystemBinary.Shell, recordingDirectory].concat(SnipRules.recorderCommand(recorderBinary, rect, screen, path, settings.recordAudio));
        recorder.running = true;
        recording = true;
        Log.info(LogEvents.LogEvent.RecordingStarted, { path, recorder: recorderBinary });
    }

    function stopRecording(): void {
        if (recorder.running) {
            recorder.signal(2);
        }
    }

    function pickAt(globalX: real, globalY: real): void {
        const binary = Capabilities.imageSamplingBinary;
        picker.command = [SystemCatalog.SystemBinary.Shell, "-c", "grim -g \"$1\" -t png - | \"$2\" png:- -depth 8 txt:-", SystemCatalog.SystemBinary.Shell, `${Math.round(globalX)},${Math.round(globalY)} 1x1`, binary];
        picker.running = true;
    }

    function notifyFile(title: string, path: string): void {
        notifier.path = path;
        notifier.command = [SystemCatalog.SystemBinary.NotifySend, "-a", text.screenshot, "-i", path, "-A", `${SystemCatalog.NotifyAction.open}=${text.open}`, "-A", `${SystemCatalog.NotifyAction.edit}=${text.edit}`, "-A", `${SystemCatalog.NotifyAction.folder}=${text.folder}`, title, path];
        notifier.running = true;
    }

    Timer {
        id: hideDelay
        interval: Settings.values.tuning.snipHideDelayMs
        onTriggered: root.runPending()
    }

    Process {
        id: shooter
        property string path: ""
        onExited: (exitCode) => {
            if (exitCode === 0) {
                Log.info(LogEvents.LogEvent.CaptureSaved, { path: shooter.path });
                root.notifyFile(root.text.saved, shooter.path);
            } else {
                Log.warning(LogEvents.LogEvent.CaptureFailed, { path: shooter.path, exitCode });
            }
        }
    }

    Process {
        id: recorder
        onExited: (exitCode) => {
            root.recording = false;
            Log.info(LogEvents.LogEvent.RecordingStopped, { path: root.recordingPath, exitCode });
            root.notifyFile(root.text.recordingSaved, root.recordingPath);
        }
    }

    Process {
        id: picker
        stdout: StdioCollector {
            onStreamFinished: {
                const [red, green, blue] = PixelRules.parseMagickPixels(text);
                if (blue === undefined) {
                    Log.warning(LogEvents.LogEvent.CaptureFailed, { kind: Enums.SnipKind.Color });
                    return;
                }
                const hex = ColorRules.formatHex({ red, green, blue });
                Quickshell.clipboardText = hex;
                Log.info(LogEvents.LogEvent.ColorPicked, { color: hex });
                Quickshell.execDetached([SystemCatalog.SystemBinary.NotifySend, "-a", root.text.colorCopied, root.text.colorCopied, hex]);
            }
        }
    }

    Process {
        id: notifier
        property string path: ""
        stdout: StdioCollector {
            onStreamFinished: {
                const action = text.trim();
                if (action === SystemCatalog.NotifyAction.open) {
                    Session.openUri(`${SystemCatalog.FILE_URL_PREFIX}${notifier.path}`);
                } else if (action === SystemCatalog.NotifyAction.edit) {
                    Session.runCommandLine(SnipRules.fillFileCommand(Settings.values.commands.imageEditor, notifier.path));
                } else if (action === SystemCatalog.NotifyAction.folder) {
                    Session.openUri(`${SystemCatalog.FILE_URL_PREFIX}${PathRules.parentDirectory(notifier.path)}`);
                }
            }
        }
    }
}

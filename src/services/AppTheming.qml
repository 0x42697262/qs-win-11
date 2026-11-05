pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../domain/theming/templates.mjs" as Templates
import "../domain/theming/targets.mjs" as Targets
import "../domain/system/paths.mjs" as PathRules
import "../domain/catalog/appThemes.mjs" as AppThemeCatalog
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    id: root

    readonly property var settings: Settings.values.appTheming
    readonly property string outputDirectory: settings.outputDirectory !== "" ? PathRules.expandHome(settings.outputDirectory, Environment.home) : `${Paths.configDirectory}/${SystemCatalog.APP_THEMES_DIRECTORY}`
    readonly property string templateDirectory: settings.templateDirectory !== "" ? PathRules.expandHome(settings.templateDirectory, Environment.home) : `${outputDirectory}/${SystemCatalog.APP_TEMPLATES_DIRECTORY}`
    readonly property var scheme: Templates.buildTemplateScheme(ColorScheme.palette, Settings.values.tuning.appThemeSelectionMix)
    readonly property var words: ({ mode: ColorScheme.resolvedMode, font: Settings.values.theme.fontFamily })
    readonly property string fingerprint: JSON.stringify([scheme, words, settings])
    property list<var> jobs: []
    property int pendingWrites: 0
    property int written: 0

    signal writeRequested

    function render(): void {
        templateLister.running = false;
        templateLister.command = [SystemCatalog.SystemBinary.Find, templateDirectory].concat(Array.prototype.slice.call(SystemCatalog.TEMPLATE_FIND_ARGUMENTS));
        templateLister.running = true;
    }

    function finishedOne(): void {
        written += 1;
        if (written < jobs.length) {
            return;
        }
        Log.info(LogEvents.LogEvent.AppThemeRendered, { count: written, outputDirectory });
        Session.runCommandLine(Settings.values.commands.afterAppTheme);
    }

    onFingerprintChanged: if (Features.enabled.appTheming) debounce.restart()

    Connections {
        target: Features
        function onEnabledChanged(): void {
            if (Features.enabled.appTheming) {
                debounce.restart();
            }
        }
    }

    Timer {
        id: debounce
        interval: Settings.values.tuning.appThemeDelayMs
        onTriggered: root.render()
    }

    Process {
        id: templateLister
        stdout: StdioCollector {
            onStreamFinished: {
                const userTemplates = text.split("\n").filter(line => line.trim() !== "");
                root.jobs = Targets.planRenderJobs(root.settings.targets, Paths.shellAsset(AppThemeCatalog.TEMPLATE_DIRECTORY), userTemplates, root.templateDirectory, root.outputDirectory);
                directoryMaker.command = [SystemCatalog.SystemBinary.MakeDirectory, "-p"].concat(root.jobs.map(job => PathRules.parentDirectory(job.outputPath)));
                directoryMaker.running = true;
            }
        }
    }

    Process {
        id: directoryMaker
        onExited: {
            root.written = 0;
            root.writeRequested();
        }
    }

    Instantiator {
        model: root.jobs

        QtObject {
            id: job

            required property var modelData
            property bool pending: false
            property bool templateReady: false

            function write(): void {
                if (!templateReady) {
                    pending = true;
                    return;
                }
                pending = false;
                const result = Templates.renderTemplate(template.text(), root.scheme, root.words);
                if (result.unknown.length > 0) {
                    Log.warning(LogEvents.LogEvent.AppThemeTemplateProblem, { template: modelData.templatePath, unknown: result.unknown });
                }
                output.setText(result.text);
            }

            property FileView template: FileView {
                path: job.modelData.templatePath
                onLoaded: {
                    job.templateReady = true;
                    if (job.pending) {
                        job.write();
                    }
                }
                onLoadFailed: root.finishedOne()
            }

            property FileView output: FileView {
                path: job.modelData.outputPath
                atomicWrites: true
                blockLoading: false
                printErrors: false
                onSaved: root.finishedOne()
                onSaveFailed: root.finishedOne()
            }

            property Connections listener: Connections {
                target: root
                function onWriteRequested(): void {
                    job.write();
                }
            }
        }
    }
}

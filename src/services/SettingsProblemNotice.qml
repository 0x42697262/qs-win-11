import QtQuick
import Quickshell
import qs.src.config
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/catalog/features.mjs" as FeatureCatalog

Scope {
    id: root

    property bool notified: false

    function notifyOnce(): void {
        if (notified || !Settings.loaded || Settings.problems.length === 0 || !Capabilities.has(FeatureCatalog.Capability.NotifySend)) {
            return;
        }
        notified = true;
        const text = Settings.values.text.settingsProblems;
        Quickshell.execDetached([SystemCatalog.SystemBinary.NotifySend, "-a", Settings.values.text.settingsApp.title, text.title, `${text.body} ${Settings.problems.map(problem => problem.key).join(", ")}`]);
    }

    Connections {
        target: Settings
        function onProblemsChanged(): void {
            root.notifyOnce();
        }
        function onLoadedChanged(): void {
            root.notifyOnce();
        }
    }
}

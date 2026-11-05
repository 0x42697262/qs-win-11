pragma Singleton
import QtQuick
import Quickshell
import "../domain/catalog/logEvents.mjs" as LogEvents

Singleton {
    function info(event: string, fields: var): void {
        console.info(LogEvents.formatLogLine(event, fields ?? {}));
    }

    function warning(event: string, fields: var): void {
        console.warn(LogEvents.formatLogLine(event, fields ?? {}));
    }

    function error(event: string, fields: var): void {
        console.error(LogEvents.formatLogLine(event, fields ?? {}));
    }
}

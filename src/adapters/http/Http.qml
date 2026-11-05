pragma Singleton
import QtQuick
import Quickshell
import qs.src.services
import "../../domain/catalog/logEvents.mjs" as LogEvents
import "../../domain/catalog/system.mjs" as SystemCatalog

Singleton {
    function getJson(url: string, timeoutMs: int, onDone: var): void {
        const request = new XMLHttpRequest();
        let finished = false;
        const finish = (error, data) => {
            if (finished) {
                return;
            }
            finished = true;
            if (error !== "") {
                Log.info(LogEvents.LogEvent.HttpFailed, { url: url.split(SystemCatalog.URL_QUERY_SEPARATOR)[0], error });
            }
            onDone(error, data);
        };
        request.timeout = timeoutMs;
        request.onreadystatechange = () => {
            if (request.readyState !== XMLHttpRequest.DONE) {
                return;
            }
            if (request.status < SystemCatalog.HttpStatus.okMinimum || request.status > SystemCatalog.HttpStatus.okMaximum) {
                finish(`${SystemCatalog.HttpError.status} ${request.status}`, null);
                return;
            }
            try {
                finish("", JSON.parse(request.responseText));
            } catch (parseError) {
                finish(String(parseError), null);
            }
        };
        request.ontimeout = () => finish(SystemCatalog.HttpError.timeout, null);
        request.open(SystemCatalog.HttpMethod.get, url);
        request.send();
    }
}

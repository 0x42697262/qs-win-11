pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property string text: ""
    property string screenName: ""
    property real anchorX: 0
    property Item owner: null
    property list<string> previewWindowIds: []

    function show(item: Item, screen: string, value: string): void {
        showWithPreview(item, screen, value, []);
    }

    function showWithPreview(item: Item, screen: string, value: string, windowIds: list<string>): void {
        owner = item;
        previewWindowIds = windowIds;
        screenName = screen;
        anchorX = item.mapToItem(null, item.width / 2, 0).x;
        text = value;
    }

    function hide(item: Item): void {
        if (owner === item) {
            text = "";
            previewWindowIds = [];
            owner = null;
        }
    }
}

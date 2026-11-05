pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property string text: ""
    property string screenName: ""
    property real anchorX: 0
    property Item owner: null

    function show(item: Item, screen: string, value: string): void {
        owner = item;
        screenName = screen;
        anchorX = item.mapToItem(null, item.width / 2, 0).x;
        text = value;
    }

    function hide(item: Item): void {
        if (owner === item) {
            text = "";
            owner = null;
        }
    }
}

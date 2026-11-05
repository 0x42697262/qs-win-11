pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.config
import "../../domain/icons/iconSpec.mjs" as IconSpec
import "../../domain/catalog/icons.mjs" as Icons

Singleton {
    id: root

    readonly property var specs: Settings.values.icons
    readonly property var regularMap: parse(regularFile.text())
    readonly property var filledMap: parse(filledFile.text())
    readonly property var families: ({ regular: Theme.iconFontRegular, filled: Theme.iconFontFilled })

    function parse(text: string): var {
        try {
            return JSON.parse(text);
        } catch (parseError) {
            return {};
        }
    }

    function resolve(key: string, filled: bool): var {
        const spec = specs[key] ?? key;
        return IconSpec.resolveIconSpec(spec, filled, regularMap, filledMap, families);
    }

    FileView {
        id: regularFile
        path: Paths.shellAsset(Icons.IconFontFile.RegularMap)
        blockLoading: true
    }

    FileView {
        id: filledFile
        path: Paths.shellAsset(Icons.IconFontFile.FilledMap)
        blockLoading: true
    }
}

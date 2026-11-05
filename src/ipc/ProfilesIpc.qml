import QtQuick
import Quickshell.Io
import qs.src.config
import qs.src.services
import "../domain/catalog/ipcCatalog.mjs" as IpcCatalog
import "../domain/catalog/system.mjs" as SystemCatalog
import "../domain/settings/presentation.mjs" as Presentation

IpcHandler {
    target: IpcCatalog.IpcTargetName.Profiles

    function list(): string {
        const active = Profiles.listOf(SystemCatalog.ProfileSettingKey.active);
        return JSON.stringify(ProfileLayers.installed.map(name => {
            const state = ProfileLayers.profileState(name, Settings.userOverrides);
            return { name, active: active.indexOf(name) >= 0, description: state.meta.description, activateWhen: state.meta.activateWhen, trusted: state.trusted, problems: state.problems };
        }));
    }

    function activate(name: string): bool {
        return Profiles.activate(name);
    }

    function deactivate(name: string): bool {
        return Profiles.deactivate(name);
    }

    function order(names: string): bool {
        return Profiles.order(Presentation.parseListText(names));
    }

    function create(name: string, sections: string): bool {
        return Profiles.create(name, Presentation.parseListText(sections));
    }

    function absorb(name: string): bool {
        return Profiles.absorb(name);
    }

    function trust(name: string): bool {
        return Profiles.setTrusted(name, true);
    }

    function untrust(name: string): bool {
        return Profiles.setTrusted(name, false);
    }
}

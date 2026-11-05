#!/usr/bin/env bash
set -euo pipefail

readonly SHELL_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
readonly ARTIFACT_DIR="${ARTIFACT_DIR:-$SHELL_DIR/artifacts}"
readonly SCENES_FILE="$SHELL_DIR/tools/ci/scenes.txt"
readonly OUTPUT_RESOLUTION="${OUTPUT_RESOLUTION:-1600x900}"
readonly LOAD_WAIT_SECONDS="${LOAD_WAIT_SECONDS:-4}"
readonly SCENE_WAIT_SECONDS="${SCENE_WAIT_SECONDS:-1}"
readonly QMLLINT="${QMLLINT:-/usr/lib/qt6/bin/qmllint}"
readonly LINT_FALSE_POSITIVE_PATTERN='not declared as singleton in qmldir but using pragma Singleton'
readonly IGNORED_LOG_PATTERN='MESA|ZINK|egl:|dri2|Xwayland|swaybg|UPower service will not work|Could not connect to DBus|Network will not work. Could not find an available backend'

export XDG_RUNTIME_DIR="$(mktemp -d)"
export XDG_CONFIG_HOME="$(mktemp -d)"
export XDG_STATE_HOME="$(mktemp -d)"
export XDG_CACHE_HOME="$(mktemp -d)"
export WLR_BACKENDS=headless WLR_LIBINPUT_NO_DEVICES=1 WLR_RENDERER=pixman
export QT_QPA_PLATFORM=wayland
export QS_WIN11_GALLERY=1
mkdir -p "$ARTIFACT_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

printf 'output HEADLESS-1 resolution %s\n' "$OUTPUT_RESOLUTION" > "$XDG_RUNTIME_DIR/sway.conf"
sway -c "$XDG_RUNTIME_DIR/sway.conf" > "$ARTIFACT_DIR/sway.log" 2>&1 &
for _attempt in $(seq 50); do
    compgen -G "$XDG_RUNTIME_DIR/wayland-[0-9]" > /dev/null && break
    sleep 0.2
done
WAYLAND_DISPLAY="$(basename "$(compgen -G "$XDG_RUNTIME_DIR/wayland-[0-9]" | head -1)")"
export WAYLAND_DISPLAY

for client in ${CI_CLIENTS:-}; do
    "$client" > /dev/null 2>&1 &
done

touch "$SHELL_DIR/.qmlls.ini"
cat > "$XDG_RUNTIME_DIR/session.sh" <<'SESSION'
if command -v pipewire > /dev/null; then
    pipewire > /dev/null 2>&1 &
    sleep 1
    pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=ci-speakers node.description="CI Speakers" media.class=Audio/Sink object.linger=1 audio.position=[FL FR] }' > /dev/null 2>&1
    wireplumber > /dev/null 2>&1 &
    sleep 1
fi
printf '%s' "$DBUS_SESSION_BUS_ADDRESS" > "$XDG_RUNTIME_DIR/bus-address"
exec "$@"
SESSION
dbus-run-session -- sh "$XDG_RUNTIME_DIR/session.sh" qs -p "$SHELL_DIR" --no-color > "$ARTIFACT_DIR/quickshell.log" 2>&1 &
sleep "$LOAD_WAIT_SECONDS"
grim "$ARTIFACT_DIR/00-desktop.png"

if [[ -f "$SCENES_FILE" ]]; then
    while IFS='|' read -r scene_name ipc_call; do
        [[ -z "$scene_name" ]] && continue
        if [[ "$ipc_call" == !* ]]; then
            DBUS_SESSION_BUS_ADDRESS="$(cat "$XDG_RUNTIME_DIR/bus-address")" sh -c "${ipc_call#!}" >> "$ARTIFACT_DIR/ipc.log" 2>&1 || echo "command failed: $ipc_call" >> "$ARTIFACT_DIR/ipc.log"
        else
            read -ra ipc_words <<< "$ipc_call"
            qs -p "$SHELL_DIR" ipc call "${ipc_words[@]}" >> "$ARTIFACT_DIR/ipc.log" 2>&1 || echo "ipc failed: $ipc_call" >> "$ARTIFACT_DIR/ipc.log"
        fi
        sleep "$SCENE_WAIT_SECONDS"
        grim "$ARTIFACT_DIR/$scene_name.png"
    done < "$SCENES_FILE"
fi

build_dir="$(sed -n 's/^buildDir="\(.*\)"$/\1/p' "$SHELL_DIR/.qmlls.ini")"
lint_status=0
if [[ -n "$build_dir" && -d "$build_dir/qs" ]]; then
    lint_root="$(mktemp -d)"
    mkdir -p "$lint_root/qs"
    cp -r "$SHELL_DIR/src" "$SHELL_DIR/shell.qml" "$lint_root/qs/"
    (cd "$build_dir" && find qs -name qmldir -exec cp --parents {} "$lint_root" \;)
    : > "$ARTIFACT_DIR/qmllint.raw.log"
    while IFS= read -r lint_directory; do
        (cd "$lint_root/$lint_directory" && "$QMLLINT" -I "$lint_root" -I /usr/lib/qt6/qml --uncreatable-type disable ./*.qml 2>&1 | sed "s#^Warning: \./#Warning: ${lint_directory#qs/}/#; s#^Warning: \([A-Za-z]\)#Warning: ${lint_directory#qs/}/\1#") >> "$ARTIFACT_DIR/qmllint.raw.log" || true
    done < <(cd "$lint_root" && find qs -name '*.qml' -printf '%h\n' | sort -u)
    grep -v "$LINT_FALSE_POSITIVE_PATTERN" "$ARTIFACT_DIR/qmllint.raw.log" > "$ARTIFACT_DIR/qmllint.log" || true
    grep -q '^Warning:' "$ARTIFACT_DIR/qmllint.log" && lint_status=1
else
    echo "Quickshell did not produce a tooling build dir" > "$ARTIFACT_DIR/qmllint.log"
    lint_status=1
fi

log_problems="$(grep -E 'WARN|ERROR|FATAL|TypeError|ReferenceError' "$ARTIFACT_DIR/quickshell.log" | grep -Ev "$IGNORED_LOG_PATTERN" || true)"
ipc_problems="$(grep -E 'command failed|ipc failed|Error|No such|Too many|Too few|not found|false' "$ARTIFACT_DIR/ipc.log" 2>/dev/null || true)"

cat "$ARTIFACT_DIR/qmllint.log"
[[ -n "$log_problems" ]] && printf 'Runtime problems:\n%s\n' "$log_problems"
[[ -n "$ipc_problems" ]] && printf 'IPC problems:\n%s\n' "$ipc_problems"
if [[ $lint_status -ne 0 || -n "$log_problems" || -n "$ipc_problems" ]]; then
    exit 1
fi
echo "qml-check: clean"

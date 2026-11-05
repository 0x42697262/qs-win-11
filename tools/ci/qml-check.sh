#!/usr/bin/env bash
set -euo pipefail

readonly SHELL_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
readonly ARTIFACT_DIR="${ARTIFACT_DIR:-$SHELL_DIR/artifacts}"
readonly SCENES_FILE="$SHELL_DIR/tools/ci/scenes.txt"
readonly OUTPUT_RESOLUTION="${OUTPUT_RESOLUTION:-1600x900}"
readonly LOAD_WAIT_SECONDS="${LOAD_WAIT_SECONDS:-4}"
readonly SCENE_WAIT_SECONDS="${SCENE_WAIT_SECONDS:-1}"
readonly QMLLINT="${QMLLINT:-/usr/lib/qt6/bin/qmllint}"
readonly IGNORED_LOG_PATTERN='MESA|ZINK|egl:|dri2|Xwayland|swaybg'

export XDG_RUNTIME_DIR="$(mktemp -d)"
export XDG_CONFIG_HOME="$(mktemp -d)"
export XDG_STATE_HOME="$(mktemp -d)"
export XDG_CACHE_HOME="$(mktemp -d)"
export WLR_BACKENDS=headless WLR_LIBINPUT_NO_DEVICES=1 WLR_RENDERER=pixman
export QT_QPA_PLATFORM=wayland
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

touch "$SHELL_DIR/.qmlls.ini"
qs -p "$SHELL_DIR" --no-color > "$ARTIFACT_DIR/quickshell.log" 2>&1 &
sleep "$LOAD_WAIT_SECONDS"
grim "$ARTIFACT_DIR/00-desktop.png"

if [[ -f "$SCENES_FILE" ]]; then
    while IFS='|' read -r scene_name ipc_call; do
        [[ -z "$scene_name" ]] && continue
        read -ra ipc_words <<< "$ipc_call"
        qs -p "$SHELL_DIR" ipc call "${ipc_words[@]}" >> "$ARTIFACT_DIR/ipc.log" 2>&1 || echo "ipc failed: $ipc_call" >> "$ARTIFACT_DIR/ipc.log"
        sleep "$SCENE_WAIT_SECONDS"
        grim "$ARTIFACT_DIR/$scene_name.png"
    done < "$SCENES_FILE"
fi

build_dir="$(sed -n 's/^buildDir="\(.*\)"$/\1/p' "$SHELL_DIR/.qmlls.ini")"
lint_status=0
if [[ -n "$build_dir" && -d "$build_dir/qs" ]]; then
    mapfile -t qml_files < <(find "$build_dir/qs" -name '*.qml' | sort)
    "$QMLLINT" -I "$build_dir" -I /usr/lib/qt6/qml --uncreatable-type disable -W 0 "${qml_files[@]}" > "$ARTIFACT_DIR/qmllint.log" 2>&1 || lint_status=$?
    sed -i "s#$build_dir/qs/##g" "$ARTIFACT_DIR/qmllint.log"
else
    echo "Quickshell did not produce a tooling build dir" > "$ARTIFACT_DIR/qmllint.log"
    lint_status=1
fi

log_problems="$(grep -E 'WARN|ERROR|FATAL|TypeError|ReferenceError' "$ARTIFACT_DIR/quickshell.log" | grep -Ev "$IGNORED_LOG_PATTERN" || true)"
ipc_problems="$(grep -E 'ipc failed|Error|No such' "$ARTIFACT_DIR/ipc.log" 2>/dev/null || true)"

cat "$ARTIFACT_DIR/qmllint.log"
[[ -n "$log_problems" ]] && printf 'Runtime problems:\n%s\n' "$log_problems"
[[ -n "$ipc_problems" ]] && printf 'IPC problems:\n%s\n' "$ipc_problems"
if [[ $lint_status -ne 0 || -n "$log_problems" || -n "$ipc_problems" ]]; then
    exit 1
fi
echo "qml-check: clean"

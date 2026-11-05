import QtQuick
import Quickshell.Wayland
import qs.src.services

WlSessionLock {
    locked: LockState.locked

    LockSurface {}
}

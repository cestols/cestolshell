// shell.qml: shell entry point, loads the singletons and the bar, exposes the shell IPC
//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.cestolshell.bar
import qs.services

ShellRoot {
    id: root

    // Force singleton instantiation at startup
    property var _config: Config
    property var _appearance: Appearance
    property var _hyprlandData: HyprlandData

    // Basic IPC: qs -c cestolshell ipc call shell <function>
    IpcHandler {
        target: "shell"

        function ping(): string {
            return "pong";
        }

        function reload(): void {
            Quickshell.reload(false);
        }
    }

    Bar { }
}

// modules/cestolshell/bar/Bar.qml: top bar
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.common

Scope {
    id: bar

    Variants {
        model: Quickshell.screens

        PanelWindow {

            required property var modelData

            screen: modelData

            anchors {
                top: true
                bottom: false
                left: true
                right: true
            }

            margins {
                top: 5
                left: 5
                right: 5
            }

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "quickshell:bar"

            implicitHeight: 30
            implicitWidth: 30
            color: "#141414"
        }
    }
}

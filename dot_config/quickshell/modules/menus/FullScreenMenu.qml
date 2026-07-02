
import QtQuick

import qs.components
import qs.services

Item {
    id: root
    anchors.centerIn: parent
    width: this.visible ? parent.width : 0
    height: this.visible ? parent.height : 0
    visible: false

    property bool show: false

    onShowChanged: {
        if (this.show) {
            this.visible = true;
        } else {
            this.visible = false;
        }
    }

    WallpaperImage {
        isDecorated: true
        z: -2
        MouseArea {
            anchors.fill: parent
            onClicked: {
                MenuState.close();
            }
        }
    }

    Loader {
        id: loader
        anchors.fill: parent
        active: root.visible
        source: {
            switch (MenuState.type) {
                case MenuState.Type.AppLauncher:
                    return "AppLauncher.qml";
                default:
                    return "";
            }
        }
    }
}

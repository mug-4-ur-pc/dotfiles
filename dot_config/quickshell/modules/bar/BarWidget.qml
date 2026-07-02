
import QtQuick
import QtQuick.Layouts

import qs.config
import qs.modules.popups

Item {
    id: root

    property bool isSelected: false

    property color textColor: {
        this.isSelected ? Config.theme.tertiary : Config.theme.surfaceFg
    }

    property var getPopupText
    property var onLeftClick
    property var onRightClick

    Layout.fillHeight: true

    Behavior on textColor {
        ColorAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    Rectangle {
        id: rectangle

        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            margins: 3
        }

        width: parent.width + Config.bar.spacing / 2
        radius: Config.bar.innerRadius
        color: {
            root.isSelected ? Config.theme.tertiaryFg :
            hoverHandler.hovered ? Config.theme.surfaceVariant : Config.theme.surface
        }
         Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        scale: tapHandler.pressed ? 0.8 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }
        }

        HoverHandler {
            id: hoverHandler
            cursorShape: Qt.PointingHandCursor

            onHoveredChanged: {
                if (root.getPopupText) {
                    if (this.hovered) {
                        popup.title = root.getPopupText();
                    }
                    popup.show = this.hovered;
                }
            }
        }

        TapHandler {
            id: tapHandler
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onTapped: (eventPoint, button) => {
                if (root.onLeftClick && button === Qt.LeftButton) {
                    root.onLeftClick();
                } else if (root.onRightClick && button === Qt.RightButton) {
                    root.onRightClick();
                }
            }
        }
    }

    Item {
        id: innerContainer
        anchors.centerIn: parent
    }

    TextPopup {
        id: popup
    }
}

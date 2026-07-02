
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import qs.config
import qs.components
import qs.utils

Item {
    id: root

    property string textLabel: ""
    property string iconSource: ""
    property bool isSelected: false

    signal clicked()

    width: ListView.view.width
    height: Config.font.size.xl * 3 + Config.bar.margins * 2

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
        onPositionChanged: {
            if (this.hovered) {
                root.ListView.view.currentIndex = this.index
            }
        }
    }

    Item {
        id: container
        anchors.centerIn: parent
        width: parent.width - Config.bar.margins * 2
        height: parent.height - Config.bar.margins

        scale: root.isSelected ? 1.25 : 1.0
        z: root.isSelected ? 10 : 1

        Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

        Loader {
            anchors.fill: parent
            sourceComponent: root.isSelected ? activeBg : inactiveBg
        }

        Component {
            id: inactiveBg
            Rectangle {
                color: Utils.setColorOpacity(Config.theme.surface, 0.4)
                radius: Config.bar.radius
            }
        }

        Component {
            id: activeBg
            DecoratedSurface {}
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: Config.bar.margins
            spacing: Config.bar.margins

            IconImage {
                Layout.preferredWidth: parent.height - Config.bar.margins * 2
                Layout.preferredHeight: parent.height - Config.bar.margins * 2
                Layout.alignment: Qt.AlignVCenter

                asynchronous: true
                source: root.iconSource
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: root.textLabel
                font.family: Config.font.regular
                font.pointSize: Config.font.size.m
                font.weight: Font.Bold
                color: Config.theme.surfaceFg
                elide: Text.ElideRight
            }
        }
    }
}


import QtQuick
import QtQuick.Layouts

import qs.config

BasePopup {
    id: root

    showDelayed: true

    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    property string title: ""
    property string text: ""

    property color bgColor: Config.theme.inverseSurface
    property color fgColor: Config.theme.inverseSurfaceFg

    Rectangle {
        id: container

        radius: Config.popups.radius
        color: root.bgColor
        border.width: 2
        border.color: Config.theme.surface

        implicitHeight: Math.max(this.radius, column.implicitHeight + 20)
        implicitWidth: column.implicitWidth + 20

        ColumnLayout {
            id: column
            anchors.centerIn: parent

            Text {
                id: titleContainer

                color: root.fgColor
                font.family: Config.font.regular
                font.pointSize: Config.font.size.l
                font.weight: Font.Black
                wrapMode: Text.WordWrap

                text: root.title
            }

            Text {
                id: mainContainer

                Layout.fillWidth: true
                Layout.maximumWidth: Config.popups.maxWidth
                visible: this.text !== ""

                color: root.fgColor
                font.family: Config.font.regular
                font.pointSize: Config.font.size.m
                font.weight: Font.Bold
                wrapMode: Text.WordWrap

                text: root.text
            }
        }
    }
}

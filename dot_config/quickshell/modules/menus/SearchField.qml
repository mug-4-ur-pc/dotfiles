
import QtQuick
import QtQuick.Layouts

import qs.config

Rectangle {
    id: root

    property alias placeholderText: placeholderTextContainer.text
    property alias query: input.text

    width: Config.menu.searchWidth
    implicitHeight: layout.implicitHeight + Config.menu.margins * 2
    radius: this.height / 2
    color: Config.theme.secondaryContainer

    RowLayout {
        id: layout
        spacing: Config.menu.margins * 2
        anchors {
            fill: parent
            margins: Config.menu.margins
        }

        Text {
            id: searchIcon

            font.family: Config.font.regular
            font.pointSize: Config.font.size.m
            color: Config.theme.secondaryContainerFg
            text: "  "
        }

        Item {
            id: textElement
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            Text {
                id: placeholderTextContainer
                visible: input.text === ""
                anchors.fill: parent
                font.family: Config.font.regular
                font.pointSize: Config.font.size.l
                color: Config.theme.darkgray
            }
            TextInput {
                id: input
                anchors.fill: parent
                font.family: Config.font.regular
                font.pointSize: Config.font.size.l
                color: Config.theme.secondaryContainerFg
                Component.onCompleted: forceActiveFocus()
            }
        }
    }
}


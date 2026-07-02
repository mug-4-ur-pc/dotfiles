
import QtQuick
import QtQuick.Layouts

import qs.config
import qs.services
import qs.utils

Item {
    id: root
    anchors.fill: parent

    property alias model: listView.model
    property alias text: searchInput.text
    property string placeholderText: ""
    property var onTriggered: (index) => {}
    default property alias delegate: listView.delegate

    onFocusChanged: {
        if (focus) {
            searchInput.forceActiveFocus()
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.4, 600)
        height: Math.min(parent.height * 0.7, 800)
        spacing: Config.bar.spacing * 2

        Rectangle {
            Layout.fillWidth: true
            height: Config.font.size.xl * 3
            color: Utils.setColorOpacity(Config.theme.surface, 0.5)
            radius: Config.bar.radius

            TextInput {
                id: searchInput
                anchors.fill: parent
                anchors.margins: Config.bar.margins
                verticalAlignment: TextInput.AlignVCenter
                font.family: Config.font.regular
                font.pointSize: Config.font.size.l
                color: Config.theme.surfaceFg
                clip: true
                focus: true

                Text {
                    anchors.fill: parent
                    verticalAlignment: TextInput.AlignVCenter
                    text: root.placeholderText
                    color: Utils.setColorOpacity(Config.theme.surfaceFg, 0.4)
                    font: parent.font
                    visible: parent.text.length === 0
                }
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Config.bar.spacing
            boundsBehavior: Flickable.StopAtBounds
            keyNavigationEnabled: true
        }
    }

    Keys.onEscapePressed: MenuState.close()
    Keys.onReturnPressed: {
        if (listView.currentItem && root.onTriggered) {
            root.onTriggered(listView.currentIndex)
        }
    }
    Keys.onUpPressed: listView.decrementCurrentIndex()
    Keys.onDownPressed: listView.incrementCurrentIndex()
}

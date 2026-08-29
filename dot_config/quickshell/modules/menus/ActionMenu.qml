
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import qs.config
import qs.services
import qs.utils

Item {
    id: root
    anchors.fill: parent

    property alias model: view.model
    property bool hasSearch: this.placeholderText !== ""
    property string placeholderText: ""
    property string query: searchPanel.item?.query ?? ""
    property var onTriggered: (item) => {}
    default property alias delegate: view.delegate

    Loader {
        id: searchPanel
        active: root.hasSearch
        y: (root.y + view.y) / 2
        anchors.horizontalCenter: view.horizontalCenter
        sourceComponent: SearchField {
            anchors.centerIn: parent
            placeholderText: root.placeholderText
        }
    }

    GridView {
        id: view
        anchors.centerIn: parent

        height: Config.menu.nRows * this.cellHeight
        width: Config.menu.nColumns * this.cellWidth
        cellHeight: Config.menu.height + Config.menu.spacing
        cellWidth: Config.menu.width + Config.menu.spacing
        clip: true
        focus: true
        boundsBehavior: Flickable.StopAtBounds

        keyNavigationEnabled: true

        function hoverIndex(index: int) {
            if (!hoverBlock.running) {
                this.currentIndex = index;
            }
        }
    }

    WrapperRectangle {
        id: noItemsContainer
        visible: view.count === 0
        anchors.centerIn: view
        color: Utils.setColorOpacity(Config.theme.background, Config.menu.opacity)
        radius: this.height / 2
        margin: Config.menu.margins * 2

        Text {
            color: Config.theme.foreground
            horizontalAlignment: Text.AlignVCenter
            font.family: Config.font.regular
            font.pointSize: Config.font.size.xl
            font.weight: Font.Normal

            text: "No items available"
        }
    }

    onQueryChanged: hoverBlock.running = true

    Timer {
        id: hoverBlock
        interval: 500
        running: true
    }

    Keys.onEscapePressed: MenuState.close()
    Keys.onReturnPressed: this.onTriggered(view.currentIndex);
    Keys.forwardTo: [view]

    Component.onCompleted: {
        if (!this.hasSearch) {
            forceActiveFocus();
        }
    }
}

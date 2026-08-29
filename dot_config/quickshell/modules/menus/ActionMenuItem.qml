
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import qs.config
import qs.utils

WrapperRectangle {
    id: root

    required property var modelData
    required property int index

    property string textLabel: ""
    property string iconSource: ""

    signal clicked()
    signal rclicked()

    height: GridView.view.cellHeight - Config.menu.spacing
    width: GridView.view.cellWidth - Config.menu.spacing
    margin: Config.menu.margins

    radius: Config.menu.radius
    color: Utils.setColorOpacity(root.GridView.isCurrentItem ? Config.theme.inversePrimary : Config.theme.inverseSurface, Config.menu.opacity)

    RowLayout {
        IconImage {
            implicitSize: parent.height
            asynchronous: true
            source: root.iconSource
        }

        Text {
            Layout.fillWidth: true
            Layout.leftMargin: Config.menu.margins

            text: root.textLabel
            color: Config.theme.inverseSurfaceFg

            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter

            font.family: Config.font.regular
            font.pointSize: Config.font.size.xl
            font.weight: Font.Black
        }
    }

    HoverHandler {
        id: hoverHandler
        cursorShape: Qt.PointingHandCursor
        onHoveredChanged: {
            if (this.hovered) {
                root.GridView.view.hoverIndex(root.index);
            }
        }
    }

    TapHandler {
        id: tapHandler
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onTapped: (eventPoint, button) => {
            if (button === Qt.LeftButton) {
                root.clicked();
            } else if (button === Qt.RightButton) {
                root.rclicked();
            }
        }
    }
}

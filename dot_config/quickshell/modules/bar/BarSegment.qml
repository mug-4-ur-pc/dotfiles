
import QtQuick
import QtQuick.Layouts

import qs.config
import qs.components

DecoratedSurface {
    required property string side
    default property alias widgets: widgetsLayout.data

    anchors {
        top: Config.bar.onTop ? parent.top : undefined
        bottom: Config.bar.onTop ? undefined : parent.bottom

        left: edgeLeft ? parent.left : undefined
        right: edgeRight ? parent.right : undefined

        margins: Config.bar.margins
    }

    implicitWidth: widgetsLayout.implicitWidth + 2 * Config.bar.spacing
    height: Config.bar.height

    edgeLeft: side === "left"
    edgeRight: side === "right"

    RowLayout {
        id: widgetsLayout
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        spacing: Config.bar.spacing
    }

    MouseArea {
        anchors.fill: parent
        z: -1
    }
}

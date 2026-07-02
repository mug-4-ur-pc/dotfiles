
import QtQuick

 import qs.services

Item {
    id: root

    required property bool isDecorated

    anchors.fill: parent

    Image {
        id: imgContainer
        anchors.fill: parent
        source: root.isDecorated ? WallpaperService.decoratedPath : WallpaperService.origPath
        smooth: true
    }
}

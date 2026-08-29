
import QtQuick

 import qs.services

Image {
    required property bool isDecorated

    anchors.fill: parent
    source: this.isDecorated ? WallpaperService.decoratedPath : WallpaperService.origPath
    smooth: true
}

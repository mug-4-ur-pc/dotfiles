
import QtQuick
import QtQuick.Layouts

import qs.config
import qs.services

BarWidget {
    id: root

    implicitWidth: textContainer.implicitWidth

    getPopupText: () => { return "Next keyboard layout" }

    Text {
        id: textContainer
        anchors.centerIn: parent

        verticalAlignment: Text.AlignVCenter

        color: root.textColor

        font.family: Config.font.serif
        font.pixelSize: parent.height * Config.bar.layoutScale
        font.weight: Font.Normal

        text: "en"
    }
}

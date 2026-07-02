
import QtQuick
import QtQuick.Layouts

import qs.config
import qs.services

BarWidget {
    id: root

    implicitWidth: textContainer.implicitWidth

    getPopupText: () => { return "Calendar" }

    Text {
        id: textContainer
        anchors.centerIn: parent

        verticalAlignment: Text.AlignVCenter

        color: root.textColor

        font.family: Config.font.serif
        font.pixelSize: parent.height * Config.bar.clockScale
        font.weight: Font.Bold

        text: Time.format(" dd MMM. ")
    }
}


import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.config
import qs.modules.menus
import qs.services

// qmllint disable
PanelWindow {
    // qmllint enable
    id: root

    required property ShellScreen modelData
    screen: modelData

    anchors {
        left: true
        right: true
        bottom: !Config.bar.onTop
        top: Config.bar.onTop
    }

    color: "transparent"
    implicitHeight: screen.height
    // implicitHeight: {
    //     const inner = Config.bar.height + Config.bar.margins;
    //     const outer = Math.max(Config.bar.margins, this.shadowHeight);
    //     return inner + outer;
    // }

    exclusiveZone: Config.bar.height + Config.bar.margins
    mask: Region {
        Region { item: fullScreenMenu }
        Region { item: leftSegment }
        Region { item: middleSegment }
        Region { item: rightSegment }
    }

    readonly property int shadowHeight: leftSegment.shadowHeight
    readonly property bool isMenuOpened: MenuState.isOpened(this.screen)

    FullScreenMenu {
        id: fullScreenMenu
        show: root.isMenuOpened
    }

    BarSegment {
        id: leftSegment
        side: "left"

        AppLauncherModule { targetScreen: root.screen }
        // CliphistModule {}
        EmptyModule {}
        // WorkspacesModule {}
        EmptyModule {}
        // DashboardModule {}
        // PowerMenuModule {}
    }

    ActiveWindowModule {
        id: middleSegment
        anchors {
            verticalCenter: leftSegment.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        height: Config.bar.height
    }

    BarSegment {
        id: rightSegment
        side: "right"

        // VolumeModule {}
        // MicModule {}
        EmptyModule {}
        // UpdateModule {}
        // AirplaneModule {}
        // BluetoothModule {}
        // NetworkModule {}
        KeyboardLayoutModule {}
        DateModule {}
        TimeModule {}
        // NotificationModule {}
    }
}

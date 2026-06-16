pragma Singleton

import Quickshell

import qs.services

Singleton {
    id: root

    readonly property bool initialized: Chezmoi.isReady

    property bool barEnabled: true

    readonly property bool isLaptop: Chezmoi.data?.is_laptop ?? false
}

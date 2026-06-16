pragma Singleton

import Quickshell

Singleton {
    id: root

    property alias enabled: clock.enabled
    readonly property alias date: clock.date
    readonly property alias minutes: clock.minutes
    readonly property alias hours: clock.hours

    function  format(fmt: string): string {
        return Qt.formatDateTime(date, fmt)
    }

    SystemClock {
        id: clock
        enabled: true
        precision: SystemClock.Minutes
    }
}

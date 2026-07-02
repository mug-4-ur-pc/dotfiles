
import QtQuick
import Quickshell

import qs.services

ActionMenu {
    id: root

    placeholderText: "Search applications..."
    model: DesktopEntries.applications

    onTriggered: (index) => {
        const app = model.values[index];
        if (app) {
            Quickshell.execDetached({
                command: app.command,
                workingDirectory: app.workingDirectory,
            });
        }
        MenuState.close();
    }

    ActionMenuItem {
        textLabel: model.name
        iconSource: model.icon
        isSelected: ListView.isCurrentItem
        onClicked: {
            root.onTriggered(index)
        }
    }
}

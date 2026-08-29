
import QtQuick
import Quickshell

import qs.services

ActionMenu {
    id: root

    hasSearch: true
    placeholderText: "Search applications..."
    model: ScriptModel {
        values: {
            const q = root.query.toLowerCase();
            return [...DesktopEntries.applications.values].filter(e => {
                return !e.noDisplay
                && (e.name.toLowerCase().includes(q)
                    || e.genericName.toLowerCase().includes(q)
                    || e.comment.toLowerCase().includes(q)
                );
            }).sort((a, b) => {
                return a.name.localeCompare(b.name);
            });
        }
    }

    onTriggered: (index) => {
        const app = model.values[index];
        var cmd = app.command;
        if (app.runInTerminal) {
            cmd = [Quickshell.env("TERMINAL"), "-e", ...cmd];
        }
        Quickshell.execDetached({
            command: cmd,
            workingDirectory: app.workingDirectory,
        });
        MenuState.close();
    }

    ActionMenuItem {
        textLabel: modelData.name
        iconSource: Quickshell.iconPath(modelData.icon, true)
        onClicked: root.onTriggered(index)
    }
}

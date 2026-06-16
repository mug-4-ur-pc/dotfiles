
import Quickshell
import Quickshell.Io

import qs.services

FileView {
    property var json: {{}}

    path: Quickshell.statePath("config.json")
    blockLoading: true
    watchChanges: true

    onFileChanged: this.reload()

    onLoaded: {
        try {
            this.json = JSON.parse(this.text());
            Logger.info("Config", "Loaded");
            Logger.debug("Config", this.json);
        } catch (e) {
            Logger.error("Config", "Failed to load config", e);
        }
    }

    onLoadFailed: err => {
        if (err === FileViewError.FileNotFound) {
            this.reset();
            this.save();
        }
    }

    function set(key: string, value) {
        if (value === undefined || value === null) {
            this.unset(key);
            return;
        }
        if (key === "") {
            Logger.error("Config", "Trying to set config param with no key");
            return;
        }

        const keys = key.split('.');
        let current = this.json;

        for (let i = 0; i < keys.length - 1; i++) {
            const k = keys[i];
            if (!current[k] || typeof current[k] !== 'object') {
                current[k] = {};
            }

            current = current[k];
        }

        const finalKey = keys[keys.length - 1];
        current[finalKey] = value;

        Logger.debug("Config", `Set ${key} = ${value}`)
    }

    function unset(key: string) {
        if (key === "") {
            Logger.error("Config", "Trying to unset config param with no key");
            return;
        }

        const keys = key.split('.');
        let current = this.json;

        for (let i = 0; i < keys.length - 1; i++) {
            const k = keys[i];
            if (!current[k] || typeof current[k] !== 'object') {
                return;
            }

            current = current[k];
        }

        const finalKey = keys[keys.length - 1];
        delete current[finalKey];

        Logger.debug("Config", `Unset ${key}`)
    }

    function reset() {
        this.json = {};
        Logger.debug("Config", `Reset custom config options`)
    }

    function save() {
        Logger.info("Config", "Saving custom config options", this.json);
        const payload = JSON.stringify(this.json);
        this.setText(payload);
    }
}

pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string clockFormat: "HH:mm"
    property string dateFormat: "dd/MM/yyyy"
    property int volumeStep: 5
    property int batteryWarning: 20
    property int batteryCritical: 10
    property var widgets: ["volume", "battery", "bluetooth", "wifi", "tray", "power"]

    FileView {
        id: configFile
        path: Qt.resolvedUrl("../config/bar-config.json")
        onLoaded: {
            try {
                var config = JSON.parse(text)
                if (config.clockFormat) root.clockFormat = config.clockFormat
                if (config.dateFormat) root.dateFormat = config.dateFormat
                if (config.volumeStep) root.volumeStep = config.volumeStep
                if (config.batteryWarningThreshold) root.batteryWarning = config.batteryWarningThreshold
                if (config.batteryCriticalThreshold) root.batteryCritical = config.batteryCriticalThreshold
            } catch (e) {
                console.log("ConfigService: Using defaults -", e)
            }
        }
    }
}

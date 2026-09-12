pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int percentage: 0
    property string status: "unknown"
    property bool present: false
    property bool available: true

    property string _batPath: ""

    Component.onCompleted: {
        _detectBattery()
    }

    function _detectBattery() {
        detectProc.running = true
    }

    Process {
        id: detectProc
        command: ["bash", "-c", "test -d /sys/class/power_supply/BAT0 && echo BAT0 || (test -d /sys/class/power_supply/BAT1 && echo BAT1 || echo NONE)"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                var result = detectProc.stdout.text.trim()
                if (result === "BAT0") {
                    root._batPath = "/sys/class/power_supply/BAT0"
                    root.present = true
                    root.available = true
                    pollTimer.start()
                } else if (result === "BAT1") {
                    root._batPath = "/sys/class/power_supply/BAT1"
                    root.present = true
                    root.available = true
                    pollTimer.start()
                } else {
                    root.present = false
                    root.available = false
                }
            }
        }
    }

    Process {
        id: batProc
        command: ["bash", "-c", "cat " + root._batPath + "/capacity 2>/dev/null; echo '---'; cat " + root._batPath + "/status 2>/dev/null"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                var output = batProc.stdout.text.trim()
                var lines = output.split("\n")
                if (lines.length >= 3) {
                    root.percentage = parseInt(lines[0]) || 0
                    root.status = lines[2].trim()
                    root.available = true
                }
            }
        }
        onExited: (code, status) => {
            if (code !== 0) {
                root.available = false
            }
            if (root.present) {
                pollTimer.start()
            }
        }
    }

    Timer {
        id: pollTimer
        interval: 5000
        running: false
        repeat: false
        onTriggered: batProc.running = true
    }
}

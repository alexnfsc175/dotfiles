pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real volume: 0
    property bool muted: false
    property string deviceName: ""
    property bool available: true

    function refreshImmediate() {
        pollTimer.interval = 50
        pollTimer.start()
    }

    function setVolume(level) {
        var clamped = Math.max(0, Math.min(100, level))
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", (clamped / 100).toFixed(2)])
        refreshImmediate()
    }

    function increaseVolume(step) {
        var s = step || 5
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", s + "%+"])
        refreshImmediate()
    }

    function decreaseVolume(step) {
        var s = step || 5
        Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", s + "%-"])
        refreshImmediate()
    }

    function toggleMute() {
        Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"])
        refreshImmediate()
    }

    Process {
        id: volumeProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: false
        stdout: StdioCollector {
            id: volumeCollector
            onStreamFinished: {
                var txt = volumeCollector.text.trim()
                if (txt.length === 0) return
                var parts = txt.split(" ")
                if (parts.length >= 2) {
                    var rawVol = parseFloat(parts[1]) || 0
                    root.volume = Math.round(rawVol * 100)
                    root.muted = txt.includes("[MUTED]")
                    root.available = true
                }
            }
        }
        onExited: (code, status) => {
            if (code !== 0) {
                root.available = false
            }
            pollTimer.interval = 3000
            pollTimer.start()
        }
    }

    Timer {
        id: pollTimer
        interval: 1500
        running: true
        repeat: false
        onTriggered: volumeProc.running = true
    }
}

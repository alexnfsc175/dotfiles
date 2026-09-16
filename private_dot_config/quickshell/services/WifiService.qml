pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string ssid: ""
    property bool connected: false
    property int signal: 0
    property string ip: ""
    property bool available: true
    property bool enabled: true
    property bool scanning: false
    property string connectionState: "disconnected"
    property string lastError: ""
    property string wifiInterface: ""
    property var connectionDetails: ({})

    property alias networks: networkModel

    ListModel {
        id: networkModel
    }

    signal connectionSucceeded()
    signal connectionFailed(string error)

    function connect(targetSsid, password) {
        if (connectionState === "connecting") return
        connectionState = "connecting"
        lastError = ""
        var cmd = ["nmcli", "dev", "wifi", "connect", targetSsid]
        if (password && password.length > 0) {
            cmd.push("password", password)
        }
        connectProc.command = cmd
        connectProc.running = true
    }

    function disconnect() {
        if (!connected || connectionState === "disconnecting") return
        connectionState = "disconnecting"
        lastError = ""
        disconnectProc.command = ["nmcli", "dev", "disconnect", wifiInterface]
        disconnectProc.running = true
    }

    function forget(targetSsid) {
        forgetProc.command = ["nmcli", "connection", "delete", "id", targetSsid]
        forgetProc.running = true
    }

    function toggleWifi() {
        var cmd = enabled ? ["nmcli", "radio", "wifi", "off"] : ["nmcli", "radio", "wifi", "on"]
        toggleProc.command = cmd
        toggleProc.running = true
    }

    function refresh() {
        listProc.running = false
        listPollTimer.stop()
        rescanDelayTimer.stop()
        scanning = true
        scanningTimeoutTimer.start()
        rescanProc.running = true
    }

    function signalLevel(sig) {
        if (sig < 25) return "weak"
        if (sig < 50) return "low"
        if (sig < 75) return "medium"
        return "high"
    }

    function securityLabel(sec) {
        if (!sec || sec.length === 0) return ""
        if (sec.indexOf("WPA3") !== -1) return "WPA3"
        if (sec.indexOf("WPA2") !== -1) return "WPA2"
        if (sec.indexOf("WPA") !== -1) return "WPA"
        if (sec.indexOf("WEP") !== -1) return "WEP"
        if (sec.indexOf("802.1X") !== -1) return "Enterprise"
        return sec
    }

    function isNetworkSecured(sec) {
        return sec && sec.length > 0
    }

    function bandFromFreq(freq) {
        if (freq < 3000) return "2.4 GHz"
        if (freq < 6000) return "5 GHz"
        return "6 GHz"
    }

    function generationFromSpeed(speed, freq) {
        var mbps = parseInt(speed) || 0
        if (freq >= 6000) return "Wi-Fi 6E"
        if (mbps > 2400) return "Wi-Fi 6"
        if (mbps > 600) return "Wi-Fi 5"
        return "Wi-Fi 4"
    }

    function syncNetworkModel(parsed) {
        var toRemove = []
        for (var i = 0; i < networkModel.count; i++) {
            var existing = networkModel.get(i)
            var found = false
            for (var j = 0; j < parsed.length; j++) {
                if (parsed[j].ssid === existing.ssid && parsed[j].bssid === existing.bssid) {
                    networkModel.set(i, {
                        active: parsed[j].active,
                        ssid: parsed[j].ssid,
                        signal: parsed[j].signal,
                        security: parsed[j].security,
                        bars: parsed[j].bars,
                        frequency: parsed[j].frequency,
                        bssid: parsed[j].bssid,
                        channel: parsed[j].channel,
                        saved: existing.saved
                    })
                    parsed.splice(j, 1)
                    found = true
                    break
                }
            }
            if (!found) {
                toRemove.push(i)
            }
        }
        for (var k = toRemove.length - 1; k >= 0; k--) {
            networkModel.remove(toRemove[k])
        }
        for (var m = 0; m < parsed.length; m++) {
            networkModel.append(parsed[m])
        }
    }

    function splitEscaped(str, delim) {
        var parts = []
        var current = ""
        for (var i = 0; i < str.length; i++) {
            if (str[i] === "\\" && i + 1 < str.length) {
                current += str[i + 1]
                i++
            } else if (str[i] === delim) {
                parts.push(current)
                current = ""
            } else {
                current += str[i]
            }
        }
        parts.push(current)
        return parts
    }

    function unescapeField(str) {
        return str
    }

    function formatUptime(timestamp) {
        if (!timestamp || timestamp <= 0) return ""
        var now = Math.floor(Date.now() / 1000)
        var diff = now - timestamp
        if (diff < 0) return ""
        var hours = Math.floor(diff / 3600)
        var minutes = Math.floor((diff % 3600) / 60)
        if (hours > 0) return hours + "h " + minutes + "m"
        return minutes + "m"
    }

    Process {
        id: listProc
    command: ["nmcli", "-t", "-f", "active,ssid,signal,security,bars,freq,bssid,chan", "dev", "wifi", "list"]
    running: false
    environment: ({ LANG: "C", LC_ALL: "C" })
    stdout: StdioCollector {
        id: listCollector
        onStreamFinished: {
            var output = listCollector.text.trim()
            var lines = output.split("\n")
            var parsed = []
            for (var i = 0; i < lines.length; i++) {
                var line = lines[i].trim()
                if (line.length === 0) continue
                var fields = root.splitEscaped(line, ":")
                if (fields.length < 8) continue
                parsed.push({
                    active: fields[0] === "yes",
                    ssid: root.unescapeField(fields[1]),
                    signal: parseInt(fields[2]) || 0,
                    security: root.unescapeField(fields[3]),
                    bars: root.unescapeField(fields[4]),
                    frequency: parseInt(fields[5]) || 0,
                    bssid: root.unescapeField(fields[6]),
                    channel: parseInt(fields[7]) || 0,
                    saved: false
                })
            }
            root.syncNetworkModel(parsed)
            for (var r = 0; r < networkModel.count; r++) {
                if (networkModel.get(r).active) {
                    root.signal = networkModel.get(r).signal
                    break
                }
            }
            checkSavedProc.running = true
        }
    }
    onExited: (code, status) => {
        root.scanning = false
        scanningTimeoutTimer.running = false
        listPollTimer.start()
    }
    }

    Process {
        id: radioProc
        command: ["nmcli", "-t", "-f", "WIFI", "radio"]
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: radioCollector
            onStreamFinished: {
                var output = radioCollector.text.trim()
                root.enabled = output === "enabled"
            }
        }
        onExited: (code, status) => {
            radioPollTimer.start()
        }
    }

    Process {
        id: detailsProc
        command: ["nmcli", "-t", "-f", "GENERAL,IP4,IP6,CONNECTION", "dev", "show"]
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: detailsCollector
            onStreamFinished: {
                var output = detailsCollector.text.trim()
                var lines = output.split("\n")
                var details = {}
                var currentDevice = ""
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim()
                    if (line.length === 0) continue
                    var colonIdx = line.indexOf(":")
                    if (colonIdx < 0) continue
                    var key = line.substring(0, colonIdx)
                    var value = line.substring(colonIdx + 1)
                    if (key === "GENERAL.DEVICE") {
                        currentDevice = value
                    }
                    if (key === "GENERAL.TYPE" && value === "wifi") {
                        details.interface = currentDevice
                        root.wifiInterface = currentDevice
                    }
                    if (key === "GENERAL.HWADDR") details.mac = value
                    if (key === "GENERAL.SPEED") details.linkSpeed = value
                    if (key === "GENERAL.CONNECTION-TS") details.uptime = parseInt(value) || 0
                    if (key === "IP4.ADDRESS[1]") details.ipv4 = value
                    if (key === "IP4.GATEWAY[1]") details.gateway = value
                    if (key === "IP4.DNS[1]") details.dns = value
                    if (key === "IP6.ADDRESS[1]") details.ipv6 = value
                }
                if (root.connected) {
                    var foundSignal = 0
                    var foundSsid = ""
                    var foundSecurity = ""
                    var foundFreq = 0
            for (var k = 0; k < networkModel.count; k++) {
                    if (networkModel.get(k).active) {
                        foundSignal = networkModel.get(k).signal
                        foundSsid = networkModel.get(k).ssid
                        foundSecurity = networkModel.get(k).security
                        foundFreq = networkModel.get(k).frequency
                            break
                        }
                    }
                    details.signal = foundSignal
                    details.ssid = foundSsid
                    details.security = foundSecurity
                    details.frequency = foundFreq
                    details.band = root.bandFromFreq(foundFreq)
                    var speedMbps = parseInt(details.linkSpeed) || 0
                    details.generation = root.generationFromSpeed(speedMbps, foundFreq)
                }
                root.connectionDetails = details
            }
        }
        onExited: (code, status) => {
            detailsPollTimer.start()
        }
    }

    Process {
        id: checkSavedProc
        command: ["nmcli", "-t", "-f", "NAME", "connection", "show"]
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: savedCollector
            onStreamFinished: {
                var output = savedCollector.text.trim()
                var savedNames = output.split("\n")
                for (var i = 0; i < networkModel.count; i++) {
                    var entry = networkModel.get(i)
                    var found = false
                    for (var j = 0; j < savedNames.length; j++) {
                        if (savedNames[j].trim() === entry.ssid) {
                            found = true
                            break
                        }
                    }
                    networkModel.setProperty(i, "saved", found)
                }
            }
        }
    }

    Process {
        id: connectProc
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: connectStdout
        }
        stderr: StdioCollector {
            id: connectStderr
        }
        onExited: (code, status) => {
            if (code === 0) {
                root.connectionState = "connected"
                root.connected = true
                root.lastError = ""
                root.connectionSucceeded()
            } else {
                root.connectionState = "failed"
                var errText = connectStderr.text.trim()
                if (errText.length === 0) errText = connectStdout.text.trim()
                if (code === 10) {
                    root.lastError = "Incorrect password"
                } else if (code === 4) {
                    root.lastError = "Network not found"
                } else {
                    root.lastError = errText.length > 0 ? errText : "Connection failed"
                }
                root.connectionFailed(root.lastError)
            }
            refreshTimer.start()
        }
    }

    Process {
        id: disconnectProc
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: disconnectStdout
        }
        stderr: StdioCollector {
            id: disconnectStderr
        }
        onExited: (code, status) => {
            if (code === 0) {
                root.connectionState = "disconnected"
                root.connected = false
                root.ssid = ""
                root.connectionDetails =({})
            } else {
                root.connectionState = "failed"
                root.lastError = disconnectStderr.text.trim() || "Disconnect failed"
            }
            refreshTimer.start()
        }
    }

    Process {
        id: forgetProc
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: forgetStdout
        }
        stderr: StdioCollector {
            id: forgetStderr
        }
        onExited: (code, status) => {
            refreshTimer.start()
        }
    }

    Process {
        id: toggleProc
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: toggleStdout
        }
        stderr: StdioCollector {
            id: toggleStderr
        }
        onExited: (code, status) => {
            if (code === 0) {
                root.enabled = !root.enabled
                if (root.enabled) {
                    root.scanning = true
                } else {
                    networkModel.clear()
                    root.connected = false
                    root.ssid = ""
                    root.connectionState = "disconnected"
                    root.connectionDetails =({})
                }
            }
            refreshTimer.start()
        }
    }

    Process {
        id: rescanProc
        command: ["nmcli", "dev", "wifi", "rescan"]
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        onExited: (code, status) => {
            if (code !== 0) {
                root.scanning = false
                scanningTimeoutTimer.running = false
            }
            rescanDelayTimer.start()
        }
    }

    Process {
        id: activeSsidProc
        command: ["nmcli", "-t", "-f", "active,ssid", "dev", "wifi"]
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: activeSsidCollector
            onStreamFinished: {
                var output = activeSsidCollector.text.trim()
                var lines = output.split("\n")
                var found = false
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim()
                    if (line.startsWith("yes:")) {
                        root.ssid = line.substring(4)
                        root.connected = true
                        root.available = true
                        if (root.connectionState !== "connecting" && root.connectionState !== "disconnecting") {
                            root.connectionState = "connected"
                        }
                        found = true
                        break
                    }
                }
                if (!found) {
                    root.ssid = ""
                    root.connected = false
                    if (root.connectionState !== "connecting" && root.connectionState !== "disconnecting") {
                        root.connectionState = "disconnected"
                    }
                }
            }
        }
        onExited: (code, status) => {
            if (code !== 0) {
                root.available = false
            }
            ssidPollTimer.start()
        }
    }

    Timer {
        id: ssidPollTimer
        interval: 3500
        running: true
        repeat: false
        onTriggered: {
            interval = 12000
            activeSsidProc.running = true
            radioProc.running = true
            if (root.connected) {
                detailsProc.running = true
            }
        }
    }

    Timer {
        id: listPollTimer
        interval: 25000
        running: false
        repeat: false
        onTriggered: {
            if (root.enabled) {
                listProc.running = true
            }
        }
    }

    Timer {
        id: radioPollTimer
        interval: 20000
        running: false
        repeat: false
        onTriggered: radioProc.running = true
    }

    Timer {
        id: detailsPollTimer
        interval: 15000
        running: false
        repeat: false
        onTriggered: {
            if (root.connected) {
                detailsProc.running = true
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            activeSsidProc.running = true
            listProc.running = true
        }
    }

    Timer {
        id: rescanDelayTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: {
            listProc.running = true
        }
    }

    Timer {
        id: scanningTimeoutTimer
        interval: 10000
        running: false
        repeat: false
        onTriggered: {
            root.scanning = false
        }
    }
}

pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string adapterName: ""
    property string adapterAddress: ""
    property bool powered: false
    property bool discoverable: false
    property bool discovering: false
    property bool available: false
    property bool scanning: false
    property string lastError: ""
    property var pairingSession: null

    ListModel {
        id: devicesModel
    }

    readonly property alias devices: devicesModel
    readonly property var connectedDevices: {
        var result = []
        for (var i = 0; i < devicesModel.count; i++) {
            var d = devicesModel.get(i)
            if (d.connected) result.push(d)
        }
        return result
    }
    readonly property var pairedDevices: {
        var result = []
        for (var i = 0; i < devicesModel.count; i++) {
            var d = devicesModel.get(i)
            if (d.paired && !d.connected) result.push(d)
        }
        return result
    }
    readonly property var nearbyDevices: {
        var result = []
        for (var i = 0; i < devicesModel.count; i++) {
            var d = devicesModel.get(i)
            if (!d.paired) result.push(d)
        }
        return result
    }

    signal deviceConnected(string address)
    signal deviceDisconnected(string address)
    signal devicePaired(string address)
    signal deviceRemoved(string address)
    signal operationFailed(string address, string error)

    function toggle() {
        if (root.powered) {
            toggleProc.command = ["bluetoothctl", "power", "off"]
        } else {
            toggleProc.command = ["bluetoothctl", "power", "on"]
        }
        toggleProc.running = true
    }

    function connect(address) {
        var dev = findDevice(address)
        if (dev && dev.state === "connecting") return
        setDeviceState(address, "connecting")
        connectProc.command = ["bluetoothctl", "connect", address]
        connectProc.running = true
    }

    function disconnect(address) {
        var dev = findDevice(address)
        if (dev && dev.state === "disconnecting") return
        setDeviceState(address, "disconnecting")
        disconnectProc.command = ["bluetoothctl", "disconnect", address]
        disconnectProc.running = true
    }

    function pair(address) {
        var dev = findDevice(address)
        if (dev && dev.state === "pairing") return
        setDeviceState(address, "pairing")
        pairProc.command = ["bluetoothctl", "pair", address]
        pairProc.running = true
    }

    function remove(address) {
        var dev = findDevice(address)
        if (dev && dev.connected) {
            Quickshell.execDetached(["bluetoothctl", "disconnect", address])
        }
        removeProc.command = ["bluetoothctl", "remove", address]
        removeProc.running = true
    }

    function refresh() {
        adapterProc.running = true
        devicesProc.running = true
    }

    function scan() {
        if (!root.powered) return
        scanning = true
        scanProc.command = ["bluetoothctl", "--timeout", "25", "scan", "on"]
        scanProc.running = true
        scanPollTimer.start()
    }

    function deviceTypeFromDeviceClass(deviceClass) {
        if (!deviceClass) return "device"
        var classNum = parseInt(deviceClass)
        if (isNaN(classNum)) return "device"
        var major = (classNum >> 8) & 0x1F
        var minor = (classNum >> 2) & 0x3F

        switch (major) {
            case 1: return "device"
            case 2: return "phone"
            case 4:
                if (minor <= 3) return "speaker"
                return "speaker"
            case 5:
                if (minor === 1 || minor === 3 || minor === 16) return "keyboard"
                if (minor === 2 || minor === 5) return "mouse"
                if (minor >= 4 && minor <= 8) return "gamepad"
                return "keyboard"
            case 6: return "device"
            default: return "device"
        }
    }

    function findDeviceIndex(address) {
        for (var i = 0; i < devicesModel.count; i++) {
            if (devicesModel.get(i).address === address) return i
        }
        return -1
    }

    function findDevice(address) {
        var idx = findDeviceIndex(address)
        return idx >= 0 ? devicesModel.get(idx) : null
    }

    function setDeviceState(address, state) {
        var idx = findDeviceIndex(address)
        if (idx >= 0) {
            devicesModel.set(idx, { state: state })
        }
    }

    function syncDevices(parsed) {
        var existingAddrs = {}
        for (var i = 0; i < devicesModel.count; i++) {
            existingAddrs[devicesModel.get(i).address] = i
        }

        var parsedAddrs = {}
        for (var j = 0; j < parsed.length; j++) {
            parsedAddrs[parsed[j].address] = true
        }

        for (var k = devicesModel.count - 1; k >= 0; k--) {
            if (!parsedAddrs[devicesModel.get(k).address]) {
                devicesModel.remove(k)
            }
        }

        for (var m = 0; m < parsed.length; m++) {
            var p = parsed[m]
            if (existingAddrs[p.address] !== undefined) {
                var idx = existingAddrs[p.address]
                devicesModel.set(idx, { name: p.name, mac: p.mac })
            } else {
                devicesModel.append({
                    address: p.address,
                    name: p.name,
                    connected: false,
                    paired: false,
                    state: "idle",
                    deviceType: "device",
                    battery: -1,
                    mac: p.mac
                })
            }
        }
    }

    function parseAdapterInfo(output) {
        var lines = output.split("\n")
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            if (line.indexOf("Name:") === 0) {
                adapterName = line.substring(5).trim()
            } else if (line.indexOf("Address:") === 0) {
                adapterAddress = line.substring(8).trim()
            } else if (line.indexOf("Controller ") === 0) {
                var parts = line.split(" ")
                if (parts.length >= 2) {
                    adapterAddress = parts[1]
                }
            } else if (line.indexOf("Powered:") === 0) {
                powered = line.indexOf("yes") !== -1
            } else if (line.indexOf("Discoverable:") === 0) {
                discoverable = line.indexOf("yes") !== -1
            } else if (line.indexOf("Discovering:") === 0) {
                discovering = line.indexOf("yes") !== -1
            }
        }
        available = true
    }

    function parseBatteryFromInfo(output) {
        var lines = output.split("\n")
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            if (line.indexOf("Battery Percentage:") === 0) {
                var val = line.substring(19).trim()
                var num = parseInt(val)
                if (!isNaN(num)) return num
            }
        }
        return -1
    }

    function deviceTypeFromIcon(iconName) {
        if (!iconName) return ""
        switch (iconName) {
            case "input-keyboard": return "keyboard"
            case "input-mouse": return "mouse"
            case "input-gaming": return "gamepad"
            case "audio-speakers":
            case "audio-card": return "speaker"
            case "audio-headphones":
            case "audio-headset": return "headset"
            case "phone": return "phone"
            case "computer": return "computer"
            case "camera-webcam":
            case "camera-photo": return "camera"
            case "watch": return "watch"
            default: return ""
        }
    }

    function parseDeviceTypeFromInfo(output) {
        var lines = output.split("\n")
        var classStr = ""
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            if (line.indexOf("Icon:") === 0) {
                var iconName = line.substring(5).trim()
                var iconType = deviceTypeFromIcon(iconName)
                if (iconType) return iconType
            }
            if (line.indexOf("Class:") === 0 && !classStr) {
                classStr = line.substring(6).trim()
                var spaceIdx = classStr.indexOf(" ")
                if (spaceIdx !== -1) {
                    classStr = classStr.substring(0, spaceIdx)
                }
            }
        }
        if (classStr) return deviceTypeFromDeviceClass(classStr)
        return "device"
    }

    function detectAudioCodec(address) {
        if (!address) return
        audioCodecProc.command = ["pactl", "list", "sinks"]
        audioCodecProc._targetAddress = address
        audioCodecProc.running = true
    }

    function parseAudioCodec(output, address) {
        var lines = output.split("\n")
        var currentDevice = ""
        var profile = ""
        var codec = ""
        var foundBt = false

        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            if (line.indexOf("Name:") === 0) {
                currentDevice = line.substring(5).trim()
                foundBt = currentDevice.indexOf("bluez") !== -1
            }
            if (foundBt && line.indexOf("Active Port:") === 0) {
                var port = line.substring(13).trim()
                if (port.indexOf("a2dp") !== -1) {
                    profile = "A2DP"
                } else if (port.indexOf("headset") !== -1) {
                    profile = "HFP"
                } else if (port.indexOf("handsfree") !== -1) {
                    profile = "HSP"
                }
            }
            if (foundBt && line.indexOf("Active Profile:") === 0) {
                var prof = line.substring(16).trim()
                if (prof.indexOf("a2dp") !== -1) {
                    profile = "A2DP"
                } else if (prof.indexOf("headset") !== -1) {
                    profile = "HFP"
                } else if (prof.indexOf("handsfree") !== -1) {
                    profile = "HSP"
                }
            }
        }

        var idx = findDeviceIndex(address)
        if (idx >= 0) {
            devicesModel.set(idx, { profile: profile, codec: codec })
        }
    }

    Process {
        id: adapterProc
        command: ["bluetoothctl", "show"]
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: adapterCollector
            onStreamFinished: {
                root.parseAdapterInfo(adapterCollector.text)
            }
        }
        stderr: StdioCollector {
            id: adapterStderr
        }
        onExited: (code, status) => {
            if (code !== 0) {
                root.available = false
                root.lastError = adapterStderr.text.trim()
            }
            adapterPollTimer.start()
        }
    }

    Process {
        id: devicesProc
        command: ["bluetoothctl", "devices"]
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: devicesCollector
            onStreamFinished: {
                var output = devicesCollector.text.trim()
                var lines = output.split("\n")
                var parsed = []
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim()
                    if (line.indexOf("Device ") !== 0) continue
                    var parts = line.split(" ")
                    if (parts.length >= 3) {
                        var address = parts[1]
                        var name = parts.slice(2).join(" ")
                        parsed.push({
                            address: address,
                            name: name,
                            connected: false,
                            paired: false,
                            state: "idle",
                            deviceType: "device",
                            battery: -1,
                            mac: address
                        })
                    }
                }
                root.syncDevices(parsed)
                infoProc._deviceIndex = 0
                if (parsed.length > 0) {
                    infoProc.command = ["bluetoothctl", "info", parsed[0].address]
                    infoProc.running = true
                }
            }
        }
        stderr: StdioCollector {
            id: devicesStderr
        }
        onExited: (code, status) => {
            if (code !== 0) {
                root.lastError = devicesStderr.text.trim()
            }
            devicesPollTimer.start()
        }
    }

    Process {
        id: infoProc
        property int _deviceIndex: 0
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: infoCollector
            onStreamFinished: {
                var output = infoCollector.text
                if (infoProc._deviceIndex >= devicesModel.count) return
                var d = devicesModel.get(infoProc._deviceIndex)
                var newConnected = output.indexOf("Connected: yes") !== -1
                var newPaired = output.indexOf("Paired: yes") !== -1
                var newDeviceType = root.parseDeviceTypeFromInfo(output)
                var newBattery = root.parseBatteryFromInfo(output)
                var newState = d.state
                if (d.state === "idle") {
                    newState = newConnected ? "connected" : (newPaired ? "paired" : "idle")
                }
                devicesModel.set(infoProc._deviceIndex, {
                    connected: newConnected,
                    paired: newPaired,
                    deviceType: newDeviceType,
                    battery: newBattery,
                    state: newState
                })
            }
        }
        stderr: StdioCollector {
            id: infoStderr
        }
        onExited: (code, status) => {
            if (code !== 0) {
                root.lastError = infoStderr.text.trim()
            }
            infoProc._deviceIndex++
            if (infoProc._deviceIndex < devicesModel.count) {
                infoProc.command = ["bluetoothctl", "info", devicesModel.get(infoProc._deviceIndex).address]
                infoProc.running = true
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
            var cmd = connectProc.command
            var address = cmd.length > 2 ? cmd[2] : ""
            if (code === 0) {
                root.setDeviceState(address, "connected")
                root.deviceConnected(address)
                root.lastError = ""
                root.detectAudioCodec(address)
            } else {
                root.setDeviceState(address, "failed")
                var errText = connectStderr.text.trim()
                if (errText.length === 0) errText = connectStdout.text.trim()
                var errorMsg = ""
                if (errText.indexOf("not available") !== -1) {
                    errorMsg = "Device not found"
                } else if (errText.indexOf("already connected") !== -1) {
                    errorMsg = "Already connected"
                } else if (errText.indexOf("Failed to connect") !== -1) {
                    errorMsg = "Connection failed"
                } else {
                    errorMsg = errText.length > 0 ? errText : "Connection failed"
                }
                root.lastError = errorMsg
                root.operationFailed(address, errorMsg)
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
            var cmd = disconnectProc.command
            var address = cmd.length > 2 ? cmd[2] : ""
            if (code === 0) {
                root.setDeviceState(address, "paired")
                root.deviceDisconnected(address)
                root.lastError = ""
            } else {
                root.setDeviceState(address, "failed")
                var errText = disconnectStderr.text.trim()
                if (errText.length === 0) errText = disconnectStdout.text.trim()
                var errorMsg = ""
                if (errText.indexOf("not connected") !== -1) {
                    errorMsg = "Not connected"
                } else {
                    errorMsg = errText.length > 0 ? errText : "Disconnect failed"
                }
                root.lastError = errorMsg
                root.operationFailed(address, errorMsg)
            }
            refreshTimer.start()
        }
    }

    Process {
        id: pairProc
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: pairStdout
        }
        stderr: StdioCollector {
            id: pairStderr
        }
        onExited: (code, status) => {
            var cmd = pairProc.command
            var address = cmd.length > 2 ? cmd[2] : ""
            if (code === 0) {
                root.setDeviceState(address, "paired")
                root.devicePaired(address)
                root.lastError = ""
            } else {
                root.setDeviceState(address, "failed")
                var errText = pairStderr.text.trim()
                if (errText.length === 0) errText = pairStdout.text.trim()
                var errorMsg = ""
                if (errText.indexOf("already paired") !== -1) {
                    errorMsg = "Already paired"
                } else if (errText.indexOf("Failed to pair") !== -1) {
                    errorMsg = "Pairing failed"
                } else if (errText.indexOf("Authentication") !== -1) {
                    errorMsg = "Authentication failed"
                } else {
                    errorMsg = errText.length > 0 ? errText : "Pairing failed"
                }
                root.lastError = errorMsg
                root.operationFailed(address, errorMsg)
            }
            refreshTimer.start()
        }
    }

    Process {
        id: removeProc
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: removeStdout
        }
        stderr: StdioCollector {
            id: removeStderr
        }
        onExited: (code, status) => {
            var cmd = removeProc.command
            var address = cmd.length > 2 ? cmd[2] : ""
            if (code === 0) {
                var idx = root.findDeviceIndex(address)
                if (idx >= 0) {
                    devicesModel.remove(idx)
                }
                root.deviceRemoved(address)
                root.lastError = ""
            } else {
                var errText = removeStderr.text.trim()
                if (errText.length === 0) errText = removeStdout.text.trim()
                root.lastError = errText.length > 0 ? errText : "Remove failed"
                root.operationFailed(address, root.lastError)
            }
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
                root.powered = !root.powered
                if (root.powered) {
                    root.scan()
                } else {
                    devicesModel.clear()
                    root.discovering = false
                    root.scanning = false
                }
                root.lastError = ""
            } else {
                var errText = toggleStderr.text.trim()
                if (errText.length === 0) errText = toggleStdout.text.trim()
                root.lastError = errText.length > 0 ? errText : "Toggle failed"
            }
            refreshTimer.start()
        }
    }

    Process {
        id: scanProc
        command: ["bluetoothctl", "--timeout", "25", "scan", "on"]
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        onExited: (code, status) => {
            root.scanning = false
            scanPollTimer.stop()
            devicesProc.running = true
        }
    }

    Process {
        id: audioCodecProc
        property string _targetAddress: ""
        command: ["pactl", "list", "sinks"]
        running: false
        environment: ({ LANG: "C", LC_ALL: "C" })
        stdout: StdioCollector {
            id: audioCodecCollector
            onStreamFinished: {
                root.parseAudioCodec(audioCodecCollector.text, audioCodecProc._targetAddress)
            }
        }
        stderr: StdioCollector {
            id: audioCodecStderr
        }
        onExited: (code, status) => {
            if (code !== 0) {
                root.lastError = audioCodecStderr.text.trim()
            }
        }
    }

    Timer {
        id: adapterPollTimer
        interval: 8000
        running: true
        repeat: false
        onTriggered: {
            adapterProc.running = true
            devicesProc.running = true
        }
    }

    Timer {
        id: devicesPollTimer
        interval: 8000
        running: false
        repeat: false
        onTriggered: {
            if (root.powered) {
                devicesProc.running = true
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            adapterProc.running = true
            devicesProc.running = true
        }
    }

    Timer {
        id: scanPollTimer
        interval: 2000
        running: false
        repeat: true
        onTriggered: {
            if (root.scanning) {
                devicesProc.running = true
            } else {
                scanPollTimer.stop()
            }
        }
    }

    Component.onCompleted: {
        adapterProc.running = true
        devicesProc.running = true
    }
}

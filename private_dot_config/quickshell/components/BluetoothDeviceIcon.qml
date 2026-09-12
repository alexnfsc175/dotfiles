import QtQuick
import Quickshell
import "../theme" as Theme
import "../components" as Components

Item {
    id: root

    property string deviceType: "device"
    property real size: 24

    width: size
    height: size

    Text {
        anchors.centerIn: parent
        font.family: Components.Icons.fontFamily
        font.pixelSize: root.size * 0.8
        color: Theme.ThemeManager.text || "#cdd6f4"
        text: {
            switch (root.deviceType) {
                case "headset":
                case "headphone": return Components.Icons.bluetoothHeadphone
                case "mouse": return Components.Icons.bluetoothMouse
                case "keyboard": return Components.Icons.bluetoothKeyboard
                case "gamepad": return Components.Icons.bluetoothGamepad
                case "phone": return Components.Icons.bluetoothPhone
                case "speaker": return Components.Icons.bluetoothSpeaker
                case "computer":
                case "camera":
                case "watch":
                default: return Components.Icons.bluetoothDevice
            }
        }
    }
}

import QtQuick
import Quickshell
import "../theme" as Theme

PopupWindow {
    id: basePopup

    required property var barWindow
    property int popupWidth: 300
    property int popupHeight: 200
    property int anchorX: barWindow.width - implicitWidth - Theme.ThemeManager.popupAnchorMargin
    property int anchorY: barWindow.height + Theme.ThemeManager.popupAnchorY

    implicitWidth: popupWidth
    implicitHeight: popupHeight
    visible: false
    grabFocus: true
    color: Qt.rgba(
        Theme.ThemeManager.crust.r,
        Theme.ThemeManager.crust.g,
        Theme.ThemeManager.crust.b,
        Theme.ThemeManager.popupTransparency
    )

    anchor {
        window: barWindow
        rect.x: basePopup.anchorX
        rect.y: basePopup.anchorY
    }

    Item {
        id: contentArea
        anchors.fill: parent
        anchors.margins: 1

        Keys.onEscapePressed: basePopup.visible = false
        focus: true
    }

    default property alias content: contentArea.data
}

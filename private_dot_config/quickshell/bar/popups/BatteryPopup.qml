import QtQuick
import QtQuick.Layouts
import "../../components" as Components
import "../../theme" as Theme
import "../../services" as Services
import "../../i18n" as I18n

Components.BasePopup {
    id: batteryPopup

    popupWidth: 280
    popupHeight: 200

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.ThemeManager.spacingLg
        spacing: Theme.ThemeManager.spacingMd

        Text {
            text: (Services.BatteryService?.percentage ?? 0) + "%"
            color: {
                var p = Services.BatteryService?.percentage ?? 0
                if (p < 15) return Theme.ThemeManager.error
                if (p < 30) return Theme.ThemeManager.peach
                return Theme.ThemeManager.text
            }
            font.pixelSize: 32
            font.family: Theme.ThemeManager.fontFamily
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: {
                var s = (Services.BatteryService?.status ?? "unknown").toLowerCase()
                if (s === "charging") return I18n.I18n.t("popup.battery.charging")
                if (s === "discharging") return I18n.I18n.t("popup.battery.discharging")
                if (s === "full") return I18n.I18n.t("popup.battery.full")
                if (s === "not charging") return I18n.I18n.t("popup.battery.full")
                return Services.BatteryService?.status ?? "unknown"
            }
            color: Theme.ThemeManager.subtext0
            font.pixelSize: Theme.ThemeManager.fontSizeSm
            font.family: Theme.ThemeManager.fontFamily
            Layout.alignment: Qt.AlignHCenter
        }
    }
}

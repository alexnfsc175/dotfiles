pragma Singleton
import QtQuick

QtObject {
    readonly property int radiusSmall: 4
    readonly property int radiusMedium: 8
    readonly property int radiusLarge: 12
    readonly property int radiusXl: 16
    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 12
    readonly property int spacingLg: 16
    readonly property int spacingXl: 24
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property int fontSizeXs: 10
    readonly property int fontSizeSm: 12
    readonly property int fontSizeMd: 13
    readonly property int fontSizeLg: 14
    readonly property int fontSizeXl: 16
    readonly property real bgTransparency: 0.85
    readonly property real popupTransparency: 0.92
    readonly property bool blurEnabled: true
    readonly property int blurRadius: 40
    readonly property int durationFast: 100
    readonly property int durationNormal: 150
    readonly property int durationSlow: 250
    readonly property int iconSize: 28
    readonly property int widgetHeight: 28
    readonly property int widgetWidth: 28
    readonly property int barHeight: 44
    readonly property int barMarginTop: 4
    readonly property int barMarginLeft: 8
    readonly property int barMarginRight: 8
    readonly property int exclusiveZone: 40
    readonly property int popupAnchorY: 4
    readonly property int popupAnchorMargin: 12
}

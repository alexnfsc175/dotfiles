pragma Singleton
import QtQuick
import Quickshell.Io
import "themes" as Themes
import "."

Item {
    id: themeManager

    property string currentThemeName: "catppuccin-macchiato"
    property string currentThemePersistPath: Qt.resolvedUrl("../config/.theme")

    property var themes: ({
        "catppuccin-macchiato": Themes.CatppuccinMacchiato,
        "catppuccin-mocha": Themes.CatppuccinMocha,
        "gruvbox-dark": Themes.GruvboxDark,
        "tokyo-night": Themes.TokyoNight,
        "nord": Themes.Nord
    })

    property var availableThemes: Object.keys(themes)
    property var currentTheme: themes[currentThemeName] || Themes.CatppuccinMacchiato

    readonly property color base: currentTheme.base
    readonly property color mantle: currentTheme.mantle
    readonly property color crust: currentTheme.crust

    readonly property color surface0: currentTheme.surface0
    readonly property color surface1: currentTheme.surface1
    readonly property color surface2: currentTheme.surface2

    readonly property color overlay0: currentTheme.overlay0
    readonly property color overlay1: currentTheme.overlay1
    readonly property color overlay2: currentTheme.overlay2

    readonly property color text: currentTheme.text
    readonly property color subtext1: currentTheme.subtext1
    readonly property color subtext0: currentTheme.subtext0

    readonly property color accent: currentTheme.accent
    readonly property color accentSecondary: currentTheme.accentSecondary

    readonly property color warning: currentTheme.warning
    readonly property color error: currentTheme.error
    readonly property color success: currentTheme.success
    readonly property color info: currentTheme.info

    readonly property color rosewater: currentTheme.rosewater
    readonly property color flamingo: currentTheme.flamingo
    readonly property color pink: currentTheme.pink
    readonly property color mauve: currentTheme.mauve
    readonly property color red: currentTheme.red
    readonly property color maroon: currentTheme.maroon
    readonly property color peach: currentTheme.peach
    readonly property color yellow: currentTheme.yellow
    readonly property color green: currentTheme.green
    readonly property color teal: currentTheme.teal
    readonly property color sky: currentTheme.sky
    readonly property color sapphire: currentTheme.sapphire
    readonly property color blue: currentTheme.blue
    readonly property color lavender: currentTheme.lavender

    readonly property int radiusSmall: ThemeDefaults.radiusSmall
    readonly property int radiusMedium: ThemeDefaults.radiusMedium
    readonly property int radiusLarge: ThemeDefaults.radiusLarge
    readonly property int radiusXl: ThemeDefaults.radiusXl

    readonly property int spacingXs: ThemeDefaults.spacingXs
    readonly property int spacingSm: ThemeDefaults.spacingSm
    readonly property int spacingMd: ThemeDefaults.spacingMd
    readonly property int spacingLg: ThemeDefaults.spacingLg
    readonly property int spacingXl: ThemeDefaults.spacingXl

    readonly property string fontFamily: ThemeDefaults.fontFamily
    readonly property int fontSizeXs: ThemeDefaults.fontSizeXs
    readonly property int fontSizeSm: ThemeDefaults.fontSizeSm
    readonly property int fontSizeMd: ThemeDefaults.fontSizeMd
    readonly property int fontSizeLg: ThemeDefaults.fontSizeLg
    readonly property int fontSizeXl: ThemeDefaults.fontSizeXl

    readonly property real bgTransparency: ThemeDefaults.bgTransparency
    readonly property real popupTransparency: ThemeDefaults.popupTransparency
    readonly property bool blurEnabled: ThemeDefaults.blurEnabled
    readonly property int blurRadius: ThemeDefaults.blurRadius

    readonly property int durationFast: ThemeDefaults.durationFast
    readonly property int durationNormal: ThemeDefaults.durationNormal
    readonly property int durationSlow: ThemeDefaults.durationSlow

    readonly property int widgetWidth: ThemeDefaults.widgetWidth
    readonly property int widgetHeight: ThemeDefaults.widgetHeight
    readonly property int iconSize: ThemeDefaults.iconSize
    readonly property int barHeight: ThemeDefaults.barHeight
    readonly property int barMarginTop: ThemeDefaults.barMarginTop
    readonly property int barMarginLeft: ThemeDefaults.barMarginLeft
    readonly property int barMarginRight: ThemeDefaults.barMarginRight
    readonly property int exclusiveZone: ThemeDefaults.exclusiveZone
    readonly property int popupAnchorY: ThemeDefaults.popupAnchorY
    readonly property int popupAnchorMargin: ThemeDefaults.popupAnchorMargin

    signal themeChanged()

    FileView {
        id: themePersist
        path: themeManager.currentThemePersistPath
        onLoaded: {
            try {
                var saved = themePersist.text().trim()
                if (saved && themes[saved]) {
                    currentThemeName = saved
                }
            } catch (e) {}
        }
    }

    function setTheme(themeName) {
        if (themes[themeName]) {
            currentThemeName = themeName
            themePersist.write(themeName)
            themeChanged()
        }
    }

    function cycle() {
        var idx = availableThemes.indexOf(currentThemeName)
        var next = availableThemes[(idx + 1) % availableThemes.length]
        setTheme(next)
    }

    function getAvailableThemes() {
        return Object.keys(themes)
    }
}

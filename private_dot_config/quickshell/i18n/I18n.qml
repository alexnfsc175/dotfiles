pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string locale: "en_US"
    property var translations: ({})
    property var fallback: ({})

    function t(key) {
        return translations[key] || fallback[key] || key
    }

    function setLocale(newLocale) {
        locale = newLocale
        localeLoader.path = Qt.resolvedUrl(newLocale + ".json")
    }

    FileView {
        id: fallbackLoader
        path: Qt.resolvedUrl("en_US.json")
        onLoaded: {
            try {
                var content = fallbackLoader.text()
                var raw = content.trim()
                if (raw.length > 0) {
                    root.fallback = JSON.parse(raw)
                    if (root.locale === "en_US") {
                        root.translations = root.fallback
                    }
                }
            } catch (e) {
                console.warn("I18n: failed to parse en_US.json:", e)
            }
        }
    }

    FileView {
        id: localeLoader
        path: Qt.resolvedUrl(root.locale + ".json")
        onLoaded: {
            try {
                var content = localeLoader.text()
                var raw = content.trim()
                if (raw.length > 0) {
                    root.translations = JSON.parse(raw)
                }
            } catch (e) {
                console.warn("I18n: failed to parse " + root.locale + ".json:", e)
                root.translations = root.fallback
            }
        }
    }
}

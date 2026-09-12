pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Services.SystemTray

QtObject {
    id: root

    property var items: SystemTray.items
}

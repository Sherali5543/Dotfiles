pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property color backgroundColor: "#1e1e2e"
  readonly property color borderColor: "#4a4a5c"
  readonly property color hoverColor: "#33ffffff"
  readonly property color accentColor: "#cda715"

  readonly property real transparency: 0.85

  readonly property color textColor: "#efedff"
  readonly property color secondaryTextColor: "#cdd6f4"
  readonly property color mutedColor: "#a6adc8"
  readonly property color imageColor: "#efedff"
}

pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property date time: clock.date

  SystemClock {
    id: clock 
    precision: SystemClock.Seconds
  }
}

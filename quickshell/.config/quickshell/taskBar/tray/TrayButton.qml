import QtQuick
import qs.utils

Rectangle {
  id: button
  width: 32
  height: 32
  color: trayMouseArea.containsMouse ? ColorPalette.hoverColor : "transparent"
  radius: 4

  signal clicked

  Text {
    text: "▼" // Down arrow since the popup drops below
    color: "white"
    anchors.centerIn: parent
  }

  MouseArea {
    id: trayMouseArea
    anchors.fill: parent
    hoverEnabled: true
    onClicked: {
      console.log("CLICKED");
      button.clicked();
    }
  }
}

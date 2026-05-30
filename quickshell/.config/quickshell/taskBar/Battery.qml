import QtQuick
import Quickshell.Services.UPower

Column{
  spacing: 0

  Item{
    id: batteryWidget
    width: 12
    height: 24
    property var battery: UPower.displayDevice
    property int nubWidth: 2

    // fill (dynamic)
    Rectangle {
      anchors {
        left: parent.left
        right: parent.right 
      }
      width: parent.width
      height: batteryWidget.battery 
              ? (parent.height-batteryWidget.nubWidth) * batteryWidget.battery.percentage
              : 0
      y: batteryWidget.battery ? parent.height - height : parent.height

      radius: 2

      // color for charging / normal
      color: batteryWidget.battery
              ? (batteryWidget.battery.state === UPowerDeviceState.Charging ? "#4caf50" : "#000000")
              : "#555555"
      
    }

    Image{
      anchors.fill: parent;
      source: "../assets/battery_outline.svg"
    }
  }

  Text {
    text: batteryWidget.battery
          ? Math.round(batteryWidget.battery.percentage * 100) + "%"
          : "--%"
    horizontalAlignment: Text.AlignHCenter
    width: batteryWidget.width
    font.pointSize: 7.5
  }
}

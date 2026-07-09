import QtQuick
import QtQuick.Controls.impl
import Quickshell.Services.UPower
import qs.utils

Column {
  spacing: 0

  Item {
    id: batteryWidget
    width: 10
    height: 24
    anchors.horizontalCenter: parent.horizontalCenter
    property var battery: UPower.displayDevice
    property int nubWidth: 2
    property bool lowBattery: false
    property bool criticalBattery: false
    property var powerModes: {
      "Battery": PowerProfile.Balanced,
      "AC": PowerProfile.Balanced
    }

    MouseArea {
      anchors.fill: parent
      onClicked: {
        console.log("Rectangle was clicked!");

        NotifyService.sendNotification({
          appName: "test SUPER LONG NAMEEEEEEEEE",
          summary: "We are testing notifs LONG ASS SUMMARRYYYY",
          body: "Here is a sample body it is quite long though STUPID LONG BODYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYy EVEN MOREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE",
          image: "/home/shaheerk/Dotfiles/quickshell/.config/quickshell/assets/volume_up.svg",
          actions: ["powerSaver", "dothis", "action2", "do this2"],
          sound: "dialog-information"
        });
      }
    }

    Rectangle {
      anchors {
        left: parent.left
        right: parent.right
      }
      width: parent.width
      height: batteryWidget.battery ? (parent.height - batteryWidget.nubWidth) * batteryWidget.battery.percentage : 0
      y: batteryWidget.battery ? parent.height - height : parent.height

      radius: 2

      // color for charging / normal
      color: {
        if(!batteryWidget.battery)
          return ColorPalette.imageColor
        
        if(batteryWidget.battery.state === UPowerDeviceState.Charging)
          return "#4caf50"

        if(PowerProfiles.profile === PowerProfile.PowerSaver)
          return "yellow"

        return ColorPalette.imageColor
      }
    }

    IconImage {
      anchors.fill: parent
      source: "../assets/battery_outline.svg"
      color: ColorPalette.imageColor
    }

    Connections {
      target: batteryWidget.battery

      function onStateChanged() {
        batteryWidget.updatePowerMode();
      }

      function onPercentageChanged() {
        batteryWidget.checkBatteryLevel();
      }
    }

    function handleBatteryChange() {
      checkBatteryLevel();
      updatePowerMode();
    }

    function checkBatteryLevel() {
      console.log("-------BATTERY LEVEL: ", batteryWidget.battery.percentage);
      if (batteryWidget.battery.state == UPowerDeviceState.Discharging && batteryWidget.battery.percentage < 0.15 && !lowBattery) {
        lowBattery = true;
        NotifyService.sendNotification({
          appName: "System",
          summary: "Low battery",
          body: "Battery below 15%, plug in a charger",
          urgency: "normal",
          image: "",
          actions: ["powerSaver", "Turn on power savings", "default", "Dismiss"],
          sound: "dialog-warning"
        });
      } else if (batteryWidget.battery.state == UPowerDeviceState.Charging || batteryWidget.battery.percntage >= 0.15) {
        lowBattery = false;
        console.log("BATTERY SET TO FALSE: ", lowBattery);
      }
    }

    function updatePowerMode() {
      console.log("This battery changed: ", lowBattery);
      if (batteryWidget.battery.state == UPowerDeviceState.Discharging) {
        PowerProfiles.profile = batteryWidget.powerModes["Battery"];
        checkBatteryLevel();
      } else {
        PowerProfiles.profile = batteryWidget.powerModes["AC"];
      }
    }
  }

  Text {
    id: text
    text: batteryWidget.battery ? Math.round(batteryWidget.battery.percentage * 100) + "%" : "--%"
    horizontalAlignment: Text.AlignHCenter

    color: ColorPalette.textColor
    font.pointSize: 7.5
  }
}

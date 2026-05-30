// ClockWidget.qml
import QtQuick

Text {
  // we no longer need time as an input
  // Component.onCompleted: console.log("Force instantiating time: ", Time)
  Component.onCompleted: console.log(Time.time)

  // directly access the time property from the Time singleton
  text: Time.time
}

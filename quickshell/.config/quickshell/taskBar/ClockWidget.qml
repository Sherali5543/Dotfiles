import QtQuick
import QtQuick.Layouts
import qs.utils

ColumnLayout {
  spacing: 0
  Text {
    Layout.alignment: Qt.AlignHCenter
    text: Qt.formatTime(Time.time, "hh:mm ap")

    font.pixelSize: 12
    color: ColorPalette.textColor

    width: parent.width
  }

  Text {
    Layout.alignment: Qt.AlignHCenter
    text: Qt.formatDate(Time.time, "dd/MM/yyyy")
    font.pixelSize: 12
    color: ColorPalette.textColor
    width: parent.width
  }
}

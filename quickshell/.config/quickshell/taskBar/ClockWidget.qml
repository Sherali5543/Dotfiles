import QtQuick
import QtQuick.Layouts

ColumnLayout {
  spacing: 0
  Text{
    Layout.alignment: Qt.AlignHCenter
    text: Qt.formatTime(Time.time, "hh:mm ap")
    font.pixelSize: 12
  }

  Text{
    Layout.alignment: Qt.AlignHCenter
    text: Qt.formatDate(Time.time, "dd/MM/yyyy")
    font.pixelSize: 12
  }
}

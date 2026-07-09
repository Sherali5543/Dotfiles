import QtQuick
import qs.utils

Rectangle {
  color: "transparent"

  // anchors.fill: parent
  implicitHeight: 9

  Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter

    height: 1
    color: ColorPalette.borderColor
  }
}

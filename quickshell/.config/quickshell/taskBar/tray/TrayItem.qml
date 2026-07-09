import QtQuick
import QtQuick.Controls.impl
import qs.utils

Rectangle {
  id: item

  radius: 8
  color: mouse.containsMouse ? ColorPalette.hoverColor : "transparent"

  required property var modelData
  required property var itemSize
  required property var root
  width: itemSize
  height: itemSize

  IconImage {
    width: 16
    height: 16
    anchors.centerIn: parent
    source: item.modelData.icon
  }

  MouseArea {
    id: mouse

    hoverEnabled: true
    anchors.fill: parent

    acceptedButtons: Qt.LeftButton | Qt.RightButton

    onClicked: mouseObject => {
      if (item.modelData.hasMenu && mouseObject.button === Qt.RightButton) {
        // console.log("ITEM STUFFF");
        // console.log(item.modelData.id);
        // console.log(item.modelData.title);
        // console.log(item.modelData.tooltipTitle);
        // console.log(item.modelData.category);
        // console.log("END");
        // console.log("ATTEMPTING TO WRITE");

        item.root.menuRequested(item.modelData.id, item);
      } else {
        item.modelData.activate();
        item.root.action();
      }
    }
  }
}

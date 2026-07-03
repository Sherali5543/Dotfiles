pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.utils

Item {
  id: container
  property bool menuOpen: false

  // Maintain size inside the taskbar layout
  implicitWidth: button.width
  implicitHeight: button.height

  Rectangle {
    id: button
    width: 32
    height: 32
    color: trayMouseArea.containsMouse ? ColorPalette.hoverColor : "transparent"
    radius: 4

    Text {
      text: "▼" // Down arrow since the popup drops below
      color: "white"
      anchors.centerIn: parent
    }

    MouseArea {
      id: trayMouseArea
      anchors.fill: parent
      hoverEnabled: true
      onClicked: container.menuOpen = !container.menuOpen
    }
  }

  PopupWindow {
    id: trayPopup
    visible: container.menuOpen

    color: "transparent"

    implicitWidth: popupContainer.width
    implicitHeight: popupContainer.height

    // grabFocus: true
    // onVisibleChanged: {
    //   if (!visible)
    //     container.menuOpen = false;
    // }
    //
    anchor.item: button
    anchor.rect.y: button.height
    anchor.rect.x: (button.width / 2)
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom

    Rectangle {
      id: popupContainer

      width: Math.max(contentLayout.implicitWidth + (contentLayout.anchors.margins * 2), 30)
      height: Math.max(contentLayout.implicitHeight + (contentLayout.anchors.margins * 2), 30)

      color: "#1e1e2e"
      border.color: "#45475a"
      border.width: 1
      radius: 8

      GridLayout {
        id: contentLayout

        columns: Math.min(4, repeater.count)

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 8

        rowSpacing: 4
        columnSpacing: 4

        property real itemSize: 32

        Repeater {
          id: repeater

          model: SystemTray.items
          delegate: Rectangle {
            id: item

            radius: 8
            color: mouse.containsMouse ? "#33ffffff" : "transparent"

            required property var modelData
            width: contentLayout.itemSize
            height: contentLayout.itemSize

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
                  const pos = item.mapToItem(trayPopup.contentItem, 0, height);

                  item.modelData.display(trayPopup, pos.x, pos.y);
                } else {
                  item.modelData.activate();
                  container.menuOpen = false;
                }
              }
            }
          }
        }
      }
    }
  }
}

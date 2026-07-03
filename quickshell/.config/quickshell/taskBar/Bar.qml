import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.utils

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar
      required property var modelData
      screen: modelData
      color: "transparent"

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 48

      RowLayout {
        spacing: 2
        anchors.fill: parent

        // Left
        Item {
          Layout.preferredWidth: 200
          Layout.fillHeight: true
          Layout.alignment: Qt.AlignLeft

          Rectangle {
            anchors.fill: parent

            color: ColorPalette.backgroundColor

            Workspace {
              id: workspace
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              anchors.margins: 10
            }
          }
        }

        // Center
        Item {
          Layout.preferredWidth: 200
          Layout.fillHeight: true
          Layout.alignment: Qt.AlignCenter

          Rectangle {
            anchors.fill: parent
            color: ColorPalette.backgroundColor
          }
        }

        // Right
        Item {
          Layout.preferredWidth: 200
          Layout.fillHeight: true
          Layout.alignment: Qt.AlignRight

          Rectangle {
            anchors.fill: parent
            color: ColorPalette.backgroundColor

            RowLayout {
              // Fill the entire container instead of anchoring to just the right edge
              anchors.fill: parent
              anchors.rightMargin: 10
              anchors.leftMargin: 10
              spacing: 4
              SystemTrayWidget {}
              Brightness {}
              Sound {}
              Battery {}
              ClockWidget {}
            }
          }
        }
      }
    }
  }
}

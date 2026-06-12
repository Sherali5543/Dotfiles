import QtQuick
import QtQuick.Layouts
import Quickshell

Scope {
  Variants {
    model: Quickshell.screens 

    PanelWindow {
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
            color: "#555555"

            Workspace{
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
            color: "#555555"
          }
        }

        // Right 
        Item {
          Layout.preferredWidth: 200
          Layout.fillHeight: true
          Layout.alignment: Qt.AlignRight

          Rectangle {
            anchors.fill: parent
            color: "#555555"

            Brightness{
              id: brightness
              anchors.right: sound.left 
              anchors.verticalCenter: parent.verticalCenter
              // anchors.rightMargin: 10
              // anchors.margins: 5
            }

            Sound{
              id: sound
              anchors.right: battery.left
              anchors.verticalCenter: parent.verticalCenter
              anchors.rightMargin: 10
              anchors.margins: 5
            }

            Battery{
              id: battery
              anchors.right: clock.left
              anchors.verticalCenter: parent.verticalCenter
              anchors.rightMargin: 10
              anchors.margins: 5
            }

            ClockWidget{
              id: clock
              anchors.right: parent.right
              anchors.verticalCenter: parent.verticalCenter
              anchors.margins: 5
            }
          }
        }
      }
    }
  }
}

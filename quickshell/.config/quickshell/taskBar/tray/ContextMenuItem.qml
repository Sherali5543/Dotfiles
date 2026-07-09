import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.utils

Rectangle {
  id: root

  required property var modelData

  signal action
  signal write(body: string)

  implicitWidth: contentRow.implicitWidth + 8
  implicitHeight: contentRow.implicitHeight + 8
  radius: 5

  color: !modelData.enabled ? "transparent" : contextMenuMouse.containsMouse ? ColorPalette.hoverColor : "transparent"

  RowLayout {
    id: contentRow

    anchors.fill: parent
    anchors.leftMargin: 5
    spacing: 10

    Item {
      Layout.preferredWidth: 18
      Layout.alignment: Qt.AlignVCenter

      CheckBox {
        anchors.centerIn: parent

        visible: root.modelData.toggle_type === "checkmark"
        checked: root.modelData.toggle_state

        Component.onCompleted: console.log("VISIBLE CHECKBOX? : ", root.modelData.toggle_type === "checkmark", " STATES: ", root.modelData.toggle_type)
      }
    }

    Text {
      id: text
      Layout.fillWidth: true
      Layout.minimumWidth: 50

      text: root.modelData.label

      color: root.modelData.enabled ? ColorPalette.textColor : ColorPalette.mutedColor
    }
  }

  Text {
    id: arrow
    visible: root.modelData.is_submenu
    text: "▶"
    color: ColorPalette.textColor
  }

  MouseArea {
    id: contextMenuMouse
    anchors.fill: parent
    hoverEnabled: true
    enabled: root.modelData.enabled

    onClicked: {
      if (root.modelData.is_submenu) {
        console.log("submenu");
      } else {
        root.write(JSON.stringify({
          action: "Clicked",
          id: root.modelData.id,
        }) + "\n");

        root.action();
      }
    }
  }
}

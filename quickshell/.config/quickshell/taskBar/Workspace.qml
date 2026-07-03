import QtQuick
import Quickshell.Hyprland
import qs.utils

Item{
// size this Item to its contents
  implicitWidth: label.implicitWidth
  implicitHeight: label.implicitHeight
  Text{
    id: label
    // text: Hyprland.focusedWorkspace.id;
      text: Hyprland.focusedWorkspace
        ? Hyprland.focusedWorkspace.name
        : "(no focused workspace)"
    font.pointSize: 12

    color: ColorPalette.textColor
  }
}
// Item{
// ListView {
//   width: 300; height: 200
//
//   model: Hyprland.workspaces.values
//
//   delegate: Text {
//     // (Qt6/QML best practice: explicitly declare modelData in the delegate)
//     required property var modelData
//     text: `${modelData.id}: ${modelData.name}`
//   }
// }
// }

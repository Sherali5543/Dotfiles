pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.impl
import qs.utils

PopupWindow {
  id: trayPopup

  color: "transparent"

  implicitWidth: popupContainer.width
  implicitHeight: popupContainer.height

  grabFocus: true

  property Item anchorItem

  anchor.item: anchorItem
  anchor.rect.y: anchorItem.height
  anchor.rect.x: (anchorItem.width / 2)
  anchor.edges: Edges.Bottom
  anchor.gravity: Edges.Bottom

  signal menuRequested(appId: string, item: Item)
  signal action

  Rectangle {
    id: popupContainer

    width: Math.max(contentLayout.implicitWidth + (contentLayout.anchors.margins * 2), 30)
    height: Math.max(contentLayout.implicitHeight + (contentLayout.anchors.margins * 2), 30)

    color: ColorPalette.backgroundColor
    border.color: ColorPalette.borderColor
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
        delegate: TrayItem {
          id: item
          root: trayPopup
          itemSize: contentLayout.itemSize
        }
      }
    }
  }
}

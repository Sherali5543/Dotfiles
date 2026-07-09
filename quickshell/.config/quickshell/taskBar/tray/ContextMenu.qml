pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.utils

PopupWindow {
  id: menuWindow

  property var menuData: null
  property var anchorWindow
  property var anchorItem

  signal write(body: string)

  visible: false
  anchor.item: anchorItem ?? null
  // anchor.window: anchorWindow
  // anchor.item: popupContainer
  anchor.edges: Edges.Bottom | Edges.Left
  anchor.rect.y: anchorItem?.height ?? 0

  color: "transparent"

  implicitWidth: container.implicitWidth
  implicitHeight: container.implicitHeight

  grabFocus: true // Ensures hover works but issues with opening context menus

  onVisibleChanged: {
    if (!visible) {
      menuData = null;
    }
  }

  function showMenu(data) {
    // force full unmap
    visible = false;
    menuData = null;

    // force event loop break so the compositor sees it
    Qt.callLater(() => {
      menuData = data;
      visible = true;
    });
  }

  function hideMenu() {
    menuData = null;
    visible = false;
  }

  Rectangle {
    id: container

    color: ColorPalette.backgroundColor
    border.color: ColorPalette.borderColor
    border.width: 1
    radius: 8

    implicitWidth: list.implicitWidth + 8
    implicitHeight: list.implicitHeight + 8
    Component.onCompleted: {
      console.log("WIDTH: ", implicitWidth, " HEIGHT: ", implicitHeight);
      console.log("WIDTH2: ", list.implicitWidth, " HEIGHT2: ", list.implicitHeight);
    }

    Column {
      id: list

      anchors.fill: parent
      anchors.margins: 4
      spacing: 0

      Repeater {
        id: repeater
        property real menuWidth
        property bool prevSeparator

        model: menuWindow.menuData ? menuWindow.menuData.children : []
        onItemAdded: (index, item) => {
          console.log("Added", index);
          menuWidth = Math.max(menuWidth, item.implicitWidth);
        }
        delegate: Item {
          id: item
          required property var modelData
          
          Component.onCompleted: {
            if (item.modelData.is_separator) {
              if (repeater.prevSeparator) {
                this.visible = false;
              } else {
                repeater.prevSeparator = true;
              }
            } else {
              repeater.prevSeparator = false;
            }
            console.log("PREV SEP?: ", repeater.prevSeparator, " CURRENT: ", item.modelData.is_separator, " VISIBLE: ", separator.visible);
            console.log("Delegate:", modelData.label);
          }

          implicitHeight: {
            if(item.modelData.is_separator){
              return separator.implicitHeight
            }else{
              return menuItem.implicitHeight
            }
          }
          implicitWidth: menuItem.implicitWidth

          ContextMenuSeparator {
            id: separator
            visible: item.modelData.is_separator
            width: repeater.menuWidth
          }

          ContextMenuItem {
            id: menuItem
            visible: !item.modelData.is_separator
            modelData: item.modelData

            width: repeater.menuWidth

            onAction: {
              console.log("ACTIONED: ", visible);
              menuWindow.hideMenu();
            }
            onWrite: body => {
              let body_obj = JSON.parse(body)
              body_obj['appId'] = menuWindow.anchorItem.modelData.id
              menuWindow.write(JSON.stringify(body_obj) + "\n");
            }
          }
        }
      }
    }
  }
}

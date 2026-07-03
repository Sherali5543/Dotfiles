import QtQuick
import Quickshell

PanelWindow {
  id: notificationWin
  property var server

  anchors {
    top: true
    right: true
  }

  exclusionMode: ExclusionMode.Ignore

  margins {
    top: 60
    right: 10
  }

  implicitWidth: 370
  implicitHeight: Math.min(notificationList.contentHeight, 600)

  // Window becomes visible when there are cards to show
  visible: server.trackedNotifications.values.length > 0
  color: "transparent"

  ListModel {
    id: notifications
  }
  property var actionStore: ({})
  property int notificationId: 0

  ListView {
    id: notificationList
    anchors.fill: parent
    spacing: 10

    remove: Transition {
      NumberAnimation {
        property: "opacity"
        duration: 300
      }
    }

    removeDisplaced: Transition {
      NumberAnimation {
        properties: "y"
        duration: 300
      }
    }

    add: Transition {
      NumberAnimation {
        properties: "opacity"
        from: 0
        to: 1
        duration: 250
      }
    }

    addDisplaced: Transition {
      NumberAnimation {
        properties: "y"
        duration: 250
      }
    }

    // displaced: Transition {
    //   NumberAnimation {
    //     properties: "y"
    //     duration: 200
    //     easing.type: Easing.OutCubic
    //   }
    // }
    model: notificationWin.server.trackedNotifications
    delegate: NotificationCard {
      id: card
      required property var modelData

      notification: modelData

      ListView.onRemove: removeAnimation.start()
      SequentialAnimation {
        id: removeAnimation
        PropertyAction {
          property: "ListView.delayRemove"
          value: true
        }

        NumberAnimation {
          target: card
          property: "opacity"
          to: 0
          duration: 250
        }

        PropertyAction {
          property: "ListView.delayRemove"
          value: false
        }
      }
    }
  }
}

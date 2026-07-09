import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import qs.utils

ClippingRectangle {
  id: card

  width: 350

  height: content.implicitHeight + progressBackground.implicitHeight + 24
  border.width: 1
  border.color: ColorPalette.borderColor
  color: Qt.alpha(ColorPalette.backgroundColor, ColorPalette.transparency)
  property color accent: ColorPalette.accentColor
  radius: 16
  clip: true
  layer.enabled: true

  onExpandedChanged: {
    console.log("CARD: ", height, ", ", implicitHeight);
    console.log("CONTENT: ", content.height, ", ", content.implicitHeight);
  }

  layer.effect: MultiEffect {
    shadowEnabled: true
    shadowBlur: 0.6
    shadowOpacity: 0.3
  }
  states: [
    State {
      name: "hover"
      when: hover.hovered

      PropertyChanges {
        target: card
        color: ColorPalette.backgroundColor
      }
    }
  ]

  Behavior on color {
    ColorAnimation {
      duration: 100
    }
  }

  property bool expanded: false

  property var notification: ({})

  property int timeout: {
    if (!notification)
      return 5000;

    if (notification.expireTimeout <= 0)
      return 5000;

    return notification.expireTimeout;
  }

  signal dismissed

  TapHandler {
    acceptedButtons: Qt.LeftButton

    onTapped: card.expanded = !card.expanded
  }

  HoverHandler {
    id: hover
    onHoveredChanged: {
      if (hovered) {
        removeTimer.restart();
        progressAnimation.restart();
        progressAnimation.pause();
      } else {
        progressAnimation.resume();
      }
    }
  }

  Timer {
    id: removeTimer
    interval: card.timeout
    running: !hover.hovered
    repeat: false

    onTriggered: card.notification?.dismiss()
  }

  RowLayout {
    id: content
    anchors.fill: parent
    anchors.margins: 12
    spacing: 12

    Rectangle {
      width: 40
      height: 40
      radius: 10

      color: Qt.rgba(1, 1, 1, 0.05)
      visible: card.notification?.image || card.notification?.appIcon || false

      Image {
        id: notifImage
        anchors.centerIn: parent
        width: 24
        height: 24
        source: card.notification?.image || card.notification?.appIcon || ""
      }
    }

    Column {
      spacing: 3
      Layout.alignment: Qt.AlignLeft | Qt.AlignTop
      Layout.fillWidth: true

      Text {
        id: appName
        text: card.notification?.appName || "Unknown App"
        opacity: 0.7
        font.bold: true
        color: ColorPalette.mutedColor
        font.pointSize: 8
        elide: Text.ElideRight
        maximumLineCount: 1
        width: parent.width
      }

      Text {
        id: summary
        text: card.notification?.summary || ""
        color: ColorPalette.textColor
        width: parent.width
        font.pointSize: 12
        font.bold: true
        elide: Text.ElideRight
        maximumLineCount: 1
      }

      Text {
        id: body

        text: card.notification?.body || ""
        color: ColorPalette.secondaryTextColor
        font.pointSize: 10

        width: parent.width
        wrapMode: Text.Wrap
        elide: card.expanded ? false : Text.ElideRight
        maximumLineCount: card.expanded ? 0 : 3
      }

      RowLayout {
        spacing: 6
        Repeater {
          id: buttonRepeater
          model: card.notification?.actions
          delegate: Button {
            implicitHeight: 30

            leftPadding: 14
            rightPadding: 14
            topPadding: 6
            bottomPadding: 6

            // Layout.maximumWidth: buttonRepeater.width/buttonRepeater.count

            required property var modelData
            required property int index

            onClicked: {
              console.log("CLICKED invoking action: ", modelData.text);
              modelData.invoke();
            }

            background: Rectangle {
              radius: height / 2

              color: index === 0 ? card.accent : Qt.rgba(1, 1, 1, 0.06)

              border.color: index === 0 ? Qt.lighter(card.accent, 1.2) : Qt.rgba(1, 1, 1, 0.10)

              Behavior on color {
                ColorAnimation {
                  duration: 120
                }
              }
            }

            contentItem: Text {
              text: modelData.text
              color: index === 0 ? "#11111b" : "#cdd6f4"
              font.pixelSize: 11
              font.weight: Font.Medium

              horizontalAlignment: Text.AlignHCenter
              verticalAlignment: Text.AlignVCenter

              elide: Text.ElideRight
              maximumLineCount: 1
            }

            HoverHandler {
              cursorShape: Qt.PointingHandCursor
            }
          }
        }
      }
    }
  }

  Rectangle {
    id: progressBackground

    anchors.left: parent.left
    anchors.bottom: parent.bottom

    width: parent.width

    height: 3
    opacity: 0.8
    color: card.accent
    z: 10
    layer.enabled: true
    layer.smooth: true

    PropertyAnimation {
      id: progressAnimation

      target: progressBackground
      property: "width"
      from: card.width
      to: 0
      duration: removeTimer.interval
    }

    Component.onCompleted: {
      progressAnimation.start();
    }
  }
}

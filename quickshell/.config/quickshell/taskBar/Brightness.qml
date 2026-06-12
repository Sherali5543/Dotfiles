import QtQuick
import QtQuick.Effects
import Quickshell.Io

Item {
  id: root
  width: 16
  height: 16

  property string backlightDevice
  property int brightness: 0
  property int max_brightness: 1
  readonly property int brightnessPercent: Math.round(brightness / max_brightness * 100)

  Process{
    command: ["sh", "-c", "find /sys/class/backlight -name brightness | head -n 1 | xargs dirname | xargs basename"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        console.log("Detected device: ", this.text.trim()) 
        root.backlightDevice = this.text.trim()
      }
    }
  }

  FileView {
    id: curr_brightness
    path: Qt.resolvedUrl(`/sys/class/backlight/${root.backlightDevice}/brightness`)
    watchChanges: true
    onFileChanged: this.reload()
    onLoaded: root.brightness = parseInt(text.trim())
  }

  FileView {
    id: maximum_brightness
    path: Qt.resolvedUrl(`/sys/class/backlight/${root.backlightDevice}/max_brightness`)
    watchChanges: true
    onFileChanged: this.reload()
    onLoaded: root.max_brightness = parseInt(text.trim())
  }

  Image {
    id: icon
    source: {
      const brightness = root.brightnessPercent;
      console.log(brightness)
      if (!brightness)
        return "../assets/brightness-high.svg";
      if (brightness < 0.6) {
        return "../assets/brightness-low.svg";
      } else {
        return "../assets/brightness-high.svg";
      }
    }
    visible: false
  }

  MultiEffect {
    anchors.fill: icon 
    source: icon 
    colorization: 1.0
    colorizationColor: '#000000'
  }
}

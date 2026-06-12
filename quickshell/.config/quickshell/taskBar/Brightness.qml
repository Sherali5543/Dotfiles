import QtQuick
import QtQuick.Effects
import Quickshell.Io

Item {
  id: root
  width: 24
  height: 24

  property string backlightDevice
  property int brightness: 0
  property int max_brightness: 0
  readonly property int brightnessPercent: max_brightness > 0 ? Math.round((brightness / max_brightness) * 100) : 0

  Process {
    command: ["sh", "-c", "ls /sys/class/backlight"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        console.log("Detected device---------------: ", this.text.trim());
        root.backlightDevice = this.text.trim();
        curr_brightness.path = '/sys/class/backlight/' + this.text.trim() + '/brightness';
        maximum_brightness.path = '/sys/class/backlight/' + this.text.trim() + '/max_brightness';
        console.log("PATHS ARE: ", curr_brightness.path);
        console.log("AND: ", maximum_brightness.path);
      }
    }
  }

  FileView {
    id: curr_brightness
    watchChanges: true
    onFileChanged: this.reload()
    onLoaded: {
      console.log('curr_brightness: ', text())
      console.log('numbered: ', parseInt(text()))
      root.brightness = parseInt(text())}
  }

  FileView {
    id: maximum_brightness
    watchChanges: true
    onFileChanged: this.reload()
    onLoaded: {
      console.log('max_brighteness: ', text())
      console.log('numbered: ', parseInt(text()))
      root.max_brightness = parseInt(text())}
  }

  Image {
    id: icon
    source: {
      console.log("BRIGHTNESS MATH: ")
      console.log("CURR: ", root.brightness, " MAX: ", root.max_brightness)
      console.log("DIV: ", root.brightness/root.max_brightness, "%: ", root.brightness/root.max_brightness*100)
      const brightness = root.brightnessPercent;
      console.log("Brightness is: ", root.brightnessPercent);
      if (!brightness)
        return "../assets/brightness-high.svg";
      if (brightness < 60) {
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

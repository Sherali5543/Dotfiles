import QtQuick
import QtQuick.Effects
import Quickshell.Services.Pipewire

Item{
  id: root
  width: 24
  height: 24

  PwObjectTracker{
    objects: [ Pipewire.defaultAudioSink ]
  }

  property var defaultAudio: Pipewire.defaultAudioSink?.audio

  Image{
    id: icon 
    source: {
      const audio = root.defaultAudio
      if (!audio)
        return "../assets/volume_up.svg"
      if (audio.muted) {
        return "../assets/volume_off.svg"
      }else if (audio.volume > 0.7) {
        return "../assets/volume_up.svg"
      }else if (audio.volume > 0.3) {
        return "../assets/volume_low.svg"
      }else{
        return "../assets/volume_empty.svg"
      }
    }
    visible: false
  }

  
  MultiEffect {
    anchors.fill: icon
    source: icon
    colorization: 1.0
    colorizationColor: "#000000"
  }
}

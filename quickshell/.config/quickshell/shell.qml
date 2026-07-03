//@ pragma UseQApplication
import Quickshell
import QtQml
import "taskBar"
import "notifications"

Scope {
  Component.onCompleted: {
    console.log("SHELL LOADED")
    console.log("Popup =", popup)
  }
  Server{
    id: notifServer
  }
  Popup {
    id: popup
    server: notifServer
  }
  Bar {}
}



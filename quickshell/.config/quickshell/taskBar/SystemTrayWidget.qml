pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import "tray"

Item {
  id: container
  property bool menuOpen: false
  property var activeSocket: null

  // Maintain size inside the taskbar layout
  implicitWidth: button.width
  implicitHeight: button.height

  TrayButton {
    id: button
    onClicked: {
      container.menuOpen = !container.menuOpen;
    }
  }

  TrayPopup {
    id: trayPopup

    anchorItem: button

    visible: container.menuOpen
    onVisibleChanged: {
      if (!visible)
        container.menuOpen = false;
    }

    onAction: {
      container.menuOpen = false;
    }

    onMenuRequested: (appId, item) => {
      contextMenu.anchorItem = item;
      container.getLayout(appId);
    }
  }

  ContextMenu {
    id: contextMenu

    anchorWindow: trayPopup
    onWrite: body => {
      console.log("WE ARE WRITING: ", body);
      container.activeSocket.write(body);
    }
  }

  // {
  //    action: [GetLayout | Clicked | Closed?]
  //    id:
  // }

  function getLayout(appId) {
    const action = "GetLayout";
    const payload = JSON.stringify({
      action,
      appId
    }) + "\n";
    console.log(payload);

    if (!activeSocket.connected) {
      console.log("Daemon unavailable");
      return;
    }
    activeSocket.write(payload);
  }

  function createSocket() {
    if (activeSocket) {
      console.log("Destroying old socket...");
      activeSocket.destroy();
      activeSocket = null;
    }

    console.log("Creating new socket...");

    activeSocket = socketFactory.createObject(container);

    activeSocket.connected = true;
  }

  Component {
    id: socketFactory

    Socket {
      path: "/tmp/quickshell_tray.sock"

      parser: SplitParser {
        onRead: data => {
          console.log("Tray backend: ", data);
          // console.log(Object.keys(json_data));
          // // console.log(json_data.children[0].label);
          // // menuWindow.menuData = json_data;
          // console.log(contextMenu.visible);
          // console.log(contextMenu.menuData);
          const json_data = JSON.parse(data);
          contextMenu.showMenu(json_data);
        }
      }

      onConnectedChanged: {
        console.log("Socket connected:", connected);

        if (connected) {
          reconnectTimer.stop();
        }
      }

      onError: {
        console.log("Socket failed. Retrying...");

        reconnectTimer.start();
      }
    }
  }

  Timer {
    id: reconnectTimer

    interval: 250
    repeat: false

    onTriggered: {
      if (backendDaemon.running)
        createSocket();
    }
  }

  Process {
    id: backendDaemon

    command: ["/home/shaheerk/.global_venv/bin/python3", Quickshell.shellDir + "/backend/system_tray.py"]

    running: true
    stdout: SplitParser {
      // Optional: splitMarker defaults to "\n" if omitted
      splitMarker: "\n"

      // Correct signal and argument name
      onRead: data => {
        if (!data)
          return;
        console.log("Python output line:", data.trim());
      }
    }

    stderr: SplitParser {
      // Optional: splitMarker defaults to "\n" if omitted
      splitMarker: "\n"

      // Correct signal and argument name
      onRead: data => {
        if (!data)
          return;
        console.log("Python output line:", data.trim());
      }
    }
  }

  Component.onCompleted: {
    createSocket();
  }

  Component.onDestruction: {
    console.log("Stopping notification daemon...");
    backendDaemon.terminate();
  }
}

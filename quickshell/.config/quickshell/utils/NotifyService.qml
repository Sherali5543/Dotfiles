// NotificationManager.qml
pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: manager

  property var messageQueue: []
  property var activeSocket: null

  function sendNotification(opts) {
    const appName = opts.appName ?? ""
    const summary = opts.summary ?? ""
    const body = opts.body ?? ""
    const image = opts.image ?? ""
    const actions = opts.actions ?? []
    const sound = opts.sound ?? "dialog-information"

    const payload = JSON.stringify({
      appName,
      summary,
      body,
      image,
      actions,
      sound
    }) + "\n"

    if (activeSocket && activeSocket.connected) {
      console.log("Daemon ready. Sending notification...");
      console.log("Notification: ", payload);
      activeSocket.write(payload);
      activeSocket.flush();
    } else {
      console.log("Daemon unavailable. Queueing notification...");
      messageQueue.push(payload);
      reconnectTimer.start();
    }
  }

  function flushPendingQueue() {
    if (!activeSocket || !activeSocket.connected)
      return;
    if (messageQueue.length === 0)
      return;
    console.log("Flushing", messageQueue.length, "queued messages...");

    while (messageQueue.length > 0) {
      activeSocket.write(messageQueue.shift());
    }

    activeSocket.flush();
  }

  function createSocket() {
    if (activeSocket) {
      console.log("Destroying old socket...");
      activeSocket.destroy();
      activeSocket = null;
    }

    console.log("Creating new socket...");

    activeSocket = socketFactory.createObject(manager);

    activeSocket.connected = true;
  }

  Process {
    id: backendDaemon

    command: ["/home/shaheerk/.global_venv/bin/python3", Quickshell.shellDir + "/backend/notification_client.py"]

    running: true
  }

  Component.onCompleted: {
    createSocket();
  }

  Component.onDestruction: {
    console.log("Stopping notification daemon...");
    backendDaemon.terminate();
  }

  Component {
    id: socketFactory

    Socket {
      path: "/tmp/quickshell_service.sock"

      parser: SplitParser {
        onRead: data => {
          console.log("Notification backend:", data);
        }
      }

      onConnectedChanged: {
        console.log("Socket connected:", connected);

        if (connected) {
          reconnectTimer.stop();
          queueFlushTimer.start();
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

  Timer {
    id: queueFlushTimer

    interval: 50
    repeat: false

    onTriggered: {
      flushPendingQueue();
    }
  }
}

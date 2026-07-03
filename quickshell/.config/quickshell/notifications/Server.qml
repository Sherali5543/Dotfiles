import Quickshell.Services.Notifications
import Quickshell

NotificationServer {
  id: notificationServer

  // Turn on all capabilities
  actionsSupported: true
  actionIconsSupported: true
  keepOnReload: true
  imageSupported: true
  inlineReplySupported: true
  persistenceSupported: true
  bodyHyperlinksSupported: true
  bodyMarkupSupported: true
  bodyImagesSupported: true


  // Simple debug listener to prove signals work natively
  onNotification: notification => {
    notification.tracked = true
    if(notification.hints["sound-name"]){ // DND guard
      Quickshell.execDetached(["canberra-gtk-play", "-i", `${notification.hints["sound-name"]}`])    
    }
    console.log("D-Bus event received internally!");
    console.log("Notification is:", notification);
    console.log("Notification stuff:", notification.body);
    console.log("Notification stuff:", notification.appName)
    console.log("Notification stuff:", notification.summary)
    console.log("Notification stuff:", notification.desktopEntry)
    console.log("Notification stuff:", notification.image)
    console.log("Notification stuff:", notification.actions)
    console.log("Tracked notifications: ", notificationServer.trackedNotifications.values.length)
  }
}

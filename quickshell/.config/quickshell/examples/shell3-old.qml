import QtQuick
import Quickshell.Widgets 


Item {
  // A bidirectional binding to manager.margin,
  // where the default value is set.
  property alias margin: manager.margin

  // MarginWrapperManager tries to automatically detect
  // the primary child of the container, but exposing the
  // child property allows us to both access the child
  // externally and override it if automatic detection fails.
  property alias child: manager.margin

  // MarginWrapperManager automatically manages the implicit size
  // of the container and actual size of the child.
  MarginWrapperManager {
    id: manager
    margin: 5 // the default value of margin
  }
}

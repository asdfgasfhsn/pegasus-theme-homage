import QtQuick 2.8

// A carousel is a PathView that goes horizontally and keeps its
// current item in the center.
PathView {
    id: root

    property int itemWidth // set this on the calling site
    readonly property int pathWidth: pathItemCount * itemWidth

    signal itemSelected

    // Handle keys
    Keys.onLeftPressed: decrementCurrentIndex()
    Keys.onRightPressed: incrementCurrentIndex()
    Keys.onPressed: {
        if (api.keys.isAccept(event)) {
            event.accepted = true;
            itemSelected();
        }
    }

    // Center the current item
    snapMode: PathView.SnapOneItem
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5

    // Create and position the path
    pathItemCount: Math.ceil(width / itemWidth) + 2
    path: Path {
        startX: (root.width - root.pathWidth) / 2
        startY: root.height / 2
        PathLine {
            x: root.path.startX + root.pathWidth
            y: root.path.startY
        }
    }
}

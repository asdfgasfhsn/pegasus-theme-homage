import QtQuick 2.8
import QtGraphicalEffects 1.12
import "utils.js" as Utils
// The collection logo on the collection carousel. Just an image that gets scaled
// and more visible when selected. Also has a fallback text if there's no image.
Item {
    property string longName: "" // set on the PathView side
    property string shortName: "" // set on the PathView side
    readonly property bool selected: PathView.isCurrentItem


    width: root.width
    height: parent.width
    visible: PathView.onPath // optimization: do not draw if not visible
    opacity: 1.0

    Image {
        id: controllerImage
        width: vpx(320)
        height: vpx(320)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: shortName ? "assets/controllers/%1.png".arg(shortName) : ""
        asynchronous: true
        scale: selected ? 1.0 : 0.555
        Behavior on scale { NumberAnimation { duration: 333 } }
    }
}

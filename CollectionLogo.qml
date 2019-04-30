import QtQuick 2.8
import QtGraphicalEffects 1.12

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
        width: vpx(364)
        height: vpx(364)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: shortName ? "assets/controllers/%1.png".arg(shortName) : ""
        asynchronous: true
        scale: selected ? 1.0 : 0.555
        Behavior on scale { NumberAnimation { duration: 333 } }
    }
    layer.enabled: selected ? true : false
    layer.effect: DropShadow {
      fast: true
      horizontalOffset: 0
      verticalOffset: 0
      spread: 0.333
      radius: vpx(40)
      samples: 20
      color: "#909932CC"
      transparentBorder: true
      SequentialAnimation on color {
            loops: Animation.Infinite
            ColorAnimation { from: "#909932CC"; to: "#900000FF"; duration: 10000 }
            ColorAnimation { from: "#900000FF"; to: "#909932CC"; duration: 10000 }
        }
    }



}

import QtQuick 2.15
import QtGraphicalEffects 1.12
import "utils.js" as Utils
// The collection logo on the collection carousel. Just an image that gets scaled
// and more visible when selected. Also has a fallback text if there's no image.
Item {
    id: logoRoot
    property string longName: "" // set on the PathView side
    property string shortName: "" // set on the PathView side
    readonly property bool selected: PathView.isCurrentItem

    signal clicked()

    width: root.width
    height: parent.width
    visible: PathView.onPath // optimization: do not draw if not visible
    opacity: 1.0

    Image {
        id: controllerImage
        width: vpx(480)
        height: vpx(480)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: shortName ? "assets/controllers_svg/%1.svg".arg(shortName) : ""
        asynchronous: true
        scale: selected ? 1.0 : 0.555
        opacity: selected ? 1 : 0.5
        Behavior on scale { NumberAnimation { duration: 333 } }
        Behavior on opacity { NumberAnimation { duration: 333 } }
        layer.enabled: selected ? true : false
        layer.effect: DropShadow {
         //fast: true
         horizontalOffset: 0
         verticalOffset: 0
         spread: 0.444
         radius: vpx(20)
         samples: 40
         color: Utils.systemColor(shortName)
         transparentBorder: true
         // SequentialAnimation on color {
         //       loops: Animation.Infinite
         //       ColorAnimation { from: "#909932CC"; to: "#900000FF"; duration: 10000 }
         //       ColorAnimation { from: "#900000FF"; to: "#909932CC"; duration: 10000 }
         //   }
        }
    }

    // Hit region matches the visible image, not the delegate's full-screen-width
    // slot. The PathView gives every delegate `width: root.width`, so anchoring
    // to parent would make adjacent delegates' hit regions overlap heavily; the
    // PathView's z-order then routes centre-of-screen clicks to a neighbour
    // instead of the centred logo.
    MouseArea {
        anchors.fill: controllerImage
        onClicked: logoRoot.clicked()
    }
}

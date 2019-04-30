import QtQuick 2.8
import QtGraphicalEffects 1.12

Item {
  id: root
  property var gameData//: currentCollection.games.get(gameList.currentIndex)
  property var collectionView
  property var detailView

  property real dimopacity: 0.666

  property string bgSource: gameData ? gameData.assets.background || gameData.assets.screenshots[0] : 'assets/backgrounds/blank.png'
  property string bgImage1
  property string bgImage2
  property bool firstBG: true

  onBgSourceChanged: {
    if ( detailView ) {
      swapImage(bgSource);
    }
  }

  onCollectionViewChanged: {
    if ( collectionView ) {
      bgImage1: 'assets/backgrounds/blank.png'
      bgImage2: 'assets/backgrounds/blank.png'
    } else {
      swapImage(bgSource);
    }
  }

  Item {
    id: bg

    anchors.fill: parent

    states: [
        State { // this will fade in rect2 and fade out rect
            name: "fadeInRect2"
            PropertyChanges { target: rect; opacity: 0}
            PropertyChanges { target: rect2; opacity: 1}
        },
        State   { // this will fade in rect and fade out rect2
            name:"fadeOutRect2"
            PropertyChanges { target: rect;opacity:1}
            PropertyChanges { target: rect2;opacity:0}
        }
    ]

    transitions: [
        Transition {
            NumberAnimation { property: "opacity"; easing.type: Easing.InOutQuad; duration: 1000 }
        }
    ]

    Image {
        id: rect2Img
        anchors.fill: parent
        visible: false //gameData
        asynchronous: true
        source: bgImage1
        sourceSize { width: 1920; height: 1080 }
        fillMode: Image.PreserveAspectCrop
        smooth: false
    }

    Image {
        id: rectImg
        anchors.fill: parent
        visible: false //gameData
        asynchronous: true
        source: bgImage2
        sourceSize { width: 1920; height: 1080 }
        fillMode: Image.PreserveAspectCrop
        smooth: false
    }

    FastBlur {
        id: rect
        anchors.fill: rectImg
        source: rectImg
        radius: vpx(20)
    }
    FastBlur {
        id: rect2
        anchors.fill: rect2Img
        source: rect2Img
        radius: vpx(20)
    }

    state: "fadeInRect2"

  }

  function swapImage(newSource) {
    if (firstBG) {
      // Go to second image
      if (newSource)
        bgImage2 = newSource

      firstBG = false
    } else {
      // Go to first image
      if (newSource)
        bgImage1 = newSource

      firstBG = true
    }
    bg.state = bg.state == "fadeInRect2" ? "fadeOutRect2" : "fadeInRect2"
  }

  LinearGradient {
    z: parent.z + 1
    width: parent.width
    height: parent.height
    anchors {
      top: parent.top; topMargin: vpx(200)
      right: parent.right
      bottom: parent.bottom
    }
    start: Qt.point(0, 0)
    end: Qt.point(0, height)
    gradient: Gradient {
      GradientStop { position: 0.1; color: "#00000000" }
      GradientStop { position: 0.7; color: "#ff000000" }
    }
  }

  Rectangle {
    id: backgrounddim
    anchors.fill: parent
    color: "#15181e"
    opacity: dimopacity
    Behavior on opacity { NumberAnimation { duration: 2000 } }
  }
}

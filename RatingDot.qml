import QtQuick 2.8

Item {
  property var game

  Rectangle {
      id: ratingCircle
      width: vpx(80)
      height: width
      radius: width / 2
      color: "#f6f6f6"
    }
    Text {
      text: 'RATING'
      font.family: globalFonts.condensed
      font.pixelSize: vpx(10)
      font.weight: Font.Bold
      anchors {
        top: ratingCircle.top; topMargin: vpx(15)
        horizontalCenter: ratingCircle.horizontalCenter
      }
    }
    Text {
      id: ratingValue
      text: (game.rating == "") ? "N/A" : Math.round(game.rating * 100) + '%'
      font.family: globalFonts.condensed
      fontSizeMode: Text.Fit; minimumPixelSize: vpx(30); font.pixelSize: vpx(36)
      anchors {
        verticalCenter: ratingCircle.verticalCenter
        horizontalCenter: ratingCircle.horizontalCenter
    }
    Behavior on text {
      FadeAnimation {
          target: ratingValue
        }
      }
  }
}

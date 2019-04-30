import QtQuick 2.8
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.12
import "utils.js" as Utils // some helper functions

Rectangle {
  id: root
  property var game
  // border.color: 'red'
  // border.width: vpx(5)
   Item {
     id: gameDescriptionRect
     height: vpx(100)
     width: parent.width
     anchors {
         horizontalCenter: parent.horizontalCenter
     }

     GameInfoText {
         id: gameDescription
         anchors {
           fill: parent
         }
         text: game.description
         wrapMode: Text.WordWrap
         elide: Text.ElideRight
         color: "#f3f3f3"
         verticalAlignment: Text.AlignBottom // Text.AlignVCenter
         horizontalAlignment: Text.AlignJustify
     }
  }
}

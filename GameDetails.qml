import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "utils.js" as Utils // some helper functions

Rectangle {
  id: root
  property var game
   Item {
     id: gameDescriptionRect
     anchors {
         fill: parent
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

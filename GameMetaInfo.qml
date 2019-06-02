import QtQuick 2.8
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.12
import "utils.js" as Utils // some helper functions

Rectangle {
  id: root
  property var game
  // border.color: 'red'
  // border.width: vpx(5)

    Rectangle {
      id: metadataRect1
      anchors {
        top: parent.top
        left: parent.left
        horizontalCenter: parent.horizontalCenter
      }
      width: parent.width
      height: parent.height
      color: "transparent"
      RowLayout {
        id: metadataRow1
        anchors{
          left: parent.left
        }
        spacing: vpx(10)
        MetaBox { metaTitle: 'PLAYERS'; metaContent: game.players }
        MetaBox { metaTitle: 'RATING'; metaContent: (game.rating == "") ? "N/A" : Math.round(game.rating * 100) + '%'}
        MetaBox { metaTitle: 'RELEASED'; metaContent: ( Utils.formatDate(game.release) || "N/A" ) }
        MetaBox { metaTitle: 'GENRE'; metaContent: ( game.genre || "N/A" ) }
        MetaBox { metaTitle: 'DEVELOPER'; metaContent: ( game.developer || "N/A" ) }
        MetaBox { metaTitle: 'PUBLISHER'; metaContent: ( game.publisher || "N/A" ) }
        MetaBox { metaTitle: 'LAST PLAYED'; metaContent: Utils.formatLastPlayed(game.lastPlayed) }
        MetaBox { metaTitle: 'TIME PLAYED'; metaContent: Utils.formatPlayTime(game.playTime) }
      }
    }
  }

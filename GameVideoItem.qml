// Pegasus Frontend
// Copyright (C) 2017-2018  Mátyás Mustoha
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.


import QtQuick 2.8
import QtMultimedia 5.9
import QtGraphicalEffects 1.12

Item {
    property var game
    property var collectionView
    property var detailView

    onGameChanged: {
      if ( detailView ) {
        videoPreview.stop();
        videoPreview.playlist.clear();
        videoDelay.restart();
      } else {
        videoPreview.stop();
        videoPreview.playlist.clear();
        }
      }

    onCollectionViewChanged: {
      if ( collectionView ) {
      videoPreview.stop();
      videoPreview.playlist.clear();
      videoDelay.stop();
    } else {
      videoPreview.playlist.clear();
      videoDelay.restart();
      }
    }

    // a small delay to avoid loading videos during scrolling
    Timer {
        id: videoDelay
        interval: 666
        onTriggered: {
            if (game && game.assets.videos.length > 0) {
                for (var i = 0; i < game.assets.videos.length; i++)
                    videoPreview.playlist.addItem(game.assets.videos[i]);
                videoPreview.play();
            }
        }
    }

    Item {
      id: gameDebug
      function gameDebug(game) {
        console.warn("video count: ", game.assets.videos.length);
        }
    }

    Rectangle {
        id: videoBox
        color: "transparent"
        anchors.fill: parent
        // border.color: "red"
        // border.width: vpx(5)
        width: videoPreviewImage.width
        height: videoPreviewImage.height

        clip: true
        visible: (game && (game.assets.videos.length || game.assets.screenshots.length)) || false

        Video {
            id: videoPreview
            visible: playlist.itemCount > 0

            muted: true

            width: metaData.resolution ? metaData.resolution.width : 0
            height: metaData.resolution ? metaData.resolution.height : 0

            anchors { fill: parent; }//margins: 1 }
            fillMode: VideoOutput.PreserveAspectFit

            playlist: Playlist {
                playbackMode: Playlist.Loop
            }
        }

        Image {
            id: videoPreviewImage
            visible: false // !videoPreview.visible
            width: Image.width
            height: Image.height
            //anchors { fill: parent; margins: 0 }
            fillMode: Image.PreserveAspectFit

            source: (game && game.assets.screenshots.length && game.assets.screenshots[0]) || ""
            sourceSize { width: vpx(256); height: vpx(256) }
            asynchronous: true
        }

        OpacityMask {
            anchors { fill: videoBox; margins: 0 }
            source: videoPreviewImage
            maskSource: Rectangle {
                width: videoPreviewImage.width
                height: videoPreviewImage.height
                radius: vpx(8)
                visible: false // this also needs to be invisible or it will cover up the image
            }
        }
    }
}

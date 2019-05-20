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
    property var collectionShortName
    property bool steam: false

    onGameChanged: {
      if ( detailView ) {
        videoPreviewLoader.sourceComponent = undefined;
        unfadescreenshot.restart();
        videoDelay.restart();
      } else {
        videoPreviewLoader.sourceComponent = undefined;
        }
      }

    onCollectionViewChanged: {
      if ( collectionView ) {
      videoPreviewLoader.sourceComponent = undefined;
      unfadescreenshot.restart();
      videoDelay.stop();
    } else {
      videoPreviewLoader.sourceComponent = undefined;
      videoDelay.restart();
      }
      if (collectionShortName == "steam") {
        steam = true
      } else {
        steam = false
      }
    }

    // a small delay to avoid loading videos during scrolling
    Timer {
      id: videoDelay
      interval: 666
      onTriggered: {
        if (game.assets.videos.length) {
          videoPreviewLoader.sourceComponent = videoPreviewWrapper;
          fadescreenshot.restart();
        }
      }
    }

    Timer {
      id: fadescreenshot
      interval: 1000
      onTriggered: {
        screenshot.opacity = 0;
      }
    }
    Timer {
      id: unfadescreenshot
      interval: 10
      onTriggered: {
        screenshot.opacity = 100;
      }
    }

    // Actual art
    Image {
      id: screenshot

      width: root.Width
      height: root.Height
      z: 3
      anchors {
        fill: parent
        margins: vpx(4)
      }

      asynchronous: true
      visible: game.assets.screenshots[0] || game.assets.boxFront || false

      smooth: true

      source: (steam) ? game.assets.logo : game.assets.screenshots[0] || ""
      sourceSize { width: 256; height: 256 }
      fillMode: Image.PreserveAspectCrop

      property bool rounded: true
      property bool adapt: true

      Behavior on opacity { PropertyAnimation { duration: 1000; easing.type: Easing.OutQuart; easing.amplitude: 2.0; } }

      layer.enabled: rounded
      layer.effect: OpacityMask {
          maskSource: Item {
              width: screenshot.width
              height: screenshot.height
              Rectangle {
                  anchors.centerIn: parent
                  width: screenshot.width
                  height: screenshot.height
                  radius: vpx(10)
              }
          }
       }
    }

    // Video preview
    Component {
      id: videoPreviewWrapper
      Video {
        source: game.assets.videos.length ? game.assets.videos[0] : ""
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
        //muted: true
        volume: 0.3
        loops: MediaPlayer.Infinite
        autoPlay: true
      }

    }

    Loader {
      id: videoPreviewLoader
      asynchronous: true
      anchors {
        fill: parent
        margins: vpx(4)
      }
      layer.enabled: true
      layer.effect: OpacityMask {
          maskSource: Item {
              width: videoPreviewLoader.width
              height: videoPreviewLoader.height
              Rectangle {
                  anchors.centerIn: parent
                  width: videoPreviewLoader.width
                  height: videoPreviewLoader.height
                  radius:  vpx(10)
              }
          }
      }
    }
}

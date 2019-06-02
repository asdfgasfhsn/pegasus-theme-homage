import QtQuick 2.8 // note the version: Text padding is used below and that was added in 2.7 as per docs
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.12
import "utils.js" as Utils // some helper functions

// The details "view". Consists of some images, a bunch of textual info and a game list.
FocusScope {
    id: root

    property var currentCollection
    property alias currentGameIndex: grid.currentIndex
    readonly property var currentGame: currentCollection.games.get(currentGameIndex)

    width: parent.width
    height: parent.height
    enabled: focus
    visible: y + height >= 0

    signal cancel
    signal nextCollection
    signal prevCollection
    signal launchGame

    // Key handling. In addition, pressing left/right also moves to the prev/next collection.
    // Keys.onLeftPressed: prevCollection()
    // Keys.onRightPressed: nextCollection()
    Keys.onPressed: {
        if (event.isAutoRepeat)
            return;

        if (api.keys.isAccept(event)) {
            event.accepted = true;
            launchGame();
            return;
        }
        if (api.keys.isCancel(event)) {
            event.accepted = true;
            cancel();
            return;
        }
        if (api.keys.isNextPage(event)) {
            event.accepted = true;
            nextCollection();
            return;
        }
        if (api.keys.isPrevPage(event)) {
            event.accepted = true;
            prevCollection();
            return;
        }
    }

  BackgroundImage {
    id: backgroundimage
    gameData: currentGame
    collectionView: collectionsView.focus
    detailView: detailsView.focus
    anchors {
      left: parent.left; right: parent.right
      top: parent.top; bottom: parent.bottom
    }
    opacity: 0.555
  }

// GridView start!
  Rectangle {
      id: content
      anchors {
        top: parent.top
        left: screenshotBox.right
        right: parent.right
        bottom: parent.bottom
      }

// TODO: use loader to make loading grid/list views based on system type.
// https://doc.qt.io/qt-5/qml-qtquick-loader.html
// https://stackoverflow.com/questions/27695717/conditionally-include-component-based-on-property-value
// NOTE: may require considerable re-work
      color: "transparent"
      clip: true

      GridView {
          id: grid
          width:  root.width / 2.22
          height: parent.height

          preferredHighlightBegin: vpx(120)
          preferredHighlightEnd: root.height - vpx(220)

          anchors {
            rightMargin: vpx(48)
            top: parent.top;
            right: parent.right;
          }

          property bool firstImageLoaded: false
          property real cellHeightRatio: 0.5

          function cells_need_recalc() {
              firstImageLoaded = false;
              cellHeightRatio = 0.5;
          }

          focus: true
          snapMode: GridView.SnapToRow
          highlightFollowsCurrentItem: true
          highlightRangeMode: GridView.StrictlyEnforceRange

          model: currentCollection.games
          onModelChanged: cells_need_recalc()
          onCountChanged: cells_need_recalc()

          property real columnCount: {
              if (cellHeightRatio > 1.2) return 5;
              if (cellHeightRatio > 0.6) return 4;
              return 3;
          }

          function calcHeightRatio(imageW, imageH) {
              cellHeightRatio = 0.5;

              if (imageW > 0 && imageH > 0)
                  cellHeightRatio = imageH / imageW;
          }

          cellWidth: width / columnCount
          cellHeight: cellWidth * cellHeightRatio;

          displayMarginBeginning: anchors.topMargin

          transform: Rotation { origin.x: grid.height/2; origin.y: grid.width/2; axis { x: 0; y: 1; z: 0 } angle: -8 }

          delegate: GameGridItem {
              width: GridView.view.cellWidth
              height: GridView.view.cellHeight
              selected: GridView.isCurrentItem
              systemColor: Utils.systemColor(currentCollection.shortName)

              game: modelData

              imageHeightRatio: {
                  if (grid.firstImageLoaded) return grid.cellHeightRatio;
                  return 0.5;
              }
              onImageLoaded: {
                  // NOTE: because images are loaded asynchronously,
                  // firstImageLoaded may appear false multiple times!
                  if (!grid.firstImageLoaded) {
                      grid.firstImageLoaded = true;
                      grid.calcHeightRatio(imageWidth, imageHeight);
                    }
              }
          }
      }
}

// Subtle gradient over the bottom of the grid.
LinearGradient {
  width: parent.width
  height: parent.height
  anchors {
    top: parent.top
    right: parent.right
    bottom: parent.bottom
  }
  start: Qt.point(0, 0)
  end: Qt.point(0, height)
  gradient: Gradient {
    GradientStop { position: 0.0; color: "#00000000" }
    GradientStop { position: 0.7; color: "#00000000" }
    GradientStop { position: 0.999; color: "#000000" }
  }
}

// Header/Meta Start
  Rectangle {
    id: headerGameTitle
    readonly property int paddingH: vpx(20)
    readonly property int paddingV: vpx(20)
    width: vpx(1260)
    height: vpx(64)
    color: "transparent"

    anchors {
      bottom: root.bottom; bottomMargin: paddingH
      left: root.left; leftMargin: paddingV
      rightMargin: paddingV

    }

    HeaderText {
      titletext: currentGame.title;
      game: currentGame
      anchors {
      }
    }
  }

  Item {
    id: metaBar
    width: parent.width
    height: vpx(106)
    anchors {
      bottom: headerGameTitle.top
      left: headerGameTitle.left
      right: parent.right
    }

    Rectangle {
      id: metaBarBg
      width:  vpx(620)
      height: parent.height
      color: "#00f3f3f3"
      visible: true
    }

    Text {
        id: collectionName
        anchors {
          left: parent.left
          top: metaBarBg.top
          topMargin: vpx(4)
          }
        text: "≡ %1".arg(currentCollection.name) || "Not Found"
        color: "#f3f3f3"
        font.pixelSize: vpx(18)
        font.family: subheaderFont.name
        font.capitalization: Font.AllUppercase
        Behavior on text {
          FadeAnimation {
              target: collectionName
            }
          }
      }

      GameMetaInfo {
        id: gameDetails1
        game: currentGame
        color: "transparent"
        width: parent.width / 2.06
        anchors {
          top: collectionName.bottom; topMargin: vpx(4)
          left: parent.left;
          bottomMargin: vpx(4)
        }
     }
  }

  GameDetails {
    id: gameDetails
    game: currentGame
    color: "#00f3f3f3"
    height: vpx(80)
    width: parent.width / 2.06
    anchors {
      top: screenshotBox.bottom
      bottom: metaBar.top
      left: headerGameTitle.left
    }
  }

  Rectangle {
    id: screenshotBox
    height: vpx(400)
    width: parent.width / 2.06
    color: "transparent"
    clip: false
    anchors {
      top: root.top; topMargin: vpx(40)
      left: parent.left; leftMargin: vpx(20)
    }

  Rectangle {
    // TODO: make width/height adhere to platform specific ratios so screenshots
    // and videos "fit nicely". Currently forced to 4/3.
    // 16:9 :: 608 x 342 (PSVita)
    // 3:2 :: 612:408 (GBA/GB)
    // 8:7 :: 608:532 (NES)
      id: screenshot
      width: vpx(504)
      height: vpx(378)
      color: "#00f3f3f3"

      transform: Rotation { origin.x: screenshotBox.height/2; origin.y: screenshotBox.width/2; axis { x: 0; y: 1; z: 0 } angle: 8 }

      anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
      }

      GameVideoItem {
          id: screenshotImage
          anchors { fill: parent }

          game: currentGame
            collectionView: collectionsView.focus
            detailView: detailsView.focus
            collectionShortName: currentCollection.shortName
       }
    }
  }
}

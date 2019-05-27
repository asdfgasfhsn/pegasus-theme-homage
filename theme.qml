import QtQuick 2.8
import QtGraphicalEffects 1.12

FocusScope {
    Component.onCompleted: {
        collectionsView.currentCollectionIndex = api.memory.get('collectionIndex') || 0;
    }

    FontLoader {id: generalFont; source: "fonts/Rubik-Regular.ttf" }
    FontLoader {id: headerFont; source: "fonts/FredokaOne-Regular.ttf" }
    FontLoader {id: subheaderFont; source: "fonts/FredokaOne-Regular.ttf" }


    // Generate the tiled background using gridview/rect delegates...
    // TODO: figure out if this is a performance issue for RPi
    // GridView {
    //   id: bgRect
    //   width: parent.width
    //   height: parent.height
    //
    //   anchors {
    //     top: parent.top
    //     left: parent.left
    //     right: parent.right
    //     //fill: parent
    //   }
    //   model: 2600
    //
    //   cellWidth: vpx(20)
    //   cellHeight: vpx(20)
    //
    //   delegate: Rectangle {
    //     width: vpx(20)
    //     height: vpx(20)
    //     color: "black"
    //     border.color: Qt.rgba(0.5, 0.5, 0.5, 0.1)
    //     border.width: 1
    //     radius: 0
    //     }
    //   }

      // Timer {
      //     id: timer
      //     repeat: true
      //     interval: 1000 / fps
      //     onTriggered: { frame += 1 }
      //     running: parent.running
      // }

      StarField {
          anchors {
            left: parent.left
          }
      }

    // TODO: Possibly use this method for performance reasons...
    // Image {
    //   source: 'assets/backgrounds/grid.png'
    //   id: bgTile
    //   width: parent.width
    //   height: parent.height
    //
    //   anchors {
    //     top: parent.top
    //     left: parent.left
    //     right: parent.right
    //   }
    //   opacity: 0.3
    //   fillMode: Image.Tile
    // }

    CollectionsView {
        id: collectionsView
        anchors.bottom: parent.bottom

        focus: true
        onCollectionSelected: {
          detailsView.currentGameIndex = api.memory.get(currentCollection.shortName + 'GameIndex') || 0;
          detailsView.focus = true
        }
    }
    DetailsView {
        id: detailsView
        anchors.top: collectionsView.bottom

        currentCollection: collectionsView.currentCollection

        onCancel: {
          api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
          api.memory.set(currentCollection.shortName + 'GameIndex', currentGameIndex);
          collectionsView.focus = true
        }
        onNextCollection: {
          api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
          api.memory.set(currentCollection.shortName + 'GameIndex', currentGameIndex);
          collectionsView.selectNext()
          detailsView.currentGameIndex = api.memory.get(currentCollection.shortName + 'GameIndex') || 0;
        }
        onPrevCollection: {
          api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
          api.memory.set(currentCollection.shortName + 'GameIndex', currentGameIndex);
          collectionsView.selectPrev()
          detailsView.currentGameIndex = api.memory.get(currentCollection.shortName + 'GameIndex') || 0;
        }
        onLaunchGame: {
            api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
            api.memory.set(currentCollection.shortName + 'GameIndex', currentGameIndex);
            currentGame.launch();
        }
    }

    states: [
        State {
            when: detailsView.focus
            AnchorChanges {
                target: collectionsView;
                anchors.bottom: parent.top
            }
        }
    ]

    transitions: Transition {
        AnchorAnimation {
            duration: 666
            easing.type: Easing.OutExpo
        }
    }
}

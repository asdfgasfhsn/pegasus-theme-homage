import QtQuick 2.8
import QtGraphicalEffects 1.12
// The collections view consists of two carousels, one for the collection logo bar
// and one for the background images. They should have the same number of elements
// to be kept in sync.
FocusScope {
    id: root

    // This element has the same size as the whole screen (ie. its parent).
    // Because this screen itself will be moved around when a collection is
    // selected, I've used width/height instead of anchors.
    width: parent.width
    height: parent.height
    enabled: focus // do not receive key/mouse events when unfocused
    visible: y + height >= 0 // optimization: do not render the item when it's not on screen

    signal collectionSelected

    // Shortcut for the currently selected collection. They will be used
    // by the Details view too, for example to show the collection's logo.
    property alias currentCollectionIndex: logoAxis.currentIndex
    readonly property var currentCollection: logoAxis.model.get(logoAxis.currentIndex)

    // These functions can be called by other elements of the theme if the collection
    // has to be changed manually. See the connection between the Collection and
    // Details views in the main theme file.
    function selectNext() {
        logoAxis.incrementCurrentIndex();
    }
    function selectPrev() {
        logoAxis.decrementCurrentIndex();
    }

    //bgBlock
    // The carousel of background images. This isn't the item we control with the keys,
    // however it reacts to mouse and so should still update the Index.
    Carousel {
        id: bgAxis

        anchors.fill: parent
        itemWidth: width

        model: api.collections
        delegate: bgAxisItem
        currentIndex: logoAxis.currentIndex

        highlightMoveDuration: 500 // it's moving a little bit slower than the main bar
    }
    Component {
        // Either the image for the collection or a single colored rectangle
        id: bgAxisItem

        Item {
            width: root.width
            height: root.height
            visible: PathView.onPath // optimization: do not draw if not visible
        }
    }

    Item {
        id: logoBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        // The main carousel that we actually control
        Carousel {
            id: logoAxis

            anchors.fill: parent
            itemWidth: vpx(500)

            model: api.collections
            delegate: CollectionLogo {
                longName: modelData.name
                shortName: modelData.shortName
            }

            focus: true

            Keys.onPressed: {
                if (event.isAutoRepeat)
                    return;

                if (api.keys.isNextPage(event)) {
                    event.accepted = true;
                    incrementCurrentIndex();
                }
                else if (api.keys.isPrevPage(event)) {
                    event.accepted = true;
                    decrementCurrentIndex();
                }
            }

            onItemSelected: root.collectionSelected()
        }
    }

    Item {
      id: collectionHeader
      width: parent.width
      height: vpx(120)
      // color: "transparent"
      anchors {
        top: parent.top
        //horizontalCenter: parent.horizontalCenter
        left: parent.left
        right: parent.right
      }

      Rectangle {
        id: collectionHeaderBg
        width: parent.width
        height: parent.height
        color: "#f6f6f6"
        visible: true
      }

      Text {
        id: systemNameHeader
        anchors {
          left: parent.left; leftMargin: vpx(20)
          top: parent.top; topMargin: vpx(12)
          }
        text: "%1".arg(currentCollection.name) || "Not Found"
        color: "black"
        font.family: "coolvetica"
        fontSizeMode: Text.Fit; minimumPixelSize: vpx(30); font.pixelSize: vpx(52)
        font.capitalization: Font.AllUppercase
        font.weight: Font.Bold
        font.letterSpacing: vpx(2)
        Behavior on text {
          FadeAnimation {
              target: systemNameHeader
            }
          }
        }
      Text {
          id: systemItemCount
          anchors {
            left: parent.left; leftMargin: vpx(20)
            top: systemNameHeader.bottom
            }
          text: "≡ %1 TITLES AVAILABLE".arg(currentCollection.games.count)
          color: "black"
          font.pixelSize: vpx(20)
          font.family: "coolvetica"
          Behavior on text {
            FadeAnimation {
                target: systemItemCount
              }
            }
        }
    }
}

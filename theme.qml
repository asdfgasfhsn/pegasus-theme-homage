import QtQuick 2.15
import QtGraphicalEffects 1.15
import "utils.js" as Utils

FocusScope {
    id: rootTheme

    property var favouriteGames: {
        var out = [];
        for (var i = 0; i < api.allGames.count; i++) {
            var g = api.allGames.get(i);
            if (g.favorite) out.push(g);
        }
        return out;
    }
    property bool hasFavourites: favouriteGames.length > 0
    property var favouritesPseudoCollection: ({
        name: "Favourites",
        shortName: "@favourites",
        games: favouriteGames,
        assets: { logo: "" }
    })
    property var combinedCollections: {
        var arr = [];
        if (hasFavourites) arr.push(favouritesPseudoCollection);
        for (var i = 0; i < api.collections.count; i++) arr.push(api.collections.get(i));
        return arr;
    }

    onHasFavouritesChanged: {
        if (!hasFavourites
            && detailsView.focus
            && detailsView.currentCollection
            && detailsView.currentCollection.shortName === "@favourites") {
            detailsView.cancel();
        }
    }

    // After a favourite is toggled, combinedCollections may grow (favourites
    // entry appearing) or shrink (last favourite removed). The carousel's
    // currentIndex stays the same numerically, so it ends up pointing at a
    // different collection. Callers pass the shortName they want the carousel
    // to stay on and we re-target by lookup.
    function retargetCarousel(shortName) {
        if (!shortName) return;
        for (var i = 0; i < combinedCollections.length; i++) {
            if (combinedCollections[i].shortName === shortName) {
                if (collectionsView.currentCollectionIndex !== i) {
                    collectionsView.currentCollectionIndex = i;
                }
                return;
            }
        }
    }

    Component.onCompleted: {
        var savedShortName = api.memory.get('lastCollectionShortName');
        var startIndex = 0;
        if (savedShortName) {
            for (var i = 0; i < combinedCollections.length; i++) {
                if (combinedCollections[i].shortName === savedShortName) {
                    startIndex = i;
                    break;
                }
            }
        } else {
            var legacyIdx = api.memory.get('collectionIndex');
            if (legacyIdx !== undefined && legacyIdx !== null && legacyIdx >= 0 && legacyIdx < api.collections.count) {
                // Legacy index was into api.collections (pre-virtual-entry).
                // Map it onto combinedCollections by shortName.
                var legacyShortName = api.collections.get(legacyIdx).shortName;
                for (var j = 0; j < combinedCollections.length; j++) {
                    if (combinedCollections[j].shortName === legacyShortName) {
                        startIndex = j;
                        api.memory.set('lastCollectionShortName', legacyShortName);
                        break;
                    }
                }
            }
        }
        collectionsView.currentCollectionIndex = startIndex;
    }

    FontLoader {id: generalFont; source: "fonts/Rubik-Regular.ttf" }
    FontLoader {id: headerFont; source: "fonts/OpenSans-ExtraBold.ttf" }
    FontLoader {id: subheaderFont; source: "fonts/FredokaOne-Regular.ttf" }

      StarField {
          currentCollection: collectionsView.currentCollection
          anchors {
            left: parent.left
          }
      }

    CollectionsView {
        id: collectionsView
        anchors.bottom: parent.bottom

        focus: true
        onCollectionSelected: {
          detailsView.currentGameIndex = Utils.findInitialGameIndex(api.memory, currentCollection, detailsView.sortedGames);
          detailsView.focus = true
        }
    }
    DetailsView {
        id: detailsView
        anchors.top: collectionsView.bottom

        currentCollection: collectionsView.currentCollection

        onCancel: {
          Utils.persistCursor(api.memory, currentCollection, detailsView.sortedGames, currentGameIndex);
          collectionsView.focus = true
        }
        onNextCollection: {
          Utils.persistCursor(api.memory, currentCollection, detailsView.sortedGames, currentGameIndex);
          collectionsView.selectNext()
          detailsView.currentGameIndex = Utils.findInitialGameIndex(api.memory, currentCollection, detailsView.sortedGames);
        }
        onPrevCollection: {
          Utils.persistCursor(api.memory, currentCollection, detailsView.sortedGames, currentGameIndex);
          collectionsView.selectPrev()
          detailsView.currentGameIndex = Utils.findInitialGameIndex(api.memory, currentCollection, detailsView.sortedGames);
        }
        onLaunchGame: {
            Utils.persistCursor(api.memory, currentCollection, detailsView.sortedGames, currentGameIndex);
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

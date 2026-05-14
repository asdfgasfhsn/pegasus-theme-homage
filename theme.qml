import QtQuick 2.15
import QtGraphicalEffects 1.15
import "utils.js" as Utils

FocusScope {
    Component.onCompleted: {
        // Identity-based persistence with legacy fallback.
        var savedShortName = api.memory.get('lastCollectionShortName');
        var startIndex = 0;
        if (savedShortName) {
            for (var i = 0; i < api.collections.count; i++) {
                if (api.collections.get(i).shortName === savedShortName) {
                    startIndex = i;
                    break;
                }
            }
        } else {
            // One-time migration from the pre-identity scheme.
            var legacyIdx = api.memory.get('collectionIndex');
            if (legacyIdx !== undefined && legacyIdx !== null && legacyIdx >= 0 && legacyIdx < api.collections.count) {
                startIndex = legacyIdx;
                api.memory.set('lastCollectionShortName', api.collections.get(legacyIdx).shortName);
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
          detailsView.currentGameIndex = Utils.findInitialGameIndex(api.memory, currentCollection);
          detailsView.focus = true
        }
    }
    DetailsView {
        id: detailsView
        anchors.top: collectionsView.bottom

        currentCollection: collectionsView.currentCollection

        onCancel: {
          Utils.persistCursor(api.memory, currentCollection, currentGameIndex);
          collectionsView.focus = true
        }
        onNextCollection: {
          Utils.persistCursor(api.memory, currentCollection, currentGameIndex);
          collectionsView.selectNext()
          detailsView.currentGameIndex = Utils.findInitialGameIndex(api.memory, currentCollection);
        }
        onPrevCollection: {
          Utils.persistCursor(api.memory, currentCollection, currentGameIndex);
          collectionsView.selectPrev()
          detailsView.currentGameIndex = Utils.findInitialGameIndex(api.memory, currentCollection);
        }
        onLaunchGame: {
            Utils.persistCursor(api.memory, currentCollection, currentGameIndex);
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

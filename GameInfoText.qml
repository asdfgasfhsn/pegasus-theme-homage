import QtQuick 2.8

// All the game details text have the same basic properties
// so I've moved them into a new QML type.

Text {
    font.pixelSize: vpx(12)
    font.family: globalFonts.condensed
    font.weight: Font.Bold
    elide: Text.ElideRight
}

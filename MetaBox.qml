import QtQuick 2.8
import QtQuick.Layouts 1.11

  Rectangle {
    id: root
    property string metaTitle
    property string metaContent
    width: vpx(66)
    height: vpx(66)
    color: "transparent"

  RowLayout {
    id: rowcontent
    anchors.verticalCenter: root.verticalCenter
    anchors.horizontalCenter: root.horizontalCenter
    Rectangle {
      id: ratingCircle
      width: root.width
      height: root.height
      color: "#f6f6f6"
      clip: true

    Text {
      text: metaTitle
      color: "black"
      width: parent.width
      font.family: subheaderFont.name// globalFonts.condensed
      fontSizeMode: Text.Fit; minimumPixelSize: vpx(8); font.pixelSize: vpx(10)
      font.weight: Font.Bold
      font.capitalization: Font.AllUppercase
      horizontalAlignment: Text.AlignHCenter
      padding: vpx(4)
      anchors {
        bottom: parent.bottom;
        left: parent.left; right: parent.right
      }
    }

    Text {
      id: metaValue
      text: metaContent
      color: "black"
      width: parent.width
      height: parent.height
      font.family: subheaderFont.name
      font.weight: Font.Bold
      font.capitalization: Font.AllUppercase
      fontSizeMode: Text.Fit; minimumPixelSize: vpx(10); font.pixelSize: vpx(44)
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      padding: vpx(10)

      Behavior on text { FadeAnimation { target: metaValue }}

      }
    }
  }
}

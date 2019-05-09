import QtQuick 2.8
import QtQuick.Layouts 1.11

  Rectangle {
    id: root
    property string titletext
    property var game

    color: "#f3f3f3"

    property real textWidth: {
        if (textMetrics.width > vpx(1230)) return vpx(1230);
                return textMetrics.width;
    }

    width: textWidth + vpx(10)
    height: parent.height
    clip: true

    Text {
        id: textMetrics
        font.capitalization: Font.AllUppercase
        font.family: globalFonts.sansFont
        font.pixelSize: vpx(52)
        font.weight: Font.Bold
        text: titletext
        visible: false
    }

    Text {
        id: titleText
        color: "black"
        text: textMetrics.text
        font: textMetrics.font
        width: textWidth

        leftPadding: vpx(10)

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        fontSizeMode: Text.Fit
        minimumPixelSize: vpx(40)
        Layout.maximumWidth: vpx(1100)
        elide: Text.ElideRight
      }
   }

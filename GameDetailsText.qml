import QtQuick 2.8
import QtQuick.Layouts 1.11

  Rectangle {
    id: root
    property string metatext
    Layout.minimumWidth: rowcontent.width + vpx(4);
    Layout.maximumWidth: vpx(260);
    Layout.minimumHeight: rowcontent.height //+ vpx(6);
    Layout.alignment: Qt.AlignHCenter;
    color: "transparent"

  RowLayout {
    id: rowcontent
    anchors.verticalCenter: root.verticalCenter
    anchors.horizontalCenter: root.horizontalCenter
      Text {
          id: metaData
          text: metatext
          font.family: globalFonts.condensed
          font.pixelSize: vpx(14)
          font.capitalization: Font.AllUppercase
          color: "#f3f3f3"
          elide: Text.ElideRight
          Layout.maximumWidth: vpx(250)
      }
    }
  }

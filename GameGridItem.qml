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
import QtGraphicalEffects 1.12

Rectangle {
    id: root

    property bool selected: false
    property var game
    property var systemColor

    border.color: selected ? systemColor : "transparent"//"#99FFFFFF"
    border.width: vpx (6) // selected ? vpx(3) : 0
    color: selected ? "#000000" : "transparent"

    property alias imageWidth: boxFront.paintedWidth
    property alias imageHeight: boxFront.paintedHeight
    property real imageHeightRatio: 0.5


    height: width * imageHeightRatio

    signal clicked()
    signal doubleClicked()
    signal imageLoaded(int imgWidth, int imgHeight)

    scale: selected ? 1.5 : 1.0
    opacity: 1 //selected ? 1 : 0.666
    z: selected ? 3 : 1

    Behavior on scale { PropertyAnimation { duration: 333 } }
    Behavior on opacity { PropertyAnimation { duration: 333 } }

    layer.enabled: selected ? true : false
    layer.effect: DropShadow {
      fast: true
      spread: 0.1
      horizontalOffset: 0
      verticalOffset: 0
      radius: vpx(12)
      samples: 20
      color:  "#000000"
      transparentBorder: true
    }

    Image {
        id: boxFront
        anchors { fill: parent; margins: vpx(4) }

        asynchronous: true
        visible: game.assets.boxFront

        source: game.assets.boxFront || ""
        sourceSize { width: 256; height: 256 }
        fillMode: Image.PreserveAspectFit
        smooth: true

        onStatusChanged: if (status === Image.Ready) {
            imageHeightRatio = paintedHeight / paintedWidth;
            root.imageLoaded(paintedWidth, paintedHeight);
          }
      }

    Image {
        anchors.centerIn: parent

        visible: boxFront.status === Image.Loading
        source: "assets/loading-spinner.png"

        RotationAnimator on rotation {
            loops: Animator.Infinite;
            from: 0;
            to: 360;
            duration: 2000
        }
    }

    Rectangle {
      id: textBox
      width: boxFront.width
      height: boxFront.height
      anchors.centerIn: parent
      // anchors.margins: vpx(4)
      visible: !game.assets.boxFront
      color: "#000000"
    }

    Text {
        width: parent.width - vpx(10)
        height: parent.height - vpx(10)
        anchors.centerIn: parent

        visible: !game.assets.boxFront

        text: game.title
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
        color: "#eee"
        font {
            pixelSize: vpx(16)
            family: globalFonts.condensed
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
        onDoubleClicked: root.doubleClicked()
    }
}

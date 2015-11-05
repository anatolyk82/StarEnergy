import QtQuick 2.0
import "../common"


/*!
  \qmltype Curtain
  \inherits Rectangle
  \brief A game curtain. It coves the screen.
*/



Rectangle {
    id: curtain

    /*!
      \qmlproperty string Curtain::totalScores
      \brief It's of game scores shown on the curtain.
     */
    property string totalScores: ""


    /*!
      \qmlproperty int Curtain::closeDuration
      \brief It holds how long the curtain closes. The default value is 400 ms.
     */
    property int closeDuration: 400


    /*!
      \qmlproperty int Curtain::openDuration
      \brief It holds how long the curtain opens. The default value is 2000 ms.
     */
    property int openDuration: 2500

    /*!
      \qmlmethod void Curtain::open()
      It opens the curtain.
    */
    function open() {
        animCurtain.duration = openDuration
        curtain.opacity = 1
    }


    /*!
      \qmlmethod void Curtain::close()
      It closes the curtain.
    */
    function close() {
        animCurtain.duration = closeDuration
        curtain.opacity = 0
    }

    z: 10
    anchors.fill: parent
    color: "black"
    visible: opacity != 0
    opacity: 0
    Column {
        anchors.centerIn: parent
        spacing: 20
        Label {
            id: scoreLabelCurtain
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Scores") + ": " + totalScoresString
            font.pixelSize: 20
            color: "white"
        }
        Label {
            id: curtainLabel
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Next level")
            font.pixelSize: 24
            color: "white"
        }
    }
    Behavior on opacity { NumberAnimation { id: animCurtain; duration: 2500 } }
}


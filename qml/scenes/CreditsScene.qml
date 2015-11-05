import QtQuick 2.0
import VPlay 2.0
import "../common"


/*!
  \qmltype CreditScene
  \inherits BaseScene
  \brief This scene shows information about the game.
*/

BaseScene {
    id:creditsScene

    headerText: qsTr("Credits")

    Flickable {
        id: flickable
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.top: header.bottom
        anchors.topMargin: 10

        clip: true

        contentWidth: itemContent.width
        contentHeight: itemContent.height

        flickableDirection: Flickable.VerticalFlick
        interactive: true

        Item {
            id: itemContent
            anchors.horizontalCenter: parent.horizontalCenter
            width: creditsScene.width
            height: lblProgramming.height+lblMusic.height+lblSounds.height+lblArt.height+lblFont.height+lblPowered.height+lblVPlay.height+6*10+100
            Label {
                id: lblProgramming
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: app.portrait ? 22 : 12
                text: qsTr("Programming") + ": Anatoly Kozlov"
                color: "white"
            }
            Label {
                id: lblMusic
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: lblProgramming.bottom
                anchors.topMargin: app.portrait ? 22 : 12
                text: qsTr("Music") + ": <a href='http://soundimage.org'>http://soundimage.org</a>"
                color: "white"
            }
            Label {
                id: lblSounds
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: lblMusic.bottom
                anchors.topMargin: app.portrait ? 22 : 12
                text: qsTr("Sounds") + ": <a href='http://www.freesound.org'>http://www.freesound.org</a>"
                color: "white"
            }
            Label {
                id: lblArt
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: lblSounds.bottom
                anchors.topMargin: app.portrait ? 22 : 12
                text: qsTr("Art") + ": <a href='http://www.gameart2d.com'>http://www.gameart2d.com</a>"
                color: "white"
            }
            Label {
                id: lblFont
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: lblArt.bottom
                anchors.topMargin: app.portrait ? 22 : 12
                text: qsTr("Font") + ": <a href='http://1001freefonts.com'>http://1001freefonts.com</a>"
                color: "white"
            }
            Label {
                id: lblPowered
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: lblFont.bottom
                anchors.topMargin: app.portrait ? 22 : 12
                text: qsTr("Powered by")
                color: "white"
            }
            Label {
                id: lblVPlay
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: lblPowered.bottom
                anchors.topMargin: app.portrait ? 22 : 12
                text: qsTr("Qt Quick 5.5 and V-Play")
                color: "white"
            }
            Image {
                source: "../../assets/img/vplay-logo.png"
                width: 48
                height: 48
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: lblVPlay.bottom
                anchors.topMargin: app.portrait ? 22 : 12
            }
        }
    }

}


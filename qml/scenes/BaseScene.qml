import VPlay 2.0
import QtQuick 2.0
import "../common"

/*!
  \qmltype Main
  \inherits GameWindow
  \brief This is the main scene for all scenes in the game.
*/

Scene {
    id: baseScene


    // by default, set the opacity to 0 - this is changed from the main.qml with PropertyChanges
    opacity: 0
    // we set the visible property to false if opacity is 0 because the renderer skips invisible items, this is an performance improvement
    visible: opacity > 0
    // if the scene is invisible, we disable it. In Qt 5, components are also enabled if they are invisible. This means any MouseArea in the Scene would still be active even we hide the Scene, since we do not want this to happen, we disable the Scene (and therefore also its children) if it is hidden
    enabled: visible

    // every change in opacity will be done with an animation
    Behavior on opacity {
        NumberAnimation {property: "opacity"; easing.type: Easing.InOutQuad}
    }


    /* properties for configuration of the scene page */
    /*!
      \qmlproperty string BaseScene::backText
      \brief This property holds the text of the back button on each scene.
     */
    property alias backText: buttonBack.text

    /*!
      \qmlproperty alias BaseScene::buttonBack
      \brief This alias allows access to the back button object.
     */
    property alias buttonBack: buttonBack

    /*!
      \qmlproperty url BaseScene::backgroundImage
      \brief The source of the background image.
     */
    property alias backgroundImage: backgroundImage.source

    /*!
      \qmlproperty string BaseScene::headerText
      \brief This property hold the text of the page header.
     */
    property alias headerText: labelHeader.text

    /*!
      \qmlproperty alias BaseScene::labelHeader
      \brief This alias allows access to the header object.
     */
    property alias header: labelHeader


    //the back button
    MenuButton {
        id: buttonBack
        z: 2
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 5
        text: qsTr("Back")
        //imageSource: "../../assets/buttons/button_menu_blue.png"
        //imageSourcePressed: "../../assets/buttons/button_menu_yellow.png"
        onClicked: backButtonPressed()
    }


    //background image
    BackgroundImage {
        id: backgroundImage
        smooth: true
        antialiasing: true
        source: "../../assets/img/background.jpg"
    }

    // the header
    Label {
        id: labelHeader
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: app.portrait ? 70 : 18
        font.pixelSize: 32
        color: "blue"
        font.bold: true
    }
}

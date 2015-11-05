import QtQuick 2.4
import VPlay 2.0
import "../common"

/*!
  \qmltype MenuScene
  \inherits BaseScene
  \brief This scene shows the main menu of the game.
*/

BaseScene {
    id: menuScene

    headerText: qsTr("Star energy")

    // signals that indicating that the an item menu had been selected
    /*!
      \qmlsignal void MenuScene::selectLevelPressed()
      \brief It is emitted when the user selects "Game". SelectLevelScene becomes active.
     */
    signal gamePressed

    /*!
      \qmlsignal void MenuScene::settingsPressed()
      \brief It is emitted when the user selects "Settings". SettingsScene becomes active.
     */
    signal settingsPressed

    /*!
      \qmlsignal void MenuScene::creditsPressed()
      \brief It is emitted when the user selects "Credits". CreditsScene becomes active.
     */
    signal creditsPressed

    /*!
      \qmlsignal void MenuScene::quitPressed()
      \brief It is emitted when the user selects "Quit".
     */
    signal quitPressed

    /*!
      \qmlsignal void MenuScene::quitPressed()
      \brief It is emitted when the user selects "Highscores".
     */
    signal highscoresPressed()

    //do not need to see the back button here
    buttonBack.visible: false

    // menu
    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 25
        spacing: app.portrait ? 20 : 15
        z: 5
        MenuButton {
            text: qsTr("Game")
            anchors.horizontalCenter: parent.horizontalCenter
            //imageSource: "../../assets/buttons/button_game_blue.png"
            //imageSourcePressed: "../../assets/buttons/button_game_yellow.png"
            onClicked: gamePressed()
        }
        MenuButton {
            text: qsTr("Highscores")
            anchors.horizontalCenter: parent.horizontalCenter
            //imageSource: "../../assets/buttons/button_game_blue.png"
            //imageSourcePressed: "../../assets/buttons/button_game_yellow.png"
            onClicked: highscoresPressed()
        }
        MenuButton {
            text: qsTr("Settings")
            anchors.horizontalCenter: parent.horizontalCenter
            //imageSource: "../../assets/buttons/button_settings_blue.png"
            //imageSourcePressed: "../../assets/buttons/button_settings_yellow.png"
            onClicked: settingsPressed()
        }
        MenuButton {
            text: qsTr("Credits")
            anchors.horizontalCenter: parent.horizontalCenter
            //imageSource: "../../assets/buttons/button_about_blue.png"
            //imageSourcePressed: "../../assets/buttons/button_about_yellow.png"
            onClicked: creditsPressed()
        }
        MenuButton {
            text: qsTr("Quit")
            anchors.horizontalCenter: parent.horizontalCenter
            //imageSource: "../../assets/buttons/button_quit_blue.png"
            //imageSourcePressed: "../../assets/buttons/button_quit_yellow.png"
            onClicked: quitPressed()
        }
    }

}


import QtQuick 2.4
import VPlay 2.0
import QtQuick.XmlListModel 2.0

import "scenes"

/*!
  \qmltype Main
  \inherits GameWindow
  \brief The main window of the game
*/

GameWindow {
    id: app
    width: 480
    height: 854

    // You get free licenseKeys from http://v-play.net/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from http://v-play.net/licenseKey>"

    title: qsTr("Star energy")

    // create and remove entities at runtime
    EntityManager {
        id: entityManager
        entityContainer: gameScene
        poolingEnabled: true
    }

    displayFpsEnabled: true


    // menu scene
    MenuScene {
        id: menuScene
        // listen to the button signals of the scene and change the state according to it
        onGamePressed: {
            app.state = "game"
            gameScene.startGame()
        }
        onHighscoresPressed: {
            highscoresScene.getResults()
            app.state = "highscores"
        }
        onSettingsPressed: app.state = "settings"
        onCreditsPressed: app.state = "credits"
        onQuitPressed: {
            nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
        }
        // the menu scene is our start scene, so if back is pressed there we ask the user if he wants to quit the application
        onBackButtonPressed: {
            nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
        }
        // listen to the return value of the MessageBox
        Connections {
            target: nativeUtils
            onMessageBoxFinished: {
                // only quit, if the activeScene is menuScene - the messageBox might also get opened from other scenes in your code
                if(accepted && app.activeScene === menuScene)
                    Qt.quit()
            }
        }
    }

    HighscoresScene {
        id: highscoresScene
        onBackButtonPressed: app.state = "menu"
    }

    SettingsScene {
        id: settingsScene
        onBackButtonPressed: app.state = "menu"
    }

    // credits scene
    CreditsScene {
        id: creditsScene
        onBackButtonPressed: app.state = "menu"
    }

    // game scene to play a level
    GameScene {
        id: gameScene
        onBackButtonPressed: app.state = "menu"
    }

    // menuScene is our first scene, so set the state to menu initially
    state: "menu"
    activeScene: menuScene

    // state machine, takes care reversing the PropertyChanges when changing the state, like changing the opacity back to 0
    states: [
        State {
            name: "menu"
            PropertyChanges {target: menuScene; opacity: 1}
            PropertyChanges {target: app; activeScene: menuScene}
        },
        State {
            name: "highscores"
            PropertyChanges {target: highscoresScene; opacity: 1}
            PropertyChanges {target: app; activeScene: highscoresScene}
        },
        State {
            name: "settings"
            PropertyChanges {target: settingsScene; opacity: 1}
            PropertyChanges {target: app; activeScene: settingsScene}
        },
        State {
            name: "credits"
            PropertyChanges {target: creditsScene; opacity: 1}
            PropertyChanges {target: app; activeScene: creditsScene}
        },
        State {
            name: "game"
            PropertyChanges {target: gameScene; opacity: 1}
            PropertyChanges {target: app; activeScene: gameScene}
        }
    ]


    Connections {
        target: settings
        onMusicEnabledChanged: {
            //if( (backgroundMusic.playing == false)&&(settings.musicEnabled ) )
        }
    }



    //this storages stars for each level and it's available via a key "levelN"
    Storage {
        id: myLocalStorage
    }


    BackgroundMusic {
        id: backgroundMusic
        source: app.state == "game" ?
                    (settings.musicEnabled ? "../assets/music/MysteriousMagic.mp3" : "") :
                    (settings.musicEnabled ? "../assets/music/ChamberOfJewels.mp3" : "")
        volume: 0.5
    }

    Component.onCompleted: {
        //myLocalStorage.clearAll()
    }
}



import QtQuick 2.4
import "../common"

/*!
  \qmltype SettingsScene
  \inherits BaseScene
  \brief This scene shows game settings.
*/

BaseScene {
    id: settingsScene

    headerText: qsTr("Settings")

    Column {
        anchors.centerIn: parent
        spacing: app.portrait ? 20 : 18

        MenuButton {
            id: buttonMusicEnable
            checkable: true
            imageSource: "../../assets/buttons/button_music_blue.png"
            imageSourcePressed: "../../assets/buttons/button_music_yellow.png"
            imageSourceChecked:  "../../assets/buttons/button_music_grey.png"
            text: qsTr("Music") + ": " + (checked ? qsTr("On") : qsTr("Off"))
            checked: settings.musicEnabled
            onClicked: { settings.musicEnabled = checked }
        }

        MenuButton {
            id: buttonSoundEnable
            checkable: true
            imageSource: "../../assets/buttons/button_sound_blue.png"
            imageSourcePressed: "../../assets/buttons/button_sound_yellow.png"
            imageSourceChecked:  "../../assets/buttons/button_sound_grey.png"
            text: qsTr("Sound") + ": " + (checked ? qsTr("On") : qsTr("Off"))
            checked: settings.soundEnabled
            onClicked: {
                settings.soundEnabled = checked
            }
        }
    }
}

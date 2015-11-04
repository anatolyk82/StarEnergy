import QtQuick 2.4
import VPlay 2.0

/*!
  \qmltype MenuButton
  \inherits Rectangle
  \brief A push button with a text label and a picture.
*/

Rectangle {
    id: button

    width: imageButton.width + buttonText.width + (button.text == "" ? 0 : 20)
    height: 40

    color: "transparent"
    //border.color: "gray"

    /*!
      \qmlproperty string MenuButton::text
      \brief This property holds the text shown on the button. If the button has no text, the text property will be an empty string.
     */
    property alias text: buttonText.text

    /*!
      \qmlsignal void MenuButton::buttonBack()
      \brief This signal is emitted when the button is clicked.
     */
    signal clicked

    /*!
      \qmlproperty url MenuButton::imageSource
      \brief This property holds the icon shown on the button.
     */
    property url imageSource: ""

    /*!
      \qmlproperty url MenuButton::imageSourcePressed
      \brief This property holds the icon shown on the button when the button is pressed.
     */
    property url imageSourcePressed: ""

    /*!
      \qmlproperty url MenuButton::imageSourceChecked
      \brief This property holds the icon shown on the button when the button is checked.
     */
    property url imageSourceChecked: ""

    /*!
      \qmlproperty bool MenuButton::checkable
      \brief This property holds whether the button is checkable.
      The default value is false
     */
    property bool checkable: false

    /*!
      \qmlproperty bool MenuButton::checked
      \brief This property holds whether the button is checked.
      The default value is false
     */
    property bool checked: false

    /*!
      \qmlproperty bool MenuButton::textColor
      \brief The color of the text shown on the button.
      The default value is "black"
     */
    property color textColor: "white"

    /*!
      \qmlproperty bool MenuButton::textColorPressed
      \brief The color of the text shown on the button when the button is pressed.
      The default value is "yellow"
     */
    property color textColorPressed: "yellow"

    /*!
      \qmlproperty bool MenuButton::textColorChecked
      \brief The color of the text shown on the button when the button is checked.
      The default value is "grey"
     */
    property color textColorChecked: "grey"

    /*!
      \qmlproperty int MenuButton::textSize
      \brief The size of the text in pixels.
     */
    property alias textSize: buttonText.font.pixelSize

    /*!
      \qmlproperty bool MenuButton::soundEnabled
      \brief Whether the sounds plays when the button is pressed.
     */
    property bool soundEnabled: true

    clip: true

    MultiResolutionImage {
        id: imageButton
        smooth: true
        antialiasing: true
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        height: parent.height*0.9
        fillMode: Image.PreserveAspectFit
        source: mouseArea.pressed ? imageSourcePressed : (button.checkable ? (button.checked ? imageSource : imageSourceChecked) : imageSource)
    }

    Label {
        id: buttonText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: imageButton.right
        anchors.leftMargin: 10
        font.pixelSize: 20
        color: mouseArea.pressed ? textColorPressed : (button.checkable ? (button.checked ? textColor : textColorChecked) : textColor)
    }

    //cover the button with a mouse area
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            playSound("../../assets/sounds/button.wav")
            if( button.checkable ) {
                button.checked = !button.checked
            }
            button.clicked()
        }
    }


    Component {
        id: componentSounds
        SoundEffectVPlay {
            id: soundEffect
            onPlayingChanged: {
                if( playing == false ) {
                    soundEffect.destroy()
                }
            }
        }
    }

    /*!
      \qmlmethod MenuButton::playSound( url file )

      It plays a sound when the button is pressed
     */
    function playSound( file ) {
        if( button.soundEnabled == false ) return
        var snd = componentSounds.createObject(button, {"source": file});
        if (snd == null) {
            console.log("Error creating sound");
        } else {
            snd.play()
        }
    }
}


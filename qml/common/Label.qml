import QtQuick 2.4

/*!
  \qmltype Label
  \inherits Text
  \brief It shows text on a scene with preloaded font and a possibility to open a web link in case if the Label has it.
*/

Text {
    id: txt
    font.family: gameFontFont.name
    onLinkActivated: { Qt.openUrlExternally(link) }

    FontLoader {
        id: gameFontFont
        source: "../../assets/fonts/Aero.ttf"
    }
}

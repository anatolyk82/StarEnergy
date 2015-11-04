import QtQuick 2.4
import VPlay 2.0

import "../common"

BaseScene {
    id: settingsScene

    headerText: qsTr("Highscores")

    Label {
        id: result
        anchors.centerIn: parent
        text: qsTr("Scores")
        font.pixelSize: 24
        color: "white"
    }


    function getResults() {
        var s = myLocalStorage.getValue("totalScores")
        if( s == undefined ) {
            result.text = qsTr("Scores")+": 0"
        } else {
            result.text = qsTr("Scores")+": " + s
        }
    }
}

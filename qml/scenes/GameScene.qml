import VPlay 2.0
import QtQuick 2.0
import "../common"
import "../game"

BaseScene {
    id:gameScene

    //number of cells on the game field
    property int numCells: 42

    //current game level
    property int currentLevel: 0

    //the property helps to create a unique id for a star
    property int __uniqueStarId: 0

    //the property holds the number of genereated stars for each level
    property int countOfStars: 0

    //the property holds the number of user's energy
    property int usersEnergy: 10
    onUsersEnergyChanged: {
        if( usersEnergy == 0 ) {
            timerGameOver.start()
        } else {
            timerGameOver.stop()
        }
    }

    property int totalScores: 0
    property string totalScoresString: "00000"
    onTotalScoresChanged: {
        if( totalScores < 9 ) {
            totalScoresString = "0000" + totalScores
        } else if( totalScores < 99 ) {
            totalScoresString = "000" + totalScores
        } else if( totalScores < 999 ) {
            totalScoresString = "00" + totalScores
        } else if( totalScores < 9999 ) {
            totalScoresString = "0" + totalScores
        } else {
            totalScoresString = totalScores
        }
    }

    onBackButtonPressed: {
        stopGame()
    }


    function startGame() {
        curtain.close()
        labelGameOver.visible = false
        currentLevel = 1
        totalScores = 0
        usersEnergy = 10
        generateGameStars()
    }

    function stopGame() {
        var toRemoveEntityTypes = ["starType", "bulletType"];
        entityManager.removeEntitiesByFilter(toRemoveEntityTypes);

        var savedTotalScores = myLocalStorage.getValue("totalScores")
        if( savedTotalScores == undefined ) {
            myLocalStorage.setValue( "totalScores", totalScores )
        } else if( savedTotalScores < totalScores ) {
            myLocalStorage.setValue( "totalScores", totalScores )
        }
    }

    function nextLevel() {
        if( usersEnergy > 0 ) {
            curtain.open()
            timerToGoToTheNextLevel.start()
        }
    }

    Label {
        id: levelLabel
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Level") + ": " + currentLevel
        color: "white"
        font.pixelSize: 20
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        spacing: 5
        Row {
            spacing: 10
            Image {
                id: imgEnergy
                source: "../../assets/img/bullet.png"
                anchors.verticalCenter: parent.verticalCenter
                width: 15
                height: width
            }
            Label {
                id: energyLabel
                anchors.verticalCenter: parent.verticalCenter
                text: usersEnergy
                color: "white"
                font.pixelSize: 15
            }
        }
        Label {
            id: scoreLabel
            text: totalScoresString
            color: "white"
            font.pixelSize: 15
        }
    }


    PhysicsWorld {
        id: world
        gravity: Qt.point(0,0)
        running: true
        debugDrawVisible: false

        Wall {
            id: bottomWall
            height: 10
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: -height
            }
            onTouchedByBullet: entityManager.removeEntityById( bulletEntityId )
        }
        Wall {
            id: topWall
            height: 10
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                topMargin: -height
            }
            onTouchedByBullet: entityManager.removeEntityById( bulletEntityId )
        }
        Wall {
            id: leftWall
            width: 10
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                leftMargin: -width
            }
            onTouchedByBullet: entityManager.removeEntityById( bulletEntityId )
        }
        Wall {
            id: rightWall
            width: 10
            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                rightMargin: -width
            }
            onTouchedByBullet: entityManager.removeEntityById( bulletEntityId )
        }

        Grid {
            id: grid
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.left: parent.left
            anchors.right: parent.right
            columns: 6
            Repeater {
                id: repeater
                model: numCells
                delegate: Rectangle {
                    id: tile
                    width: gameScene.width/grid.columns
                    height: width
                    color: "white"
                    opacity: 0
                    radius: 5
                }
            }
        }

    }


    function generateState( level ) {
        var pass = Math.round( utils.generateRandomValueBetween(1,100) )
        var probPass = 7+2*level //probability to pass a cell
        if( pass < probPass ) {
            return -1
        }

        var probTouches0 = 20+2*level
        probTouches0 = probTouches0 > 100 ? 100 : probTouches0
        var probTouches1 = 55+2*level
        probTouches1 = probTouches1 > 100 ? 100 : probTouches1

        var rV = Math.round( utils.generateRandomValueBetween(1,100) )
        if( rV <= probTouches0 ) {
            return 0
        } else if( rV <= probTouches1 ) {
            return 1
        } else {
            return 2
        }
    }


    property bool __nextLevelAvailable: true
    onCountOfStarsChanged: {
        if( (countOfStars == 0)&&(__nextLevelAvailable) ) {
            nextLevel()
        }
    }

    function generateGameStars()
    {
        __nextLevelAvailable = false
        countOfStars = 0
        for( var index=0; index<numCells; index++) {
            var item = repeater.itemAt(index)
            var columns = grid.columns
            var starId = "star"+(index+__uniqueStarId)
            var radius = item.width*0.45
            var x = (index%columns)*item.width + item.width/2 - radius
            var y = grid.anchors.topMargin + Math.floor(index/columns)*item.height + item.height/2 - radius
            var fillCell = generateState( currentLevel )
            if( fillCell < 0 ) continue
            entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("../game/Star.qml"),{
                                                                "entityId": starId,
                                                                "radius": radius,
                                                                "x" : x,
                                                                "y" : y,
                                                                "z" : 4,
                                                                countTouches: fillCell,
                                                                starIndex: index,
                                                                probabilityToGenerateEnergy: 10
                                                            })
            var starObject = entityManager.getEntityById( starId )
            starObject.touchedByBullet.connect( starTouchedByBulletSlot ) //remove this bullet
            starObject.starIsExploding.connect( starIsExplodingSlot )
            starObject.entityClicked.connect( starClickedSlot )
            starObject.generateEnergy.connect( generateEnergySlot )
            countOfStars += 1
        }
        __uniqueStarId += numCells
        __nextLevelAvailable = true
    }

    //it removes a bullet from the game field whenever the bullet touches a star
    function starTouchedByBulletSlot( bulletEntityId ) {
        entityManager.removeEntityById( bulletEntityId )
    }

    //it decreases the counter of stars when a star is exploding
    function starIsExplodingSlot( scores ) {
        countOfStars = countOfStars - 1
        totalScores += scores
    }

    //it decreases the counter of energy when the user touches a star
    function starClickedSlot() {
        usersEnergy -= 1
        totalScores += 10 //add 10 points to the scores whenever the user burns one energy
    }

    //it generates a point of energy
    function generateEnergySlot( index ) {
        var item = repeater.itemAt(index)
        var columns = grid.columns
        var radius = item.width*0.45
        var x = (index%columns)*item.width + item.width/2 - radius
        var y = grid.anchors.topMargin + Math.floor(index/columns)*item.height + item.height/2 - radius
        var star = componentImageEnergy.createObject(gameScene, {"x": x, "y": y} );
        usersEnergy += 1
    }

    //Animation of energy
    Component {
        id: componentImageEnergy
        Image {
            id: imgEnergy
            source: "../../assets/img/bullet.png"
            width: 0.45*gameScene.width/grid.columns
            height: width
            Behavior on x { NumberAnimation { duration: 500 } }
            Behavior on y {
                NumberAnimation {
                    duration: 500
                    onRunningChanged: {
                        if( running == false ) {
                            imgEnergy.visible = false
                            imgEnergy.destroy()
                        }
                    }
                }
            }
            Component.onCompleted: {
                x = gameScene.width - 70
                y = 15
            }
        }
    }

    Timer {
        id: timerToGoToTheNextLevel
        interval: 3000
        repeat: false
        triggeredOnStart: false
        onTriggered: {            
            //destroy all stars and flying energy
            var toRemoveEntityTypes = ["starType", "bulletType"];
            entityManager.removeEntitiesByFilter(toRemoveEntityTypes);

            //generate stars for the next level
            generateGameStars()

            //remove the curtain
            curtain.close()

            //increase the level number
            currentLevel += 1
        }
    }

    Rectangle {
        id: curtain
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
        Behavior on opacity { NumberAnimation { id: animCurtain; duration: 2000 } }
        function open() {
            animCurtain.duration = 2000
            curtain.opacity = 1
        }
        function close() {
            animCurtain.duration = 400
            curtain.opacity = 0
        }
    }

    Timer {
        id: timerGameOver
        interval: 2000
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            var bufBullets = entityManager.getEntityArrayByType("bulletType")
            if( bufBullets.length == 0 ) {
                stopGame()
                labelGameOver.visible = true
                timerGameOver.stop()
            }
        }
    }

    Label {
        id: labelGameOver
        anchors.centerIn: parent
        text: qsTr("Game over")
        font.pixelSize: 24
        color: "white"
        visible: false
    }


    Component.onCompleted: {
        entityManager.createPooledEntitiesFromUrl( Qt.resolvedUrl("../game/Bullet.qml"), (numCells*4) )
    }

}


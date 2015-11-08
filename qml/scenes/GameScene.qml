import VPlay 2.0
import QtQuick 2.0
import "../common"
import "../game"

/*!
  \qmltype GameScene
  \inherits BaseScene
  \brief The main game field.
*/


BaseScene {
    id:gameScene

    /*!
      \qmlproperty int GameScene::numCells
      \brief This property holds the number of cells on the game field.
      By default it is 42
     */
    property int numCells: 42

    /*!
      \qmlproperty int GameScene::currentLevel
      \brief This property holds the number of current game level.
     */
    property int currentLevel: 0

    /*!
      \qmlproperty int GameScene::__uniqueStarId
      \brief This property helps to create a unique id for a star
     */
    property int __uniqueStarId: 0

    /*!
      \qmlproperty int GameScene::countOfStars
      \brief The property holds the number of genereated stars for each level
     */
    property int countOfStars: 0

    /*!
      \qmlproperty int GameScene::countOfStars
      \brief The property holds the available number of user's energy
     */
    property int usersEnergy: 10

    /*!
      \qmlproperty int GameScene::totalScores
      \brief The property holds game scores earned by the user
     */
    property int totalScores: 0

    /*!
      \qmlproperty int GameScene::totalScoresString
      \brief It's a formated string of game scores.
     */
    property string totalScoresString: "00000"

    onUsersEnergyChanged: {
        //if the user runs out of energy, we start the "game over" timer to check whether there are
        //flying energy on the game field to finish the game.
        if( usersEnergy == 0 ) {
            timerGameOver.start()
        } else {
            timerGameOver.stop()
        }
    }


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
        //when the user pushes "Back", stop the game
        stopGame()
    }


    /*!
      \qmlmethod void GameScene::startGame()
      It starts the game from the begining.
    */
    function startGame() {
        removeStarsAndFlyingEnergy()

        curtain.close()
        labelGameOver.visible = false
        currentLevel = 1
        totalScores = 0
        usersEnergy = 10
        generateGameStars()
    }

    /*!
      \qmlmethod void GameScene::stopGame()
      It stops the game, removes all stars and flying energy and saves the scores.
    */
    function stopGame() {
        removeStarsAndFlyingEnergy()

        var savedTotalScores = myLocalStorage.getValue("totalScores")
        if( savedTotalScores == undefined ) {
            myLocalStorage.setValue( "totalScores", totalScores )
        } else if( savedTotalScores < totalScores ) {
            myLocalStorage.setValue( "totalScores", totalScores )
        }
    }

    /*!
      \qmlmethod void GameScene::nextLevel()
      It initializes the next level if the user has enery points.
    */
    function nextLevel() {
        if( usersEnergy > 0 ) {
            curtain.open()
            timerToGoToTheNextLevel.start()
            playSound("../../assets/sounds/nextLevel.wav")
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


    /*!
      \qmlmethod int GameScene::generateState( int level )
      It generates a state of every cell on the game field for a level \a level.
      Return values can be:
       -1 the cell is passed.
       0 - the star0 is put on the cell.
       1 - the star1 is put on the cell.
       2 - the star2 is put on the cell.
    */
    function generateState( level ) {
        var pass = Math.round( utils.generateRandomValueBetween(1,100) )
        var probPass = 5+2*level //probability to pass a cell
        if( pass < probPass ) {
            return ""
        }

        var probTouches0 = 30+2*level
        probTouches0 = probTouches0 > 100 ? 100 : probTouches0
        var probTouches1 = 75+1*level
        probTouches1 = probTouches1 > 100 ? 100 : probTouches1

        var rV = Math.round( utils.generateRandomValueBetween(1,100) )
        if( rV <= probTouches0 ) {
            return "state0"
        } else if( rV <= probTouches1 ) {
            return "state1"
        } else {
            return "state2"
        }
    }


    /*!
      \qmlproperty bool GameScene::__nextLevelAvailable
      \brief This property for internal use. It shows whether the next level available to go.
     */
    property bool __nextLevelAvailable: true

    onCountOfStarsChanged: {
        if( (countOfStars == 0)&&(__nextLevelAvailable) ) {
            nextLevel()
        }
    }

    /*!
      \qmlmethod void GameScene::generateGameStars()
      It puts a str on every cell on the game field.
    */
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
            var stateCell = generateState( currentLevel )
            if( stateCell == "" ) continue
            entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("../game/Star.qml"),{
                                                                "entityId": starId,
                                                                "radius": radius,
                                                                "x" : x,
                                                                "y" : y,
                                                                "z" : 4,
                                                                state: stateCell,
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

    /*!
      \qmlmethod void GameScene::starTouchedByBulletSlot( string energyEntityId )
      This slot removes a flying energy from the game field whenever it touches a star
    */
    function starTouchedByBulletSlot( bulletEntityId ) {
        entityManager.removeEntityById( bulletEntityId )
    }

    /*!
      \qmlmethod void GameScene::starIsExplodingSlot( scores )
      This slot decreases the counter of stars when a star is exploding. It pass' scores for the exploding star.
    */
    function starIsExplodingSlot( scores ) {
        countOfStars = countOfStars - 1
        totalScores += scores
    }

    /*!
      \qmlmethod void GameScene::starClickedSlot( scores )
      This slot decreases the counter of energy when the user touches a star.
      It also gives the user ten points fot burning energy
    */
    function starClickedSlot() {
        usersEnergy -= 1
        totalScores += 10
    }

    /*!
      \qmlmethod void GameScene::starClickedSlot( index )
      This slot generates a picture of energy to animate getting an energy point.
      \a index - a number of cell where from the pictures starts moving towards game scores.
    */
    function generateEnergySlot( index ) {
        var item = repeater.itemAt(index)
        var columns = grid.columns
        var radius = item.width*0.45
        var x = (index%columns)*item.width + item.width/2 - radius
        var y = grid.anchors.topMargin + Math.floor(index/columns)*item.height + item.height/2 - radius
        var star = componentImageEnergy.createObject(gameScene, {"x": x, "y": y} );
        usersEnergy += 1
    }


    //It helps to animate a point of energy when the user gets one.
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
            removeStarsAndFlyingEnergy()

            //generate stars for the next level
            generateGameStars()

            //remove the curtain
            curtain.close()

            //increase the level number
            currentLevel += 1
        }
    }


    Curtain {
        id: curtain
        totalScores: totalScoresString
    }
    Binding {
        target: curtain
        property: "totalScores"
        value: totalScoresString
    }


    Timer {
        id: timerGameOver
        interval: 2000
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            var bufBullets = entityManager.getEntityArrayByType("bulletType")
            if( bufBullets.length == 0 ) {
                playSound("../../assets/sounds/gameOver.wav")
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

    /*!
      \qmlmethod void GameScene::removeStarsAndFlyingEnergy()
      It removes all stars and all flying energy from the game field. It also disconnects all slots from all star signals.
    */
    function removeStarsAndFlyingEnergy() {
        //first, disconnect all signals
        var bufStars = entityManager.getEntityArrayByType("starType")
        for( var j=0; j<bufStars.length; j++ ) {
            var starObject = bufStars[j]
            starObject.touchedByBullet.disconnect( starTouchedByBulletSlot )
            starObject.starIsExploding.disconnect( starIsExplodingSlot )
            starObject.entityClicked.disconnect( starClickedSlot )
            starObject.generateEnergy.disconnect( generateEnergySlot )
        }
        //second, remove all objects
        var toRemoveEntityTypes = ["starType", "bulletType"];
        entityManager.removeEntitiesByFilter(toRemoveEntityTypes);
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
      \qmlmethod void Star::playSound( url file )
      It plays sounds
     */
    function playSound( file ) {
        var snd = componentSounds.createObject(gameScene, {"source": file});
        if (snd == null) {
            console.log("Error creating sound");
        } else {
            snd.play()
        }
    }


    Component.onCompleted: {
        entityManager.createPooledEntitiesFromUrl( Qt.resolvedUrl("../game/Bullet.qml"), (numCells*4) )
        entityManager.createPooledEntitiesFromUrl( Qt.resolvedUrl("../game/Star.qml"), numCells )
    }

}


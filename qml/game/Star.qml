import VPlay 2.0
import QtQuick 2.4

/*!
  \qmltype Star
  \inherits EntityBaseDraggable
  \brief It's a game object representing a star on the game field.
*/



EntityBaseDraggable {
    id: star

    poolingEnabled: true
    entityType: "starType"

    /*!
      \qmlproperty int Star::radius
      \brief This property holds the radius of star.
     */
    property alias radius: starCollider.radius

    /*!
      \qmlproperty int Star::starIndex
      \brief This property holds the curent index of star on the game field.
     */
    property int starIndex: 0

    /*!
      \qmlproperty int Star::bulletUpId
      \brief This property helps to generate a unique id for a flying energy.
     */
    property string bulletUpId: star.entityId +  "_bullet_up"
    /*!
      \qmlproperty int Star::bulletUpId
      \brief This property helps to generate a unique id for a flying energy.
     */
    property string bulletDownId: star.entityId +  "_bullet_down"
    /*!
      \qmlproperty int Star::bulletUpId
      \brief This property helps to generate a unique id for a flying energy.
     */
    property string bulletRightId: star.entityId +  "_bullet_right"
    /*!
      \qmlproperty int Star::bulletUpId
      \brief This property helps to generate a unique id for a flying energy.
     */
    property string bulletLeftId: star.entityId +  "_bullet_left"

    property string bulletDownRightId: star.entityId +  "_bullet_down_right"
    property string bulletDownLeftId: star.entityId +  "_bullet_down_left"
    property string bulletUpRightId: star.entityId +  "_bullet_up_right"
    property string bulletUpLeftId: star.entityId +  "_bullet_up_left"


    /*!
      \qmlproperty int Star::countTouches
      \brief This property holds the number of touches by the user and by a flying energy.
     */
    property int countTouches: 0

    /*!
      \qmlsignal void Star::touchedByBullet( string bulletEntityId )
      \brief It is emitted when a star is being touched by a flying energy
      \a bulletEntityId - entity Id of the flying energy
     */
    signal touchedByBullet( string bulletEntityId )

    /*!
      \qmlsignal void Star::starIsExploding( int scores )
      \brief It is emitted when a star is exploding.
      \a scores - how many game scores the user gets for the star.
     */
    signal starIsExploding( int scores )

    /*!
      \qmlproperty int Star::probabilityToGenerateEnergy
      \brief This property holds the probability to generate a point of energy for the user.
      This value is 10% by default.
     */
    property int probabilityToGenerateEnergy: 10
    property int probabilityToGenerateEnergyGiant: 30

    /*!
      \qmlsignal void Star::generateEnergy( int index )
      \brief It is emitted when a star generates an energy point for the user.
     */
    signal generateEnergy( int index )

    /*!
      \qmlproperty int Star::probabilityToGenerateEnergy
      \brief This property holds how many scores the user gets when a star is exploding.
      This value is 10 by default.
     */
    property int scoresSimple: 10
    property int scoresGiant: 30

    /*!
      \qmlproperty int Star::probabilityToGenerateGiantStar
      \brief This property holds the probability to generate a giant star.
      This value is 10% by default.
     */
    property int probabilityToGenerateGiantStar: 5

    state: ""
    states: [
        State {
            name: "state0"
        },
        State {
            name: "state1"
        },
        State {
            name: "state2"
        },
        State {
            name: "simpleExplosion"
            PropertyChanges { target: star; clickingAllowed: false }
        },
        State {
            name: "giant"
        },
        State {
            name: "giantExplosion"
            PropertyChanges { target: star; clickingAllowed: false }
        }
    ]

    function setNextState() {
        if( star.state == "" ) {
            star.state = "state0"
        } else if( star.state == "state0" ) {
            star.state = "state1"
        } else if( star.state == "state1" ) {
            star.state = "state2"
        } else if( star.state == "state2" ) {
            var toGenerateGiant = utils.generateRandomValueBetween(1,100)
            if( toGenerateGiant < probabilityToGenerateGiantStar) {
                star.state = "giant"
            } else {
                star.state = "simpleExplosion"
            }
        } else if( star.state == "giant" ) {
            star.state = "giantExplosion"
        }
    }

    onStateChanged: {
        console.log(">>>>>>>>>>>>>> star:["+entityId+"] state:["+state+"]")

        spriteLongTime.running = false

        if( star.state == "state0" )
        {
            createViewFlash()

            spriteLongTime.x = starCollider.x
            spriteLongTime.y = starCollider.y
            spriteLongTime.width = star.radius*2
            spriteLongTime.height = star.radius*2
            spriteLongTime.source = "../../assets/img/state0.png"
            spriteLongTime.frameHeight = 128
            spriteLongTime.frameWidth = 128
            spriteLongTime.frameCount = 32
            spriteLongTime.frameDuration = 100
            spriteLongTime.restart()
            spriteLongTime.visible = true
        }
        else if( star.state == "state1" )
        {
            createViewFlash()

            spriteLongTime.x = starCollider.x
            spriteLongTime.y = starCollider.y
            spriteLongTime.width = star.radius*2
            spriteLongTime.height = star.radius*2
            spriteLongTime.source = "../../assets/img/state1.png"
            spriteLongTime.frameHeight = 128
            spriteLongTime.frameWidth = 128
            spriteLongTime.frameCount = 32
            spriteLongTime.frameDuration = 100
            spriteLongTime.restart()
            spriteLongTime.visible = true

        }
        else if( star.state == "state2" )
        {
            createViewFlash()

            spriteLongTime.x = starCollider.x
            spriteLongTime.y = starCollider.y
            spriteLongTime.width = star.radius*2
            spriteLongTime.height = star.radius*2
            spriteLongTime.source = "../../assets/img/state2.png"
            spriteLongTime.frameHeight = 128
            spriteLongTime.frameWidth = 128
            spriteLongTime.frameCount = 32
            spriteLongTime.frameDuration = 100
            spriteLongTime.restart()
            spriteLongTime.visible = true

        }
        else if( star.state == "simpleExplosion" )
        {
            createViewSimpleExplosion()
            explodeStar()
            star.starIsExploding( scoresSimple )
            var randomValue = utils.generateRandomValueBetween(1,100)
            if( randomValue <= probabilityToGenerateEnergy ) {
                star.generateEnergy( starIndex )
            }
        }
        else if( star.state == "giant" )
        {
            createViewFlash()
            spriteLongTime.x = starCollider.x - 0.75*star.radius
            spriteLongTime.y = starCollider.y - 0.75*star.radius
            spriteLongTime.width = star.radius*3.5
            spriteLongTime.height = star.radius*3.5
            spriteLongTime.source = "../../assets/img/red_star.png"
            spriteLongTime.frameHeight = 256
            spriteLongTime.frameWidth = 256
            spriteLongTime.frameCount = 16
            spriteLongTime.frameDuration = 80
            spriteLongTime.restart()
            spriteLongTime.visible = true
        }
        else if( star.state == "giantExplosion" )
        {
            createViewSimpleExplosion()
            explodeStar()
            star.starIsExploding( scoresGiant )
            var randomValue = utils.generateRandomValueBetween(1,100)
            if( randomValue <= probabilityToGenerateEnergyGiant ) {
                star.generateEnergy( starIndex )
            }
        }
    }

    CircleCollider {
        id: starCollider
        anchors.centerIn: parent

        density: 0
        friction: 0
        restitution: 1
        bodyType: Body.Dynamic
        sensor: true

        fixture.onBeginContact: {
            var body = other.getBody();
            var collidedEntity = body.target;
            var collidedEntityId = collidedEntity.entityId
            var collidedEntityType = collidedEntity.entityType;
            if( (collidedEntityType == "bulletType" )
                    &&(collidedEntityId != bulletDownId)
                    &&(collidedEntityId != bulletUpId)
                    &&(collidedEntityId != bulletLeftId)
                    &&(collidedEntityId != bulletRightId)
                    &&(collidedEntityId != bulletDownRightId)
                    &&(collidedEntityId != bulletDownLeftId)
                    &&(collidedEntityId != bulletUpRightId)
                    &&(collidedEntityId != bulletUpLeftId)
                    &&(star.state != "simpleExplosion")
                    &&(star.state != "giantExplosion")
                ) {
                setNextState()
                star.touchedByBullet( collidedEntityId )
            }
        }
    }

    property variant visibleSprite: null

    function createViewFlash() {
        spriteShortTime.x = starCollider.x - star.radius*0.8
        spriteShortTime.y = starCollider.y - star.radius
        spriteShortTime.width = star.radius*4
        spriteShortTime.height = star.radius*4
        spriteShortTime.source = "../../assets/img/between.png"
        spriteShortTime.frameHeight = 128
        spriteShortTime.frameWidth = 128
        spriteShortTime.frameCount = 32
        spriteShortTime.frameDuration = 10
        spriteShortTime.restart()
        spriteShortTime.visible = true
    }

    function createViewSimpleExplosion() {
        var x = starCollider.x - star.radius
        var y = starCollider.y - star.radius
        var w = star.radius*4
        var h = star.radius*4
        if( star.state == "giantExplosion" ) {
            x = starCollider.x - 2*star.radius
            y = starCollider.y - 2*star.radius
            w = star.radius*6
            h = star.radius*6
        }
        spriteShortTime.x = x
        spriteShortTime.y = y
        spriteShortTime.width = w
        spriteShortTime.height = h
        spriteShortTime.source = "../../assets/img/end.png"
        spriteShortTime.frameHeight = 128
        spriteShortTime.frameWidth = 128
        spriteShortTime.frameCount = 32
        spriteShortTime.frameDuration = 70
        spriteShortTime.restart()
        spriteShortTime.visible = true
    }


    AnimatedSpriteVPlay {
        id: spriteShortTime
        z: 3
        x: starCollider.x
        y: starCollider.y
        width: star.radius*2
        height: width
        loops: 1
        onRunningChanged: {
            if (!running) {
                spriteShortTime.visible = false
            }
        }
    }
    AnimatedSpriteVPlay {
        id: spriteLongTime
        x: starCollider.x
        y: starCollider.y
        width: star.radius*2
        height: width
        loops: AnimatedSprite.Infinite
        running: true
        visible: true
        onRunningChanged: {
            if (!running) {
                spriteLongTime.visible = false
            }
        }
    }


    selectionMouseArea.anchors.fill: spriteLongTime
    clickingAllowed: gameScene.usersEnergy > 0
    draggingAllowed: false
    onEntityClicked: {
        playSound("../../assets/sounds/intermediate.wav")
        setNextState()
    }

    function explodeStar() {
        var bulletRadius = 6;
        entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("./Bullet.qml"),{
                                                                  entityId: bulletLeftId,
                                                                  radius: bulletRadius,
                                                                  x: star.x + star.radius - bulletRadius,
                                                                  y: star.y + star.radius - bulletRadius,
                                                                  impulseX: -1,
                                                                  impulseY: 0
                                                              })
        var bulletLeftObject = entityManager.getEntityById( bulletLeftId )
        bulletLeftObject.shoot()


        entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("./Bullet.qml"),{
                                                                  entityId: bulletRightId,
                                                                  radius: bulletRadius,
                                                                  x: star.x + star.radius - bulletRadius,
                                                                  y: star.y + star.radius - bulletRadius,
                                                                  impulseX: 1,
                                                                  impulseY: 0
                                                              })
        var bulletRightObject = entityManager.getEntityById( bulletRightId )
        bulletRightObject.shoot()

        entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("./Bullet.qml"),{
                                                                  entityId: bulletUpId,
                                                                  radius: bulletRadius,
                                                                  x: star.x + star.radius - bulletRadius,
                                                                  y: star.y + star.radius - bulletRadius,
                                                                  impulseX: 0,
                                                                  impulseY: -1
                                                              })
        var bulletUpObject = entityManager.getEntityById( bulletUpId )
        bulletUpObject.shoot()

        var bulletDown = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("./Bullet.qml"),{
                                                                  entityId: bulletDownId,
                                                                  radius: bulletRadius,
                                                                  x: star.x + star.radius - bulletRadius,
                                                                  y: star.y + star.radius - bulletRadius,
                                                                  impulseX: 0,
                                                                  impulseY: 1
                                                              })
        var bulletDownObject = entityManager.getEntityById( bulletDownId )
        bulletDownObject.shoot()

        if( star.state == "giantExplosion" ) {
            var bulletDownRight = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("./Bullet.qml"),{
                                                                      entityId: bulletDownRightId,
                                                                      radius: bulletRadius,
                                                                      x: star.x + star.radius - bulletRadius,
                                                                      y: star.y + star.radius - bulletRadius,
                                                                      impulseX: 1,
                                                                      impulseY: 1
                                                                  })
            var bulletDownRightObject = entityManager.getEntityById( bulletDownRightId )
            bulletDownRightObject.shoot()

            var bulletDownLeft = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("./Bullet.qml"),{
                                                                      entityId: bulletDownLeftId,
                                                                      radius: bulletRadius,
                                                                      x: star.x + star.radius - bulletRadius,
                                                                      y: star.y + star.radius - bulletRadius,
                                                                      impulseX: -1,
                                                                      impulseY: 1
                                                                  })
            var bulletDownLeftObject = entityManager.getEntityById( bulletDownLeftId )
            bulletDownLeftObject.shoot()

            var bulletUpRight = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("./Bullet.qml"),{
                                                                      entityId: bulletUpRightId,
                                                                      radius: bulletRadius,
                                                                      x: star.x + star.radius - bulletRadius,
                                                                      y: star.y + star.radius - bulletRadius,
                                                                      impulseX: 1,
                                                                      impulseY: -1
                                                                  })
            var bulletUpRightObject = entityManager.getEntityById( bulletUpRightId )
            bulletUpRightObject.shoot()

            var bulletUpLeft = entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("./Bullet.qml"),{
                                                                      entityId: bulletUpLeftId,
                                                                      radius: bulletRadius,
                                                                      x: star.x + star.radius - bulletRadius,
                                                                      y: star.y + star.radius - bulletRadius,
                                                                      impulseX: -1,
                                                                      impulseY: -1
                                                                  })
            var bulletUpLeftObject = entityManager.getEntityById( bulletUpLeftId )
            bulletUpLeftObject.shoot()

            playSound("../../assets/sounds/explosion.wav")
        } else {
            playSound("../../assets/sounds/simpleExplosion.wav")
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
      \qmlmethod void Star::playSound( url file )
      It plays sounds
     */
    function playSound( file ) {
        var snd = componentSounds.createObject(star, {"source": file});
        if (snd == null) {
            console.log("Error creating sound");
        } else {
            snd.play()
        }
    }


}

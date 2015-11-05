import VPlay 2.0
import QtQuick 2.4

EntityBaseDraggable {
    id: star

    poolingEnabled: true
    entityType: "starType"

    property alias radius: starCollider.radius

    property int starIndex: 0

    property string bulletUpId: star.entityId +  "_bullet_up"
    property string bulletDownId: star.entityId +  "_bullet_down"
    property string bulletRightId: star.entityId +  "_bullet_right"
    property string bulletLeftId: star.entityId +  "_bullet_left"

    signal touchedByBullet( string bulletEntityId )
    property int countTouches: 0

    signal starIsExploding( int scores )

    property int probabilityToGenerateEnergy: 10
    signal generateEnergy( int index )

    property int scores: 10

    states: [
        State {
            when: countTouches == 0
            name: "state0"
        },
        State {
            when: countTouches == 1
            name: "state1"
        },
        State {
            when: countTouches == 2
            name: "state2"
        },
        State {
            when: countTouches >= 3
            name: "explode"
            PropertyChanges { target: padding; visible: false }
            PropertyChanges { target: star; clickingAllowed: false }
        }
    ]

    onStateChanged: {
        //console.log(">>>>>>>>>>>>>> star:["+entityId+"] state:["+state+"]")
        if( star.state == "explode" ) {
            paddingBetween.visible = false
            paddingEnd.visible = true
            paddingEnd.restart()
            padding.visible = false
            explodeStar()
            star.starIsExploding( scores )
            var randomValue = utils.generateRandomValueBetween(1,100)
            if( randomValue <= probabilityToGenerateEnergy ) {
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
                    &&(padding.visible == true)
                ) {
                paddingBetween.restart()
                paddingBetween.visible = true
                countTouches += 1
                //console.log("*** Object "+star.entityId+" is being touched by bullet:"+collidedEntityId)
                star.touchedByBullet( collidedEntityId )
            }
        }
    }


    AnimatedSpriteVPlay {
        id: padding
        x: starCollider.x
        y: starCollider.y
        width: star.radius*2
        height: width
        running: state != "explode"
        visible: state != "explode"
        loops: AnimatedSprite.Infinite
        source: countTouches == 0 ? "../../assets/img/state0.png" : (countTouches == 1 ? "../../assets/img/state1.png" : "../../assets/img/state2.png")
        frameHeight: 128
        frameWidth: 128
        frameCount: 32
        frameDuration: 100
    }
    AnimatedSpriteVPlay {
        id: paddingBetween
        visible: false
        x: starCollider.x - star.radius*0.8
        y: starCollider.y - star.radius*1
        width: star.radius*4
        height: width
        running: false
        loops: 1
        source: "../../assets/img/between.png"
        frameHeight: 128
        frameWidth: 128
        frameCount: 32
        frameDuration: 10
        onRunningChanged: {
            if (!running) {
                paddingBetween.visible = false
            }
        }
    }
    AnimatedSpriteVPlay {
        id: paddingEnd
        visible: false
        x: starCollider.x - star.radius*1
        y: starCollider.y - star.radius*1
        width: star.radius*4
        height: width
        running: false
        loops: 1
        source: "../../assets/img/end.png"
        frameHeight: 128
        frameWidth: 128
        frameCount: 32
        frameDuration: 70
        onCurrentFrameChanged: {
            if( currentFrame == (frameCount-1) ) {
                paddingEnd.visible = false
            }
        }
        /*onRunningChanged: {
            if (!running) {
                paddingEnd.visible = false
            }
        }*/
    }


    selectionMouseArea.anchors.fill: padding
    clickingAllowed: gameScene.usersEnergy > 0
    draggingAllowed: false
    onEntityClicked: {
        paddingBetween.restart()
        paddingBetween.visible = true
        countTouches += 1
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
    }


    onMovedToPool: {
        star.state == "pool"
        countTouches = 0

        //console.log("TP#TP#TP#TP#TP#TP#TP#TP#TP#TP#TP#TP#:"+entityId)
        padding.running = false

        paddingBetween.running = false
        paddingBetween.visible = false

        paddingEnd.running = false
        paddingEnd.visible = false
    }
    onUsedFromPool: {
        //console.log("FP#FP#FP#FP#FP#FP#FP#FP#FP#FP#FP#FP#:"+entityId)
        padding.restart()
        padding.visible = true
    }



    onEntityCreated: {
        padding.restart()
        padding.visible = true
    }
}

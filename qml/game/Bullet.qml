import VPlay 2.0
import QtQuick 2.4

EntityBase {
    id: bullet
    z: 5

    poolingEnabled: true

    entityType: "bulletType"

    property int impulseX: 0
    property int impulseY: 0

    property alias radius: bulletCollider.radius
    property int scaleImpulse: 100

    CircleCollider {
        id: bulletCollider
        anchors.centerIn: parent

        density: 0
        friction: 0
        restitution: 1
        bodyType: Body.Dynamic
        sensor: true

        fixture.onBeginContact: {
            var body = other.getBody();
            var collidedEntity = body.target;
            var collidedEntityType = collidedEntity.entityType;
        }
    }


    Image {
        id: padding
        x: bulletCollider.x
        y: bulletCollider.y
        width: bullet.radius*2
        height: width
        source: "../../assets/img/bullet.png"
        /*rotation: (impulseX > 0)&&(impulseY == 0) ? -90 :
                  (impulseX < 0)&&(impulseY == 0) ? 90 :
                  (impulseX == 0)&&(impulseY > 0) ? 0 :
                  (impulseX == 0)&&(impulseY < 0) ? 180 : 0*/

    }


    function shoot() {
        var localForwardVector = bulletCollider.body.toWorldVector(Qt.point(impulseX*scaleImpulse,impulseY*scaleImpulse));
        bulletCollider.body.applyLinearImpulse( localForwardVector, bulletCollider.body.getWorldCenter() );
    }


    onMovedToPool: {
        bulletCollider.body.linearVelocity = Qt.point(0,0)
    }
}

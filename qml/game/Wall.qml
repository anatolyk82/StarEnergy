import VPlay 2.0
import QtQuick 2.4


EntityBase {
    id: wall

    entityType: "wallType"
    signal touchedByBullet( string bulletEntityId )

    Rectangle {
        id: boxImage
        width: parent.width
        height: parent.height
        color: "transparent"
    }

    BoxCollider {
        anchors.fill: boxImage
        bodyType: Body.Static
        fixture.onBeginContact: {
            var body = other.getBody();
            var collidedEntity = body.target;
            var collidedEntityId = collidedEntity.entityId
            var collidedEntityType = collidedEntity.entityType;
            if( collidedEntityType == "bulletType") {
                wall.touchedByBullet( collidedEntityId )
            }
        }
    }
}

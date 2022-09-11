import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qt5-qml-promises"

Page {
    title: qsTr("Bicycle Demo")

    property url icon

    Rectangle {
        id: body

        anchors.centerIn: parent
        width: 300
        height: 300
        border.color: "#808080"

        Item {
            id: bicycle
            x: 50
            y: 250
            width: 0
            height: 0
            property color color: "blue"

            Button {
                id: bicycleButton
                anchors.centerIn: parent
                background: Item { }
                icon.source: "esri-calcite-ui-icons/biking-32.svg"
                icon.width: 64
                icon.height: 64
                icon.color: parent.color
            }
        }

        Frame {
            id: messageFrame
            anchors.centerIn: parent
            opacity: 0.0
            background: Rectangle {
                color: "blue"
                radius: 5
            }
            Text {
                id: message
                color: "black"
            }
        }
    }

    footer: Frame {
        background: Rectangle {
            color: "#f0f0f0"
        }

        RowLayout {
            width: parent.width

            Button {
                text: qsTr("Animate")
                enabled: !bicycleAnimation.running
                onClicked: bicycleAnimation.runAsync()
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Abort")
                enabled: bicycleAnimation.running
                onClicked: bicycleAnimation.abort()
            }
        }
    }

    QMLPromises {
        id: bicycleAnimation

        function runAsync() {
            asyncToGenerator( function* () {
                bicycle.x = 50;
                bicycle.y = 250;
                bicycle.rotation = 0;
                message.text = qsTr("On your marks!");
                message.color = "black";
                messageFrame.background.color = "red";
                yield numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
                message.text = qsTr("Get set!");
                message.color = "black";
                messageFrame.background.color = "yellow";
                yield numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
                message.text = qsTr("Go!");
                message.color = "white";
                messageFrame.background.color = "green";
                yield numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "x", from: 50, to: 250, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "rotation", from: 0, to: -90, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "y", from: 250, to: 50, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "rotation", from: -90, to: -180, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "x", from: 250, to: 50, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "rotation", from: 180, to: 90, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "y", from: 50, to: 250, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "rotation", from: 90, to: 0, duration: 1000 } );
            } )();
        }
    }
}

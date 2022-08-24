import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qt5-qml-promises"

Window {
    id: app

    width: 400
    height: 500
    visible: true
    title: qsTr("Bicycle Animation")

    Page {
        anchors.fill: parent

        Item {
            id: bicycle
            x: 100
            y: 300
            width: 0
            height: 0
            property color color: "blue"

            Button {
                id: bicycleButton
                anchors.centerIn: parent
                background: Item { }
                icon.source: "bicycle-32.svg"
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

        footer: Frame {
            background: Rectangle {
                color: "#e0e0e0"
            }

            RowLayout {
                width: parent.width

                Button {
                    id: goButton
                    text: qsTr("Go")
                    onClicked: actionGo()
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    text: qsTr("User Abort")
                    onClicked: qmlPromises.userAbort()
                }
            }
        }
    }

    QMLPromises {
        id: qmlPromises
    }

    function actionGo() {
        bicycle.x = 100;
        bicycle.y = 300;
        bicycle.rotation = 0;

        // Cancel previously running Promises.

        qmlPromises.userAbort();

        // Bicycle animation.

        qmlPromises.asyncToGenerator( function* () {
            message.text = qsTr("On your marks!");
            message.color = "black";
            messageFrame.background.color = "red";
            messageFrame.opacity = 1.0;
            yield qmlPromises.numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
            message.text = qsTr("Get set!");
            message.color = "black";
            messageFrame.background.color = "yellow";
            messageFrame.opacity = 1.0;
            yield qmlPromises.numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
            message.text = qsTr("Go!");
            message.color = "white";
            messageFrame.background.color = "green";
            messageFrame.opacity = 1.0;
            yield qmlPromises.numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "x", from: 100, to: 300, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "rotation", from: 0, to: -90, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "y", from: 300, to: 100, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "rotation", from: -90, to: -180, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "x", from: 300, to: 100, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "rotation", from: 180, to: 90, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "y", from: 100, to: 300, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "rotation", from: 90, to: 0, duration: 1000 } );
        } )();
    }

}

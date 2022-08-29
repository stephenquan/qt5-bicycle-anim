import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.12
import ArcGIS.AppFramework 1.0

import "qt5-qml-promises"
import "appstudio-promises"

App {
    id: app
    width: 400
    height: 500 - 28

    Page {
        anchors.fill: parent

        Rectangle {
            id: body
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
                    icon.source: "https://raw.githubusercontent.com/Esri/calcite-ui-icons/master/icons/biking-32.svg"
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
            RowLayout {
                width: parent.width

                Button {
                    id: button
                    text: qsTr("Go")

                    onClicked: {
                        bicycleAnimation.run();
                        //screenGrab.run();
                    }
                }

                Button {
                    text: qsTr("Requests")

                    onClicked: {
                        //networkTest.run();
                        piCalculator.abort();
                        piCalculator.runAsync();
                    }

                }

                Text {
                    text: piCalculator.pi
                }
            }

        }
    }

    QMLPromises {
        id: bicycleAnimation
        errorHandler: customErrorHandler

        function run() {
            abort();
            asyncToGenerator( function* () {
                bicycle.x = 100;
                bicycle.y = 300;
                bicycle.rotation = 0;
                message.text = qsTr("On your marks!");
                message.color = "black";
                messageFrame.background.color = "red";
                messageFrame.opacity = 1.0;
                yield numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
                message.text = qsTr("Get set!");
                message.color = "black";
                messageFrame.background.color = "yellow";
                messageFrame.opacity = 1.0;
                yield numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
                message.text = qsTr("Go!");
                message.color = "white";
                messageFrame.background.color = "green";
                messageFrame.opacity = 1.0;
                yield numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "x", from: 100, to: 300, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "rotation", from: 0, to: -90, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "y", from: 300, to: 100, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "rotation", from: -90, to: -180, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "x", from: 300, to: 100, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "rotation", from: 180, to: 90, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "y", from: 100, to: 300, duration: 1000 } );
                yield numberAnimation( { target: bicycle, property: "rotation", from: 90, to: 0, duration: 1000 } );
            } )();

        }
    }

    QMLPromises {
        id: screenGrab
        errorHandler: customErrorHandler

        function run() {
            abort();
            asyncToGenerator( function* () {
                for (let i = 0; i < 200; i++) {
                    let filePath = "C:/temp/img/grab" + String(i).padStart(4, '0') + ".png";
                    yield sleep(20);
                    yield grabToImage(body, filePath);
                }
            } )();
        }
    }

    QMLPromises {
        id: networkTest
        errorHandler: customErrorHandler

        function run() {
            asyncToGenerator( function* () {
                let nr = yield appStudioPromises.networkRequest(
                        { "method": "POST",
                          "url": "https://appstudio.arcgis.com/5.4.999/api/debug",
                          "body": { "f": "pjson" }
                        } );
                console.log("DONE");
                console.log(nr.responseText);
            } )();
        }
    }

    QMLPromises {
        id: piCalculator

        property double pi: 4.0

        function run() {
            pi = 4.0;
            for (let den = 3; den < 1000000; ) {
                pi -= 4.0 / den;
                den += 2;
                pi += 4.0 / den;
                den += 2;
            }
        }

        function runAsync() {
            asyncToGenerator( function* () {
                pi = 4.0;
                for (let den = 3; den < 1000000; ) {
                    pi -= 4.0 / den;
                    den += 2;
                    pi += 4.0 / den;
                    den += 2;
                    yield pass();
                }
            } )();
        }
    }

    AppStudioPromises {
        id: appStudioPromises
    }

    function customErrorHandler(err) {
        let fileName = err.fileName ?? "";
        let lineNumber = err.lineNumber ?? 1;
        let columnNumber = err.columnNumber ?? 1;
        let message = err.message ?? "";
        console.error("* " + fileName + ":" + lineNumber + ":" + columnNumber + ": " + message);
        throw err;
    }

}

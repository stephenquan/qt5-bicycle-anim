import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qt5-qml-promises"

Page {
    title: qsTr("Sleep Demo")

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            Layout.fillWidth: true

            text: "Demonstrates how to use sleep() delay in a Promise chain."
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: _console

            ScrollBar.vertical: ScrollBar {
                width: 20
            }

            delegate: Frame {
                width: ListView.view.width - 20

                background: Rectangle {
                    color: (index & 1) ? "#f0f0f0" : "#e0e0e0"
                }

                Text {
                    width: parent.width

                    text: message
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
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
                text: qsTr("Run")
                onClicked: {
                    enabled = false;
                    Qt.callLater( function () {
                        sleepDemo.run();
                        enabled = true;
                    } );
                }
            }

            Button {
                text: qsTr("RunAsync")
                enabled: !sleepDemo.running
                onClicked: sleepDemo.runAsync()
            }

            Button {
                text: qsTr("Clear")
                onClicked: _console.clear()
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Abort")
                enabled: sleepDemo.running
                onClicked: sleepDemo.abort()
            }
        }
    }

    ListModel {
        id: _console

        function log(...params) {
            let message = Qt.formatDateTime(new Date(), "[hh:mm:ss] ") + params.join(" ");
            console.log(message);
            append( { message } );
        }
    }

    QMLPromises {
        id: sleepDemo

        function run() {
            _console.log('one');
            _console.log('two');
            _console.log('three');
        }

        function runAsync() {
            asyncToGenerator( function* () {
                _console.log('One');
                yield sleep(1000);
                _console.log('Two');
                yield sleep(1000);
                _console.log('Three');
            } )();
        }
    }
}

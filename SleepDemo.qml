import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qt5-qml-promises"
import "controls"

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

        ConsoleListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: _console
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

    ConsoleListModel {
        id: _console

        onCountChanged: if (count - 1 > listView.currentIndex) listView.currentIndex = count - 1
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

        errorHandler: function (err) {
            _console.error(err.message);
            defaultErrorHandler(err);
        }
    }
}

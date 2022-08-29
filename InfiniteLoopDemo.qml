import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qt5-qml-promises"

Page {
    title: qsTr("Infinite Loop Demo")

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            Layout.fillWidth: true

            text: qsTr("Demonstrates a breakable infinite loop.")
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true

            model: _console
            clip: true

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
                text: qsTr("Start")
                enabled: !infiniteDemo.running
                onClicked: infiniteDemo.runAsync()
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
                enabled: infiniteDemo.running
                onClicked: infiniteDemo.abort()
            }
        }
    }

    ListModel {
        id: _console

        function log(...params) {
            let message = Qt.formatDateTime(new Date(), "[hh:mm:ss.zzz] ") + params.join(" ");
            console.log(message);
            append( { message } );
            listView.currentIndex = count - 1;
        }
    }

    QMLPromises {
        id: infiniteDemo

        function runAsync() {
            asyncToGenerator( function* () {
                while (true) {
                    _console.log("Hello");
                    yield sleep(1000);
                }
            } )();
        }
    }
}

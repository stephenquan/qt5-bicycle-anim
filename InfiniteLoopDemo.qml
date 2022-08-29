import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qt5-qml-promises"
import "controls"

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

    ConsoleListModel {
        id: _console

        onCountChanged: if (count - 1 > listView.currentIndex) listView.currentIndex = count - 1
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

        errorHandler: function (err) {
            _console.error(err.message);
            defaultErrorHandler(err);
        }
    }
}

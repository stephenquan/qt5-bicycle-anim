import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qt5-qml-promises"

Page {
    title: qsTr("Pi Demo")

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            Layout.fillWidth: true

            text: "This demonstrates a synchronous and an asynchronous algorithms for "
            + "approximating the value of PI. The synchronous implementation blocks the "
            + "UI and cannot be aborted until it is done. The asynchronous algorithm "
            + "doesn't block the UI, shows intermediate progress and is abortable."
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                anchors.centerIn: parent
                text: piCalculator.pi
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
                        piCalculator.run();
                        enabled = true;
                    } );
                }
            }

            Button {
                text: qsTr("RunAsync")
                enabled: !piCalculator.running
                onClicked: piCalculator.runAsync()
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Abort")
                enabled: piCalculator.running
                onClicked: piCalculator.abort()
            }
        }
    }

    QMLPromises {
        id: piCalculator

        property double pi: 4.0

        function run() {
            pi = 4.0;
            for (let den = 3; den <= 100000; ) {
                pi -= 4.0 / den;
                den += 2;
                pi += 4.0 / den;
                den += 2;
            }
        }

        function runAsync() {
            asyncToGenerator( function* () {
                let ts = Date.now();
                pi = 4.0;
                for (let den = 3; ; ) {
                    pi -= 4.0 / den;
                    den += 2;
                    pi += 4.0 / den;
                    den += 2;
                    if (Date.now() > ts + 200) {
                        yield pass();
                        ts = Date.now();
                    }
                }
            } )();
        }
    }
}

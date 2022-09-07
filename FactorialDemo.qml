import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qt5-qml-promises"
import "controls"

Page {
    title: qsTr("Factorial Demo")

    property url icon

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            Layout.fillWidth: true

            text: qsTr("Demonstrates simple recursion with Promises.")
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        ConsoleView {
            id: _console
            Layout.fillWidth: true
            Layout.fillHeight: true
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
                enabled: !factorialDemo.running
                onClicked: factorialDemo.runAsync()
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
                enabled: factorialDemo.running
                onClicked: factorialDemo.abort()
            }
        }
    }

    QMLPromises {
        id: factorialDemo

        property var factorial: (() => {
          var _ref = _asyncToGenerator(function* (n) {
            if (n <= 1) return 1;
            return n * (yield factorial(n - 1));
          });

          return function factorial(_n) {
            return _ref.apply(this, arguments);
          };
        })();

        function runAsync() {
            asyncToGenerator( function* () {
                for (let i = 1; i <= 10; i++) {
                  _console.log("factorial(%1) = %2".arg(i).arg(yield factorial(i)));
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

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qt5-qml-promises"

Page {
    title: qsTr("Maze Demo")

    property url icon

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Text {
            Layout.fillWidth: true

            text: qsTr("Solves a maze using recursion and Promises.")
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

        TextMetrics {
            id: tm
            text: '#'
            font.pointSize: 14
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            GridView {
                anchors.centerIn: parent
                model: mazeDemo.listModel
                cellWidth: 32
                cellHeight: 32
                width: cellWidth * mazeDemo.columns
                height: cellHeight * mazeDemo.rows
                delegate: Item {
                    width: GridView.view.cellWidth
                    height: GridView.view.cellHeight
                    Button {
                        anchors.centerIn: parent
                        background: Item { }
                        icon.source: ({
                            "#": "images/grid-hexagon-32.svg",
                            "*": "images/circle-area-32.svg"
                        })[ch] || ""
                        icon.color: ({
                                         "#": "grey",
                                         "*": "green"
                                     })[ch] || "black"
                        icon.width: 32
                        icon.height: 32
                    }
                }
            }
        }

        Text {
            id: message
            Layout.fillWidth: true
        }
    }

    footer: Frame {
        background: Rectangle {
            color: "#f0f0f0"
        }

        RowLayout {
            width: parent.width

            Button {
                text: qsTr("Solve")
                enabled: !mazeDemo.running
                onClicked: mazeDemo.runAsync()
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Abort")
                enabled: mazeDemo.running
                onClicked: mazeDemo.abort()
            }
        }
    }

    QMLPromises {
        id: mazeDemo
        property ListModel listModel: ListModel { }
        property var maze: [
            "# #######",
            "#   #   #",
            "# ### # #",
            "# #   # #",
            "# # # ###",
            "#   # # #",
            "# ### # #",
            "#   #   #",
            "####### #"
        ]
        property int rows: maze.length
        property int columns: maze[0].length
        property string wall: '#'
        property string free: ' '
        property string someDude: '*'
        property var startingPoint: [1, 0]
        property var endingPoint: [7, 8]

        function get(x, y) {
            if (x < 0 || x >= columns || y < 0 || y >= rows) return wall;
            return listModel.get(y * columns + x).ch;
        }

        function set(x, y, ch) {
            if (x < 0 || x >= columns || y < 0 || y >= rows) return;
            listModel.set(y * columns + x, { ch } );
        }

        property var solve: (() => {
            var _ref = _asyncToGenerator(function* (x, y) {
                // Make the move (if it's wrong, we will backtrack later).
                set(x, y, someDude);
                yield sleep(50);
                // Try to find the next move.
                if (x === endingPoint[0] && y === endingPoint[1]) return true;
                if (get(x - 1, y) === free && (yield solve(x - 1, y))) return true;
                if (get(x + 1, y) === free && (yield solve(x + 1, y))) return true;
                if (get(x, y - 1) === free && (yield solve(x, y - 1))) return true;
                if (get(x, y + 1) === free && (yield solve(x, y + 1))) return true;
                // No next move was found, so we backtrack.
                set(x, y, free);
                yield sleep(50);
                return false;
            });
            return function solve(_x, _y) {
                return _ref.apply(this, arguments);
            };
        })();

        function runAsync() {
            gc();
            asyncToGenerator( function* () {
                message.text = qsTr("Solving");
                init();
                if (yield solve(startingPoint[0], startingPoint[1])) {
                    message.text = qsTr("Solved!");
                } else {
                    message.text = qsTr("Cannot solve. :-(");
                }
            } )();
        }

        function init() {
            listModel.clear();
            for (let line of maze) {
                for (let ch of line.split('')) {
                    listModel.append( { ch } );
                }
            }
        }

        Component.onCompleted: init()
    }
}

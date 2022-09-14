import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.12

import "qt5-qml-promises"
import "controls"

Page {
    id: mainPage

    property var info: ({ })

    header: Frame {
        background: Rectangle {
            color: "#f0f0f0"
        }

        RowLayout {
            width: parent.width

            IconButton {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                source: "esri-calcite-ui-icons/chevron-left-32.svg"
                visible: stackView.depth > 1
                onClicked: stackView.pop()
            }

            Icon {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                source: (stackView.currentPage ? stackView.currentPage.icon : null) || "esri-calcite-ui-icons/apps-32.svg"
            }

            Text {
                Layout.fillWidth: true
                text: (stackView.currentPage ? stackView.currentPage.title : null) || mainPage.title
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }

            IconButton {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                source: "esri-calcite-ui-icons/information-32.svg"
                visible: !stackView.currentPage.isAboutPage
                onClicked: stackView.push( "AboutPage.qml", { info } );
            }
        }
    }

    Text {
        anchors.fill: parent
        text: JSON.stringify(info, undefined, 2)
    }

    StackView {
        id: stackView

        anchors.fill: parent

        property Page currentPage: currentItem

        initialItem: menuPageComponent
    }

    Component {
        id: menuPageComponent

        Page {
            ListView {
                anchors.fill: parent

                model: [
                    { title: "Sleep Demo", file: "SleepDemo.qml", icon: "esri-calcite-ui-icons/clock-32.svg" },
                    { title: "Infinite Loop Demo", file: "InfiniteLoopDemo.qml", icon: "esri-calcite-ui-icons/recurrence-32.svg" },
                    { title: "Pi Demo", file: "PiDemo.qml", icon: "esri-calcite-ui-icons/calculator-32.svg" },
                    { title: "Factorial Demo", file: "FactorialDemo.qml", icon: "esri-calcite-ui-icons/calculator-32.svg" },
                    { title: "Bicycle Demo", file: "BicycleDemo.qml", icon: "esri-calcite-ui-icons/biking-32.svg" },
                    { title: "ArcGIS Search Demo", file: "ArcGISSearchDemo.qml", icon: "esri-calcite-ui-icons/file-magnifying-glass-32.svg" },
                    { title: "Maze Demo", file: "MazeDemo.qml", icon: "esri-calcite-ui-icons/puzzle-piece-32.svg" }
                ]

                delegate: Frame {
                    width: ListView.view.width - 20

                    background: Rectangle {
                        color: (index & 1) ? "#f0f0f0" : "#e0e0e0"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push( modelData.file, { icon: modelData.icon } )
                        }
                    }

                    RowLayout {
                        width: parent.width

                        Icon {
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            source: modelData.icon ?? "esri-calcite-ui-icons/apps-32.svg"
                        }

                        Text {
                            Layout.fillWidth: true
                            text: modelData.title
                        }

                        Icon {
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            source: "esri-calcite-ui-icons/chevron-right-32.svg"
                        }
                    }
                }
            }
        }
    }

    focus: true

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            if (stackView.depth > 1) {
                event.accepted = true;
                stackView.pop();
            }
        }
    }
}

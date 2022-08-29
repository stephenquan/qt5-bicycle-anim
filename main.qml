import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qt5-qml-promises"
import "controls"

Window {
    id: app

    width: 800
    height: 600
    visible: true
    title: qsTr("QML Promises Demo")

    Page {
        anchors.fill: parent

        header: Frame {
            background: Rectangle {
                color: "#f0f0f0"
            }

            RowLayout {
                width: parent.width

                IconButton {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    source: "images/chevron-left-32.svg"
                    visible: stackView.depth > 1
                    onClicked: stackView.pop()
                }

                Icon {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    source: "images/smile-32.svg"
                }

                Text {
                    Layout.fillWidth: true
                    text: (stackView.currentPage ? stackView.currentPage.title : null) || app.title
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
        }

        StackView {
            id: stackView

            anchors.fill: parent

            property Page currentPage: currentItem

            initialItem: mainPageComponent
        }
    }

    Component {
        id: mainPageComponent

        Page {
            ListView {
                anchors.fill: parent

                model: [ "SleepDemo", "PiDemo", "BicycleDemo", "ArcGISSearchDemo",
                "MazeDemo"
                ]

                delegate: Frame {
                    width: ListView.view.width - 20

                    background: Rectangle {
                        color: (index & 1) ? "#f0f0f0" : "#e0e0e0"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: stackView.push( modelData + ".qml" )
                        }
                    }

                    RowLayout {
                        width: parent.width

                        Text {
                            Layout.fillWidth: true
                            text: modelData
                        }

                        Icon {
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            source: "images/chevron-right-32.svg"
                        }
                    }
                }
            }
        }
    }
}

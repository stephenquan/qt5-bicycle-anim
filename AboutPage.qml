import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    title: qsTr("About")

    property url icon: "images/information-32.svg"
    property var info
    property bool isAboutPage: true

    ListView {
        anchors.fill: parent
        anchors.margins: 10
        model: Object.entries(info)
        delegate: Frame {
            width: ListView.view.width - 20

            background: Rectangle {
                color: (index & 1) ? "#f0f0f0" : "#e0e0e0"
                border.color: "#c0c0c0"
            }

            RowLayout {
                width: parent.width

                Text {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 100
                    text: displayKey(modelData[0])
                }

                Text {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 400
                    text: modelData[1]
                }
            }
        }
    }

    function displayKey(key) {
        let m = key.match(/^app(.*)/);
        if (m) return m[1];
        return key;
    }
}

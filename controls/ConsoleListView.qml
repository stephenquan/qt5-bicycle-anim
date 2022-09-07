import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12

ListView {
    clip: true

    ScrollBar.vertical: ScrollBar {
        width: 20
    }

    delegate: Frame {
        width: ListView.view.width - 20

        background: Rectangle {
            color: (index & 1) ? "#f0f0f0" : "#e0e0e0"
        }

        RowLayout {
            width: parent.width

            Text {
                Layout.fillWidth: true

                text: message
                color: messageColor
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }

            Text {
                text: timestamp
                color: "#808080"
            }
        }
    }
}

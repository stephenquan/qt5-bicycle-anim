import QtQuick 2.15
import QtQuick.Controls 2.12

Item {
    id: iconButton
    property alias source: button.icon.source
    property alias color: button.icon.color
    signal clicked()
    Button {
        id: button
        anchors.centerIn: parent
        background: Item { }
        icon.width: parent.width
        icon.height: parent.height
        onClicked: iconButton.clicked()
    }
}

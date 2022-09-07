import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.12
import ArcGIS.AppFramework 1.0

import "qt5-qml-promises"
import "controls"

App {
    id: app
    width: 800
    height: 600

    MainPage {
        anchors.fill: parent
        title: app.info.title
    }
}

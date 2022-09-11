import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "qt5-qml-sortlistmodel"
import "qt5-qml-promises"

Page {
    title: qsTr("ArcGIS Search Demo")

    property url icon
    property string portalUrl: "https://www.arcgis.com";
    property int total: 0

    header: Frame {
        background: Rectangle {
            color: "#e0e0e0"
        }

        RowLayout {
            width: parent.width

            Text {
                text: qsTr("%1/%2 items (%3 sorted)").arg(itemsListModel.count).arg(total).arg(itemsListModel.sortCount)
            }
        }
    }

    ListView {
        anchors.fill: parent

        model: itemsListModel
        clip: true

        ScrollBar.vertical: ScrollBar {
            width: 20
        }

        delegate: Frame {
            background: Rectangle {
                color: (index & 1) ? "#f0f0f0" : "#f8f8f8"
            }

            width: ListView.view.width - 20

            RowLayout {
                width: parent.width

                Item {
                    Layout.preferredWidth: 200 / 2
                    Layout.preferredHeight: 133 / 2

                    Image {
                        anchors.fill: parent
                        source: thumbnail
                                ? `${portalUrl}/sharing/rest/content/items/${itemId}/info/${thumbnail}`
                                : "https://static.arcgis.com/images/desktopapp.png"
                    }

                    Text {
                        text: (index + 1)
                        font.pointSize: 10
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: title
                        font.pointSize: 10
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }

                    Text {
                        Layout.fillWidth: true
                        text: itemType
                        font.pointSize: 10
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }

                    Text {
                        Layout.fillWidth: true
                        text: qsTr("%1 %2")
                        .arg(owner)
                        .arg(Qt.formatDateTime(new Date(modified), "d MMM yy"))
                        font.pointSize: 10
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                }
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
                text: qsTr("Search")
                font.pointSize: 12
                enabled: !search.running

                onClicked: search.runAsync();
            }

            Button {
                icon.source: "esri-calcite-ui-icons/clock-up-32.svg"
                icon.width: 24
                icon.height: 24
                enabled: itemsListModel.sortRole !== itemsListModel.orderByModified
                onClicked: {
                    itemsListModel.sortRole = itemsListModel.orderByModified;
                }
            }

            Button {
                icon.source: "esri-calcite-ui-icons/a-z-down-32.svg"
                icon.width: 24
                icon.height: 24
                enabled: itemsListModel.sortRole !== itemsListModel.orderByTitle
                onClicked: {
                    itemsListModel.sortRole = itemsListModel.orderByTitle;
                }
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Abort")
                enabled: search.running

                onClicked: search.abort();
            }
        }
    }

    QMLPromises {
        id: search

        function runAsync() {
            asyncToGenerator( function * () {
                itemsListModel.clear();
                total = 0;
                let start = 1;
                while (start >= 1) {
                    let search = yield fetch( {
                                                 "method": "POST",
                                                 "url": `${portalUrl}/sharing/rest/search`,
                                                 "body": {
                                                     "q": "type:web map",
                                                     "start": start,
                                                     "num": 100,
                                                     "f": "pjson"
                                                 }
                                             } );
                    console.log("start:", start, "results: ", search.response.results.length, "nextStart: ", search.response.nextStart, "total: ", search.response.total);
                    itemsListModel.appendItems(search.response.results);
                    if (search.response.nextStart === -1) { break; }
                    start = search.response.nextStart;
                    total = search.response.total;
                }
            } )();
        }
    }

    SortListModel {
        id: itemsListModel

        property var orderByTitle: ( [
                                        {
                                            "sortRole": "title",
                                            "sortOrder": Qt.AscendingOrder
                                        },
                                        {
                                            "sortRole": "modified",
                                            "sortOrder": Qt.DescendingOrder
                                        }
                                    ] )
        property var orderByModified: ( [
                                           {
                                               "sortRole": "modified",
                                               "sortOrder": Qt.DescendingOrder
                                           },
                                           {
                                               "sortRole": "title",
                                               "sortOrder": Qt.AscendingOrder
                                           }
                                       ] )
        sortRole: orderByModified

        function appendItem(item) {
            let itemId = item.id || "";
            let itemType = item.type || "";
            let title = item.title || "";
            let modified = item.modified || 0;
            let owner = item.owner || "";
            let thumbnail = item.thumbnail || "";
            append( { itemId, itemType, title, modified, owner, thumbnail } );
        }

        function appendItems(items) {
            for (let item of items) {
                appendItem(item);
            }
        }
    }
}

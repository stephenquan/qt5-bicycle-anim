import QtQuick 2.15

ListModel {
    id: _console

    function log(...params) {
        console.log(...params);
        let timestamp = Qt.formatDateTime(new Date(), "hh:mm:ss.zzz");
        let message = params.join(" ");
        let messageColor = "black";
        append( { timestamp, message, messageColor } );
    }

    function error(...params) {
        console.error(...params);
        let timestamp = Qt.formatDateTime(new Date(), "hh:mm:ss.zzz");
        let message = params.join(" ");
        let messageColor = "red";
        append( { timestamp, message, messageColor } );
    }
}

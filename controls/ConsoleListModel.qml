import QtQuick 2.15

ListModel {
    id: _console

    function log(...params) {
        let message = Qt.formatDateTime(new Date(), "[hh:mm:ss.zzz] ") + params.join(" ");
        console.log(message);
        append( { message, messageColor: "black" } );
    }

    function error(...params) {
        let message = Qt.formatDateTime(new Date(), "[hh:mm:ss.zzz] ") + params.join(" ");
        console.error(message);
        append( { message, messageColor: "red" } );
    }
}

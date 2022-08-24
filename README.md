# qt5-bicycle-anim
Qt5 application that animates a Bicycle SVG graphic using Promises.

![qt5-bicycle-anim.gif](qt5-bicycle-anim.gif)

The main animation uses generator function with yield syntax which
was transpiled from async function with await syntax:

```qml
import "qt5-qml-promises"

Button {
    text: qsTr("Go")
    onClicked: {
        qmlPromises.userAbort();
        qmlPromises.asyncToGenerator( function* () {
            message.text = qsTr("On your marks!");
            message.color = "black";
            messageFrame.background.color = "red";
            messageFrame.opacity = 1.0;
            yield qmlPromises.numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
            message.text = qsTr("Get set!");
            message.color = "black";
            messageFrame.background.color = "yellow";
            messageFrame.opacity = 1.0;
            yield qmlPromises.numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
            message.text = qsTr("Go!");
            message.color = "white";
            messageFrame.background.color = "green";
            messageFrame.opacity = 1.0;
            yield qmlPromises.numberAnimation( { target: messageFrame, property: "opacity", from: 1.0, to: 0.0, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "x", from: 100, to: 300, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "rotation", from: 0, to: -90, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "y", from: 300, to: 100, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "rotation", from: -90, to: -180, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "x", from: 300, to: 100, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "rotation", from: 180, to: 90, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "y", from: 100, to: 300, duration: 1000 } );
            yield qmlPromises.numberAnimation( { target: bicycle, property: "rotation", from: 90, to: 0, duration: 1000 } );
        } )();
    }
}

QMLPromises {
    id: qmlPromises
}
```

This application uses the following Qt5 QML submodule libraries:
 - https://github.com/stephenquan/qt5-qml-promises

To clone this repo, use:

    git clone https://github.com/stephenquan/qt5-bicycle-anim.git
    git submodule update

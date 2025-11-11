import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 900
    height: 600
    visible: true
    title: "Library Semantic Search"

    property bool flag: false

    StackView{
        id: stackView
        anchors.fill: parent
        initialItem: "HomePage.qml"
        visible: flag
    }
    Rectangle {
        id: loadingScreen
        anchors.fill: parent
        color: "#374151"
        visible: !flag
        Column{
            anchors.centerIn: parent

            Text {
                text: "Semantic Search System";
                font.pointSize: 20
                font.bold: true
                color: "white"
                font.family: "Times New Roman"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }
    Behavior on flag{
        PropertyAction{
            target: loadingScreen
            property: "Visible"
            value: false
        }
    }

    Timer {
        id: testTimer
        interval: 3000
        running: true
        onTriggered: {
            console.log("Loading complete - showing main app")
            flag = true
        }
    }

}

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 900
    height: 600
    visible: true
    title: "Library Semantic Search"

    StackView{
        anchors.fill: parent
        initialItem: HomePage {}
    }

}

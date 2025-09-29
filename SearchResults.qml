import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Page {
    anchors.fill: parent
    property string query: ""
    header: Rectangle {
        color:"#E5E7EB"
        RowLayout {
            anchors.fill: parent
            Button{
                text: "HomePage";
                onClicked: StackView.view.push("HomePage.qml")
            }
        }
    }

    Column{
        anchors.centerIn: parent;
        spacing: 10
        Label {
            text: "Results for: " + query;
        }
        Row{
            spacing: 10
            TextField{
                id: s
                placeholderText: "Search Books"
                width: 420
            }
            Button {
                text: "Search";
                onClicked:  query = s.text
            }
        }
    }
}

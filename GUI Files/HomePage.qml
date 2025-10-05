import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Effects

Page {
    anchors.fill: parent
    signal doSearch(string query)
    header: Rectangle {
        height: 50
        color: "#374151"
        Text {
            text: "Semantic Search System";
            font.pointSize: 20
            font.bold: true
            color: "white"
            font.family: "Times New Roman"
            anchors.centerIn: parent
        }
    }
    Rectangle{
        id: searchBar
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 80
        color: "#9CA3AF"
        Column{
            anchors.centerIn: parent
            spacing: 10
            Row{
                spacing: 10
                TextField{
                    id: s
                    placeholderText: "Search Books..."
                    font.pointSize: 14
                    width: 420
                    height: 27.5
                    background: Rectangle{
                        radius: 8
                        color: "White"
                        border.color: "Gray"
                    }
                }
                Button {
                    text: "Search";
                    background: Rectangle {
                        color: "#E5E7EB"
                        radius: 8
                    }
                    onClicked:  {
                        doSearch(s.text)
                    }
                }
                Keys.onReturnPressed: {
                    doSearch(s.text)
                }
            }

        }

    }
    onDoSearch: StackView.view.push(Qt.resolvedUrl("SearchResults.qml"),{ "query": s.text })
}

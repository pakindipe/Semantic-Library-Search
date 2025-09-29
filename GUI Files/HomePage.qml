import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    anchors.fill: parent
    signal doSearch(string query)
    Column{
        anchors.centerIn: parent;
        spacing: 10
        TextField{
            id: s
            placeholderText: "Search Books";
            width: 420
        }
        Button {
            text: "Search";
            onClicked:  doSearch(s.text)
        }
    }
    onDoSearch: StackView.view.push(Qt.resolvedUrl("SearchResults.qml"),{ "query": s.text })
}

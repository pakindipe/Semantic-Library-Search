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
                    enabled: s.text.trim() !== ""
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
                    if (s.text.trim() !== ""){
                        doSearch(s.text)
                    }
                }
            }

        }
    }
    onDoSearch: StackView.view.push(Qt.resolvedUrl("SearchResults.qml"),{ "query": s.text })
    Text {
        id: popular
        anchors.top: searchBar.bottom
        anchors.left: parent.left
        anchors.margins: 20
        anchors.topMargin: 30
        text: "Popular Books"
        font.pointSize: 18
        font.bold: true
        color: "#374151"
    }
    Column{
        id: resultsArea
        spacing: 1
        anchors.top: popular.bottom
        anchors.margins: 10
        anchors.left: parent.left
        anchors.right: parent.right
        ListModel {id: books}

        Component.onCompleted: {
            books.append({ title: "To Kill a Mockingbird", author: "Harper Lee", genre: "Gothic Novel", release: "1960" })
            books.append({ title: "To Kill a Kingdom", author: "Alexandra Christo", genre: "Fantasy", release: "2018" })
            books.append({ title: "The Mockingbird Next Door", author: "Marja Mills", genre: "Autobiography", release: "2014" })
        }
        Repeater{
            model: books
            delegate: Rectangle{
                id: card
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width*0.85
                height: 110
                radius: 15
                color: "White"
                border.color: "Gray"


                Row{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 20

                    Rectangle{
                        width: 70
                        height: 80
                        radius: 4
                        color: "Black"
                    }
                    Column{
                        Text{text: "Title: " + title; font.bold:true}
                        Text{text: "Author: " + author; font.bold:true}
                        Text{text: "Genre: " + genre; font.bold:true}
                        Text{text: "Release: " + release; font.bold:true}
                        spacing: 3

                    }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        card.border.color = "Gray"
                        card.border.width = 2
                    }
                    onExited: {
                        card.border.width = 1
                        card.border.color = "Black"
                    }
                    onClicked: {
                        var dialog = bookDetailsComponent.createObject(parent, {
                            "titleText": title,
                            "author": author,
                            "genres": genre,
                            "releaseDate": release,
                            "description": "sample description for " + title + ". this would come from the database or API.",
                            "image": ""
                        })
                        dialog.open()
                    }
                }
            }
        }
    }
    Component {
        id: bookDetailsComponent
        BookDetails {}
    }
}


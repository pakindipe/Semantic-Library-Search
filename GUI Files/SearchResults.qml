import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Effects

Page {
    anchors.fill: parent
    property string query: ""
    property int currentPage: 1
    property int booksPerPage: 10
    Component.onCompleted: loadResults(query)
    property int totalPages: 5
    header: Rectangle {
        height: 50
        color: "#374151"
        Text {
            text: "Semantic Search System";
            font.pointSize: 20
            color: "white"
            font.bold: true
            font.family: "Times New Roman"
            anchors.centerIn: parent
        }
        RowLayout {
            anchors.fill: parent

            Button{
                text: "Home";
                background: Rectangle {
                    color: "#E5E7EB"
                    radius: 8
                }
                onClicked: stackView.pop();
            }

        }
    }


    Rectangle{
        id: searchBar
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100
        color: "#9CA3AF"
        Column{
            anchors.centerIn: parent
            spacing: 10
            Row{
                spacing: 10
                Button{
                    text: "Filters";
                    background: Rectangle {
                        color: "#E5E7EB"
                        radius: 10
                    }
                    onClicked: filterMenu.open()
                }
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
                    Keys.onReturnPressed: {
                        if (s.text.trim() !== "") {
                            query = s.text
                            currentPage = 1
                            loadResults()
                            s.text = ""
                        }
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
                        query = s.text
                        currentPage = 1
                        loadResults()
                        s.text = ""
                    }
                }
            }
            Label {
                text: "Results for: " + query;
                font.pointSize: 14
                font.bold: true
            }
        }
    }
    Menu{
        id: filterMenu
        MenuItem{
            text: "Reset Filters"
        }
        MenuItem{
            text: "Sort by Author"
        }
        MenuItem{
            text: "Sort by Release Year"
        }
        Menu{
            title: "Sort by Genre"

            MenuItem{
                text:  "Autobiography"
            }
            MenuItem{
                text:  "Fantasy"
            }
            MenuItem{
                text:  "Fiction"
            }
            MenuItem{
                text:  "Horror"
            }
            MenuItem{
                text:  "Mystery"
            }
            MenuItem{
                text:  "Romance"
            }
            MenuItem{
                text:  "Science Fiction"
            }
            MenuItem{
                text:  "Thriller"
            }
        }
    }

    ScrollView{
        id: scroll
        spacing: 1
        anchors.top: searchBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: pagination.top
        anchors.margins: 20
        clip: true

        Column{
            spacing: 3
            id: resultsArea
            width: scroll.width

            // Optional empty state
            Item {
                visible: resultsModel.count === 0
                width: parent.width; height: 120
                Text {
                    anchors.centerIn: parent
                    text: "No results yet. Try a search."
                    opacity: 0.7
                }
            }

            Repeater{
                model: resultsModel

                delegate: Rectangle{
                    id: card
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.85
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
                            opacity: available ? 1.0 : 0.5   // dim if not available
                        }

                        Column{
                            spacing: 3
                            Text{ text: "Title: "   + title;   font.bold: true }
                            Text{ text: "Author: "  + author;  font.bold: true }
                            Text{
                                // genres is a QStringList from the model
                                text: "Genres: " + genres.join(", ")
                                font.bold: true
                            }
                            Text{
                                // releaseDate is a QDate from the model
                                text: "Release: " + releaseDate.toString("yyyy-MM-dd")
                                font.bold: true
                            }
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: { card.border.color = "Gray";  card.border.width = 2 }
                        onExited:  { card.border.width = 1;       card.border.color = "Black" }
                        onClicked: {
                            // pass the model data straight into your dialog
                            var dialog = bookDetailsComponent.createObject(parent, {
                                "titleText": title,
                                "author": author,
                                "genres": genres.join(", "),
                                "releaseDate": releaseDate.toString(Qt.DefaultLocaleShortDate),
                                "description": description,
                                "image": ""   // keep as-is for now
                            })
                            dialog.open()
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        id: pagination
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 50
        color: "#9CA3AF"


        Row {
            anchors.centerIn: parent
            spacing: 5
            Button {
                enabled: currentPage > 1
                text: "<< First"
                onClicked: {
                    currentPage = 1
                    pn.text = ""
                    loadResults()
                }
            }
            Button {
                enabled: currentPage > 1
                text: "< Previous"
                onClicked: {
                    currentPage--
                    pn.text = ""
                    loadResults()
                }
            }

            Text{
                text: "Page"
                color: "Black"
                font.pointSize: 11
            }
            TextField{
                id: pn
                placeholderText: currentPage
                color: "Black"
                width: 25
                font.pointSize: 11
                Keys.onReturnPressed: {
                    var input = pn.text.trim()
                    if (input !== "") {
                        var num = parseInt(input)

                        if(num >= 1 && num <= totalPages){
                            currentPage = num
                            loadResults()
                        }
                    }
                    pn.text = ""
                }
            }
            Text{
                text:"of " + totalPages
                color: "Black"
                font.pointSize: 11
            }
            Button {
                enabled: currentPage < totalPages
                text: "Next >"
                onClicked: {
                    currentPage++
                    pn.text = ""
                    loadResults()
                }
            }
            Button {
                enabled: currentPage < totalPages
                text: "Last >>"
                onClicked: {
                    currentPage = totalPages
                    pn.text = ""
                    loadResults()
                }
            }
        }
    }

    Component {
        id: bookDetailsComponent
        BookDetails {}
    }
    function loadResults(){
        //startIndex = (currentPage-1)*booksPerPage
        //endIndex = startIndex + booksPerPage

        //for (int i = startIndex; i < endIndex; i++){books.append()}
    }
}


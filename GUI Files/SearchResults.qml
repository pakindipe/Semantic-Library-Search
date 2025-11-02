import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import LibrarySemanticSearch 1.0     // used for Search.search()

Page {
    anchors.fill: parent
    property string query: ""
    property int currentPage: 1
    property int booksPerPage: 10
    property int totalPages: 5

    // Function that calls the C++/Python bridge and fills the model
    function loadResults() {
        const resp = Search.search(query)   // calls core/SearchService → SearchBridge → python_interface.py
        books.clear()

        if (resp && resp.error) {
            console.log("Search error:", resp.error)
            return
        }
        if (!resp || !resp.results) {
            console.log("No results from Search")
            return
        }

        // Accept either ["title", ...] or [{title,author,genre,release}, ...]
        for (let i = 0; i < resp.results.length; ++i) {
            const r = resp.results[i]
            if (typeof r === "string") {
                books.append({
                    title: r,
                    author: "",
                    genre: "",
                    release: ""
                })
            } else {
                books.append({
                    title:   r.title   ?? "",
                    author:  r.author  ?? "",
                    genre:   r.genre   ?? "",
                    release: r.release ?? ""
                })
            }
        }
    }

    Component.onCompleted: {
        if (query && query.length > 0) {
            loadResults()
        }
    }

    header: Rectangle {
        height: 50
        color: "#374151"
        Text {
            text: "Semantic Search System"
            font.pointSize: 20
            color: "white"
            font.bold: true
            font.family: "Times New Roman"
            anchors.centerIn: parent
        }

        RowLayout {
            anchors.fill: parent
            Button {
                text: "Home"
                background: Rectangle {
                    color: "#E5E7EB"
                    radius: 8
                }
                onClicked: stackView.pop()
            }
        }
    }

    Rectangle {
        id: searchBar
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100
        color: "#9CA3AF"

        Column {
            anchors.centerIn: parent
            spacing: 10

            Row {
                spacing: 10

                Button {
                    text: "Filters"
                    background: Rectangle {
                        color: "#E5E7EB"
                        radius: 10
                    }
                    onClicked: filterMenu.open()
                }

                TextField {
                    id: s
                    placeholderText: "Search Books..."
                    font.pointSize: 14
                    width: 420
                    height: 27.5
                    background: Rectangle {
                        radius: 8
                        color: "White"
                        border.color: "Gray"
                    }
                    Keys.onReturnPressed: {
                        const q = s.text.trim()
                        if (q.length > 0) {
                            query = q
                            currentPage = 1
                            loadResults()
                            s.text = ""
                        }
                    }
                }

                Button {
                    enabled: s.text.trim() !== ""
                    text: "Search"
                    background: Rectangle {
                        color: "#E5E7EB"
                        radius: 8
                    }
                    onClicked: {
                        const q = s.text.trim()
                        if (q.length > 0) {
                            query = q
                            currentPage = 1
                            loadResults()
                            s.text = ""
                        }
                    }
                }
            }

            Label {
                text: "Results for: " + query
                font.pointSize: 14
                font.bold: true
            }
        }
    }

    // ---------- Filter Menu ----------
    Menu {
        id: filterMenu
        MenuItem { text: "Sort by Title" }
        MenuItem { text: "Sort by Author" }
        MenuItem { text: "Sort by Release Year" }

        Menu {
            title: "Sort by Genre"
            MenuItem { text: "Autobiography" }
            MenuItem { text: "Fantasy" }
            MenuItem { text: "Fiction" }
            MenuItem { text: "Horror" }
            MenuItem { text: "Mystery" }
            MenuItem { text: "Romance" }
            MenuItem { text: "Science Fiction" }
        }
    }

    // ---------- Results Area ----------
    ScrollView {
        id: scroll
        spacing: 1
        anchors.top: searchBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: pagination.top
        anchors.margins: 20
        clip: true

        Column {
            spacing: 3
            id: resultsArea
            width: scroll.width

            // Empty state
            Item {
                visible: books.count === 0
                width: parent.width
                height: 120
                Text {
                    anchors.centerIn: parent
                    text: "No results yet. Try a search."
                    opacity: 0.7
                }
            }

            Repeater {
                model: books
                delegate: Rectangle {
                    id: card
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.85
                    height: 110
                    radius: 15
                    color: "White"
                    border.color: "Gray"

                    Row {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 20

                        Rectangle {
                            width: 70
                            height: 80
                            radius: 4
                            color: "Black"
                        }

                        Column {
                            spacing: 3
                            Text { text: "Title: " + title;   font.bold: true }
                            Text { text: "Author: " + author; font.bold: true }
                            Text { text: "Genre: " + genre;   font.bold: true }
                            Text { text: "Release: " + release; font.bold: true }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: { card.border.color = "Gray"; card.border.width = 2 }
                        onExited:  { card.border.width = 1; card.border.color = "Black" }
                        onClicked: {
                            var dialog = bookDetailsComponent.createObject(parent, {
                                "titleText": title,
                                "author": author,
                                "genres": genre,
                                "releaseDate": release,
                                "description": "sample description for " + title,
                                "image": ""
                            })
                            dialog.open()
                        }
                    }
                }
            }
        }
    }

    // ---------- Pagination ----------
    Rectangle {
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
                onClicked: { currentPage = 1; pn.text = ""; loadResults() }
            }
            Button {
                enabled: currentPage > 1
                text: "< Previous"
                onClicked: { currentPage--; pn.text = ""; loadResults() }
            }

            Text { text: "Page"; color: "Black"; font.pointSize: 11 }

            TextField {
                id: pn
                placeholderText: currentPage
                color: "Black"
                width: 25
                font.pointSize: 11
                Keys.onReturnPressed: {
                    var input = pn.text.trim()
                    if (input !== "") {
                        var num = parseInt(input)
                        if (num >= 1 && num <= totalPages) {
                            currentPage = num
                            loadResults()
                        }
                    }
                    pn.text = ""
                }
            }

            Text { text: "of " + totalPages; color: "Black"; font.pointSize: 11 }

            Button {
                enabled: currentPage < totalPages
                text: "Next >"
                onClicked: { currentPage++; pn.text = ""; loadResults() }
            }
            Button {
                enabled: currentPage < totalPages
                text: "Last >>"
                onClicked: { currentPage = totalPages; pn.text = ""; loadResults() }
            }
        }
    }

    Component {
        id: bookDetailsComponent
        BookDetails {}
    }

    ListModel { id: books }
}

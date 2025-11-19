import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import QtQml 2.15

Page {
    anchors.fill: parent
    property int currentPage: 1
    property int booksPerPage: 10
    property int totalPages: 5

    function formatGenre(g) {
        if (!g || g.length === 0)
            return "";

        // Split on underscores and capitalize each word
        var parts = g.split("_");
        for (var i = 0; i < parts.length; i++) {
            if (parts[i].length > 0)
                parts[i] = parts[i].charAt(0).toUpperCase() + parts[i].slice(1);
        }
        return parts.join(" ");
    }

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
                }
                Button {
                    enabled: s.text.trim() !== ""
                    text: "Search";
                    background: Rectangle {
                        color: "#E5E7EB"
                        radius: 8
                    }
                    onClicked:  {
                        searchController.search(s.text)
                        doSearch(s.text)
                    }
                }
                Keys.onReturnPressed: {
                    if (s.text.trim() !== ""){
                        searchController.search(s.text)
                        doSearch(s.text)
                    }
                }
            }

        }
    }
    Menu{
        id: filterMenu
        MenuItem{
            text: "Reset Filters"
            onTriggered: popularModel.setFilter("")
        }
        MenuItem{
            text: "Filter by Author"
             onTriggered: authorDialog.open()
        }
        Menu{
            title: "Sort by Release Year"
            MenuItem { text: "Ascending";           onTriggered: popularModel.setFilter('Ascending') }
            MenuItem { text: "Descending";           onTriggered: popularModel.setFilter('Descending') }
        }
        Menu {
            title: "Filter by Genre"
            MenuItem { text: "Fantasy";             onTriggered: popularModel.setFilter("fantasy") }
            MenuItem { text: "Science Fiction";     onTriggered: popularModel.setFilter("science_fiction") }
            MenuItem { text: "Mystery";             onTriggered: popularModel.setFilter("mystery") }
            MenuItem { text: "Romance";             onTriggered: popularModel.setFilter("romance") }
            MenuItem { text: "Historical Fiction";  onTriggered: popularModel.setFilter("historical_fiction") }
            MenuItem { text: "Horror";              onTriggered: popularModel.setFilter("horror") }
            MenuItem { text: "Young Adult";         onTriggered: popularModel.setFilter("young_adult") }
            MenuItem { text: "Biography";           onTriggered: popularModel.setFilter("biography") }
            MenuItem { text: "Self Help";           onTriggered: popularModel.setFilter("self_help") }
            MenuItem { text: "Classics";            onTriggered: popularModel.setFilter("classics") }
        }
    }
    Dialog {
        id: authorDialog
        title: "Filter by Author"
        modal: true
        width: 300
        height: 180
        standardButtons: Dialog.Ok | Dialog.Cancel

        property string authorQuery: ""

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            TextField {
                id: authorField
                placeholderText: "Enter author..."
                text: authorDialog.authorQuery
                onTextChanged: authorDialog.authorQuery = text

                Keys.onReturnPressed: {
                    if (text.trim() !== "") {
                        popularModel.setFilter(text.trim())
                        authorDialog.close()
                    }
                }
            }
        }

        onAccepted: {
            if (authorField.text.trim() !== "") {
                popularModelModel.setFilter(authorField.text.trim())
            }
        }
    }


    onDoSearch: StackView.view.push(Qt.resolvedUrl("SearchResults.qml"),{ "query": s.text })
    Text {
        id: popular
        anchors.top: searchBar.bottom
        anchors.margins: 20
        anchors.topMargin: 10
        text: "Popular Books"
        anchors.horizontalCenter: parent.horizontalCenter
        font.pointSize: 18
        font.bold: true
        color: "#374151"
    }
    ScrollView{
            id: scroll
            spacing: 1
            anchors.top: popular.bottom
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
                    visible: popularModel.count === 0
                    width: parent.width; height: 120
                    Text {
                        anchors.centerIn: parent
                        text: "No results yet. Try a search."
                        opacity: 0.7
                    }
                }



            Repeater{
                model: popularModel
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

                        Image {
                            width: 70
                            height: 80
                            fillMode: Image.PreserveAspectFit
                            source: "file:///" + appDir + "/covers/" + filename
                            opacity: available ? 1.0 : 0.5
                        }

                        Column{
                            Text{text: "Title: " + title; font.bold:true}
                            Text{text: "Author: " + author; font.bold:true}
                            Text{text: "Genre: " + formatGenre(genres); font.bold:true}
                            Text{text: "Release: " + Qt.formatDate(releaseDate, "yyyy"); font.bold:true}
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
                                "genres": formatGenre(genres),
                                "releaseDate": releaseDate.toString("MMMM '-' dd '-' yyyy"),
                                "description": "sample description for " + title,
                                "image": "file:///" + appDir.replace("\\", "/") + "/covers/" + filename
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
                    popularModel.firstPage()
                }
            }
            Button {
                enabled: currentPage > 1
                text: "< Previous"
                onClicked: {
                    currentPage--
                    pn.text = ""
                    popularModel.prevPage()
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
                            popularModel.setPage(num)
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
                    popularModel.nextPage()
                }
            }
            Button {
                enabled: currentPage < totalPages
                text: "Last >>"
                onClicked: {
                    currentPage = totalPages
                    pn.text = ""
                    popularModel.lastPage()
                }
            }
        }
    }
    Component {
        id: bookDetailsComponent
        BookDetails {}
    }
}


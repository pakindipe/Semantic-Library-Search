import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Effects

Page {
    anchors.fill: parent
    property string query: ""
    property int currentPage: 1
    property int booksPerPage: 10

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

    Component.onCompleted: loadResults(query)
    property int totalPages: resultsModel.totalPages
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
                             searchController.search(query)
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
                        currentPage = 1
                        searchController.search(s.text)
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
                        resultsModel.setFilter(text.trim())
                        authorDialog.close()
                    }
                }
            }
        }

        onAccepted: {
            if (authorField.text.trim() !== "") {
                resultsModel.setFilter(authorField.text.trim())
            }
        }
    }

    Menu{
        id: filterMenu
        MenuItem{
            text: "Reset Filters"
            onTriggered: resultsModel.setFilter("")
        }
        MenuItem {
            text: "Filter by Author"
            onTriggered: authorDialog.open()
        }
        Menu{
            title: "Sort by Release Year"
            MenuItem { text: "Ascending";           onTriggered: resultsModel.setFilter('Ascending') }
            MenuItem { text: "Descending";           onTriggered: resultsModel.setFilter('Descending') }
        }
        Menu{
            title: "Filter by Genre"
            MenuItem { text: "Fantasy";             onTriggered: resultsModel.setFilter("fantasy") }
            MenuItem { text: "Science Fiction";     onTriggered: resultsModel.setFilter("science_fiction") }
            MenuItem { text: "Mystery";             onTriggered: resultsModel.setFilter("mystery") }
            MenuItem { text: "Romance";             onTriggered: resultsModel.setFilter("romance") }
            MenuItem { text: "Historical Fiction";  onTriggered: resultsModel.setFilter("historical_fiction") }
            MenuItem { text: "Horror";              onTriggered: resultsModel.setFilter("horror") }
            MenuItem { text: "Young Adult";         onTriggered: resultsModel.setFilter("young_adult") }
            MenuItem { text: "Biography";           onTriggered: resultsModel.setFilter("biography") }
            MenuItem { text: "Self Help";           onTriggered: resultsModel.setFilter("self_help") }
            MenuItem { text: "Classics";            onTriggered: resultsModel.setFilter("classics") }
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

                        Image {
                            width: 70
                            height: 80
                            fillMode: Image.PreserveAspectFit
                            source: "file:///" + appDir + "/covers/" + filename
                            opacity: available ? 1.0 : 0.5
                        }

                        Column{
                            spacing: 3
                            Text{ text: "Title: "   + title;   font.bold: true }
                            Text{ text: "Author: "  + author;  font.bold: true }
                            Text{
                                // genres is a QStringList from the model
                                text: "Genre: " + formatGenre(genres)
                                font.bold: true
                            }
                            Text{
                                // releaseDate is a QDate from the model
                                text: "Release: " + Qt.formatDate(releaseDate, "yyyy")
                                Component.onCompleted:  console.log("Formatted Time:"  + releaseDate.toString("MMMM '-' d '-' yyyy"))
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
                                "genres": formatGenre(genres),
                                "releaseDate": releaseDate.toString("MMMM '-' dd '-' yyyy"),
                                "description": description,
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
                    resultsModel.firstPage();
                }
            }
            Button {
                enabled: currentPage > 1
                text: "< Previous"
                onClicked: {
                    currentPage--
                    pn.text = ""
                    resultsModel.prevPage()
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
                            resultsModel.setPage(num)
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
                    resultsModel.nextPage()
                }
            }
            Button {
                enabled: currentPage < totalPages
                text: "Last >>"
                onClicked: {
                    currentPage = totalPages
                    pn.text = ""
                    resultsModel.lastPage()
                }
            }
        }
    }

    Component {
        id: bookDetailsComponent
        BookDetails {}
    }

}


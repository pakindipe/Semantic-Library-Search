import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import QtQuick.Effects

Dialog {
    id: bookDetails
    title: qsTr("Info")
    modal: true
    dim: false
    anchors.centerIn: Overlay.overlay
    implicitWidth: 0.85 * Overlay.overlay.width
    implicitHeight: 0.85 * Overlay.overlay.height
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    //Book Meta-Data
    property string titleText: ""
    property string author: ""
    property string genres: ""
    property string description: ""
    property string releaseDate: ""
    property string image: ""

    //Constants
    property int rowMargin: implicitWidth / 25
    property int topMargins: implicitHeight / 15
    property int rowSpacing: implicitWidth / 4
    property int columnSpacing: implicitHeight / 4
    property int minHeight: 290
    signal viewed()

    function minHeightCheck()
    {
        if (implicitHeight < minHeight)
        {
            close();
        }
    }

    //Background Rectangle and stroke
    background: Item
    {
        anchors.fill: parent

        RectangularShadow
        {
            anchors.fill: parent
            radius: mainContainer.radius
            color: "#000000"
            offset.x: 0
            offset.y: 12
            blur: 24          // px
            spread: 0         // px
            z: 0
        }
        Rectangle
        {
            id: mainContainer
            anchors.fill: parent
            radius: 16
            color: "#F7F7F9"
            border.width: 5
            border.color: "#E5E5E5"
            z: 1
        }

    }

    //Header with top right 'X'
    header: Item
    {
        implicitHeight: 40
        RowLayout
        {
            anchors.fill: parent
            Label
            {
                text: bookDetails.titleText
                padding: 8
                Layout.fillWidth: true
                font.bold: true
            }
            ToolButton
            {
                text: "✕"                     // simple, theme-independent X
                Accessible.name: qsTr("Close")
                onClicked: bookDetails.close()
                padding: 8
            }
        }
    }


    contentItem: Column
    {
        spacing: rowMargin        //Distance between rows
        anchors.fill: parent
        anchors.margins: rowMargin
        anchors.topMargin: topMargins //Distance from header to first row



        //Row containing Image and 2 Rows of Book Meta-Data (Title, Genres)
        Row
        {
            id: imageRow
            width: parent.width
            spacing: width / 25
            height: topLeft.height
            Label
            {
                id: fontLabel
                visible: false
            }

            FontMetrics
            {
               id: fontM
               font: fontLabel.font
            }



            //Rectangle to store image
            Rectangle
            {
                id: topLeft
                width: bookDetails.implicitWidth / 4
                height: Math.round(width * 4/3)
                color: "white"
                clip: true

                //Load image to rectangle
                Image {
                    fillMode: Image.Stretch
                    anchors.fill: parent
                    source: image
                }
            }

            //Container for the top to the right of the image
            Item
            {
                id: topRight
                width: imageRow.width - topLeft.width - imageRow.spacing
                height: topLeft.height

                property real leftGroupX:   width * 0.00
                property real leftGroupW:   width * 0.48
                property real rightGroupX:  width * 0.52
                property real rightGroupW:  width * 0.48
                property real topGroupY:    height * 0.00
                property real topGroupH:    height * 0.48
                property real bottomGroupY: height * 0.52
                property real bottomGroupH: height * 0.48

                property int  labelPct: 32      // % of group width for the label
                property int  innerGap: 8       // space between Label and Text

                //Column to organize text vertically
                Column
                {
                    id: metaColumn
                    anchors.fill: parent
                    spacing: 8



                   Item
                   {
                       id: metaDataRow1
                       width: parent.width



                       //Left Data: Title: ""
                        Label
                        {
                           id: titleLabel
                           text: qsTr("Title:")
                           font.bold: true
                           x: topRight.leftGroupX
                           y: 0
                           width: Math.round(topRight.leftGroupW * topRight.labelPct/100)
                           horizontalAlignment: Text.AlignRight
                        }


                        Text
                        {
                            id: titleText
                            text: bookDetails.titleText
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            x: titleLabel.x + titleLabel.width + topRight.innerGap
                            y: 0
                            width: topRight.leftGroupX + topRight.leftGroupW - x
                            height: topRight.topGroupH
                            maximumLineCount: metaDataRow1.maxLines
                        }


                        //Right Data: Author: ""
                        Label
                        {
                            id: authorLabel
                            text: qsTr("Author:")
                            font.bold: true
                            x: topRight.rightGroupX
                            y: 0
                            width: Math.round(topRight.rightGroupW * topRight.labelPct/100)
                            horizontalAlignment: Text.AlignRight
                        }
                        Text
                        {
                            id: authorText
                            text: bookDetails.author
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            x: authorLabel.x + authorLabel.width + topRight.innerGap
                            y: 0
                            width: topRight.rightGroupX + topRight.rightGroupW - x
                            height: topRight.bottomGroupH
                            maximumLineCount: metaDataRow2.maxLines

                        }

                        height: Math.min(topRight.topGroupY + topRight.topGroupH, Math.max(titleText.height, authorText.height))
                        implicitHeight: height



                        property int maxLines: Math.max(1, Math.floor(height / Math.ceil(fontM.height)))

                   }

                   Item
                   {
                       id: metaDataRow2
                       width: parent.width

                       //Left Data: Release Date: ""
                       Label
                        {
                           id: releaseDateLabel
                           text: qsTr("Release Date:")
                           font.bold: true
                           x: topRight.leftGroupX
                           y: 0
                           width: Math.round(topRight.leftGroupW * topRight.labelPct/100)
                           horizontalAlignment: Text.AlignRight
                        }
                        Text
                        {
                            id: releaseDateText
                            text: bookDetails.releaseDate
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            x: releaseDateLabel.x + releaseDateLabel.width + topRight.innerGap
                            y: 0
                            width: topRight.leftGroupX + topRight.leftGroupW - x
                            height: topRight.bottomGroupH + topRight.bottomGroupY
                            maximumLineCount: metaDataRow2.maxLines
                        }


                        //Right Data: Genres: ""
                        Label
                        {
                            id: genresLabel
                            text: qsTr("Genres:")
                            font.bold: true
                            x: topRight.rightGroupX
                            y: 0
                            width: Math.round(topRight.rightGroupW * topRight.labelPct/100)
                            horizontalAlignment: Text.AlignRight
                        }
                        Text
                        {
                            id: genresText
                            text: bookDetails.genres
                            wrapMode: Text.WordWrap
                            elide: Text.ElideRight
                            x: genresLabel.x + genresLabel.width + topRight.innerGap
                            y: 0
                            width: topRight.rightGroupX + topRight.rightGroupW - x
                            height: topRight.bottomGroupH + topRight.bottomGroupY
                            maximumLineCount: metaDataRow2.maxLines
                        }

                        height: Math.min(topRight.bottomGroupH, Math.max(releaseDateText.height, genresText.height))
                        implicitHeight: height


                        property int maxLines: Math.max(1, Math.floor(height / Math.ceil(fontM.height)))

                   }
                }
            }




        }
        //Row for the bottom of the column - Holds Description
        Column
        {
            id: descriptionColumn
            width: parent.width
            spacing: rowSpacing
            height: Math.max(0, parent.height - imageRow.height - parent.spacing)
            clip: true


            Text
            {
                id: descriptionText
                height: parent.height
                width: parent.width
                text: "Description: " + bookDetails.description
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: Math.max(1, Math.floor(height / Math.ceil(fontM.height)))
            }
        }


    }
    onImplicitHeightChanged:
    {
        minHeightCheck()
    }

    onOpened:
    {
        minHeightCheck()
        viewed()
    }
}

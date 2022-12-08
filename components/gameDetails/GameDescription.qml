import QtQuick 2.15
import QtGraphicalEffects 1.12

Item {

    function resetFlickable() {
        flickable.contentY = -flickable.topMargin;
    }

    function scrollUp() {
        flickable.contentY = Math.max(
            -flickable.topMargin,
            flickable.contentY - (flickable.height - flickable.bottomMargin) * .85,
        );
    }

    function scrollDown() {
        flickable.contentY = Math.min(
            flickable.contentY + (flickable.height - flickable.bottomMargin) * .85,
            flickable.contentHeight - flickable.height,
        );
        /*             flickable.contentY + fullDesc.font.pixelSize * 10, */
    }

    Keys.onPressed: {
        if (api.keys.isPageDown(event)) {
            console.log("page down");
            event.accepted = true;
            fullDescription.scrollDown();
        }
        if (api.keys.isPageUp(event)) {
            console.log("page up");
            event.accepted = true;
            fullDescription.scrollUp();
        }
    }


    // solves some kerning issues with period and commas
    property var descText: {
        if (currentGame === null) return '';

        return currentGame.description
            .replace(/\. {1,}/g, '.  ')
            .replace(/, {1,}/g, ',  ');
    }

    property var fullDescText: {
        return descText + "\n";
    }

    property var filenames: {
        if (currentGame.files.count === 1) {
            return 'file: ' + currentGame.files.get(0).path;
        }

        const files = [];
        for (let i = 0; i < currentGame.files.count; i++) {
            files.push(currentGame.files.get(i).path);
        }


        return "files:\n  - " + files.join("\n  - ");
    }

    Flickable {
        id: flickable;

        contentWidth: fullDesc.width;
        contentHeight: fullDesc.height + fileDetails.height;
        flickableDirection: Flickable.VerticalFlick;
        anchors.fill: parent;
        clip: true;
        bottomMargin: 20;
        leftMargin: 20;
        rightMargin: 20;
        topMargin: vpx(5);

        Behavior on contentY {
            PropertyAnimation { easing.type: Easing.OutCubic; duration: 150; }
        }

        Rectangle {
            Text {
                id: fullDesc;

                width: fullDescription.width - flickable.leftMargin - flickable.rightMargin;
                text: fullDescText;
                wrapMode: Text.WordWrap;
                lineHeight: 1.2;
                color: theme.current.detailsColor;
                horizontalAlignment: Text.AlignJustify;

                font {
                    pixelSize: root.height * .03 * theme.fontScale;
                    letterSpacing: -0.35;
                    bold: false;
                }
            }

            Text {
                id: fileDetails;

                width: fullDescription.width - flickable.leftMargin - flickable.rightMargin;
                text: filenames;
                wrapMode: Text.WordWrap;
                lineHeight: 1.2;
                color: theme.current.detailsColor;
                horizontalAlignment: Text.AlignJustify;

                font {
                    pixelSize: root.height * .024 * theme.fontScale;
                    letterSpacing: -0.35;
                    bold: false;
                }
                
                anchors {
                    top: fullDesc.bottom;
                    left: parent.left;
                    right: parent.right;
                }
            }
        }
    }
}

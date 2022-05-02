import QtQuick 2.15
import QtGraphicalEffects 1.12

import '../media' as Media

Item {

    function resetFlickable() {
        flickable.contentY = -flickable.topMargin;
    }

    function scrollUp() {
        flickable.contentY = Math.max(
            -flickable.topMargin,
            flickable.contentY - fullDesc.font.pixelSize,
        );
    }

    function scrollDown() {
        flickable.contentY = Math.min(
            flickable.contentY + fullDesc.font.pixelSize,
            flickable.contentHeight - root.height + flickable.bottomMargin,
        );
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

    Flickable {
        id: flickable;

        contentWidth: fullDesc.width;
        contentHeight: fullDesc.height;
        flickableDirection: Flickable.VerticalFlick;
        anchors.fill: parent;
        clip: true;
        bottomMargin: 20;
        leftMargin: 20;
        rightMargin: 20;
        topMargin: 20;

        Behavior on contentY {
            PropertyAnimation { easing.type: Easing.OutCubic; duration: 150  }
        }

        Text {
            id: fullDesc;

            //width: root.width - flickable.leftMargin - flickable.rightMargin;
            width: fullDescription.width - flickable.leftMargin - flickable.rightMargin;
            text: descText;
            wrapMode: Text.WordWrap;
            lineHeight: 1.2;
            color: theme.current.detailsColor;
            horizontalAlignment: Text.AlignJustify;

            font {
                pixelSize: root.height * .035 * theme.fontScale;
                letterSpacing: -0.35;
                bold: false;
            }

            MouseArea {
                anchors.fill: parent;

                onClicked: {
                    detailsButtonClicked('less');
                }
            }
        }
    }
}

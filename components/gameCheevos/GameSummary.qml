import QtQuick 2.15
import QtGraphicalEffects 1.12

import '../media' as Media

Item {

    property string completionText: {
        if (cheevosData.currentGameDetails.NumAchievements == 0) { return ''; }
        return '' + Math.floor(cheevosData.currentGameDetails.NumAwardedToUser * 100 / cheevosData.currentGameDetails.NumAchievements) + '%';
    }

    property string numEarnedText: {
        if (cheevosData.currentGameDetails.NumAchievements == 0) { return ''; }
        let text = '' + cheevosData.currentGameDetails.NumAwardedToUser + ' of ' + cheevosData.currentGameDetails.NumAchievements;
        if (cheevosData.currentGameDetails.NumAwardedToUserHardcore > 0) {
            text += ' (' + cheevosData.currentGameDetails.NumAwardedToUserHardcore + ' hardcore)';
        }
        return text;
    }
    
    property string gameIconUrl : {
        if (cheevosData.currentGameDetails.ImageIcon === undefined || cheevosData.currentGameDetails.ImageIcon == '') {
            return '';
        }
        return 'https://media.retroachievements.org' + cheevosData.currentGameDetails.ImageIcon;
    }

    Media.GameImage {
        id: gameIcon;

        height: parent.height;
        width: parent.height;  // make it square
        anchors {
            top: parent.top;
            right: parent.right;
            bottom: parent.bottom;
            topMargin: vpx(10);
            rightMargin: vpx(22);
            bottomMargin: vpx(10);
        }
        imageSource: gameIconUrl;
    }

    Text {
        id: gameTitle;

        text: cheevosData.currentGameDetails.Title;
        elide: Text.ElideRight;
        color: theme.current.detailsColor;

        font {
            pixelSize: parent.height * .38;
            letterSpacing: -0.3;
            bold: true;
        }

        width: parent.width * .6;
        anchors {
            top: parent.top;
            topMargin: vpx(4);
            left: parent.left;
            leftMargin: vpx(22);
        }
    }

    Text {
        id: gameConsole;

        text: cheevosData.currentGameDetails.ConsoleName;
        elide: Text.ElideRight;
        color: theme.current.detailsColor;
        opacity: .8;

        font {
            pixelSize: parent.height * .26;
            letterSpacing: -0.3;
            bold: true;
        }

        width: parent.width * .4;
        anchors {
            top: gameTitle.bottom;
            topMargin: vpx(4);
            left: parent.left;
            leftMargin: vpx(22);
        }
    }

    Text {
        id: completion;

        text: completionText;
        horizontalAlignment: Text.AlignRight;
        color: theme.current.detailsColor;

        font {
            pixelSize: parent.height * .38;
            letterSpacing: -0.3;
            bold: true;
        }

        width: parent.width * .3;
        anchors {
            top: parent.top;
            topMargin: vpx(4);
            right: gameIcon.left;
            rightMargin: 12;
        }
    }

    Text {
        id: numEarned;

        text: numEarnedText;
        horizontalAlignment: Text.AlignRight;
        color: theme.current.detailsColor;
        opacity: .7;

        font {
            pixelSize: parent.height * .26;
            letterSpacing: -0.3;
            bold: false;
        }

        width: parent.width * .35;
        anchors {
            top: completion.bottom;
            topMargin: vpx(4);
            right: gameIcon.left;
            rightMargin: 12;
        }
    }

    // divider
    Rectangle {
        height: 1;
        color: theme.current.dividerColor;

        anchors {
            bottom: parent.bottom;
            left: parent.left;
            leftMargin: 22;
            right: parent.right;
            rightMargin: 22;
        }
    }

}
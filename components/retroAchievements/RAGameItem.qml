import QtQuick 2.15

import '../media' as Media

Item {

    property string lastPlayedText: {
        if (currentGame === null) return '';

        const lastPlayed = Date.parse(LastPlayed);
        if (isNaN(lastPlayed)) return 'Never played';

        const now = new Date().getTime();

        let time = Math.floor((now - lastPlayed) / 1000);
        if (time < 60) {
            return 'Played ' + time + ' seconds ago';
        }

        time = Math.floor(time / 60);
        if (time < 60) {
            return 'Played ' + time + ' minutes ago';
        }

        time = Math.floor(time / 60);
        if (time < 24) {
            return 'Played ' + time + ' hours ago';
        }

        time = Math.floor(time / 24);
        return 'Played ' + time + ' days ago';
    }

    property string numCheevosText: {
        return '' + NumAchieved + ' of ' + NumPossibleAchievements;
    }
 
    property string numHardcoreText: {
        if (NumAchievedHardcore === 0) return '';
        return '' + NumAchievedHardcore + ' hardcore';
    }
 
    MouseArea {
        anchors.fill: parent;

        onClicked: {
            if (recentRAGamesListView.currentIndex === index) {
                onAcceptPressed();
            } else {
                const updated = updateRARecentGameIndex(index);
                if (updated) { sounds.nav(); }
            }
        }

        onPressAndHold: {
            if (recentRAGamesListView.currentIndex === index) {
                onDetailsPressed();
            } else {
                const updated = updateRARecentGameIndex(index);
                if (updated) { sounds.nav(); }
            }
        }
    }

    Media.GameImage {
        id: gameIcon;

        height: parent.height;
        width: parent.height;  // make it square
        anchors {
            top: parent.top;
            left: parent.left;
            bottom: parent.bottom;
            topMargin: vpx(4);
            leftMargin: vpx(4);
            bottomMargin: vpx(4);
        }
        imageSource: debugRA ? '' : 'https://media.retroachievements.org' + ImageIcon;
    }

    Text {
        id: recentGameTitle;

        text: Title;
        elide: Text.ElideRight;
        color: recentRAGamesListView.currentIndex === index
            ? theme.current.focusTextColor
            : theme.current.blurTextColor;

        font {
            pixelSize: parent.height * .38;
            letterSpacing: -0.3;
            bold: true;
        }

        width: parent.width * .6;
        anchors {
            top: parent.top;
            topMargin: vpx(4);
            left: gameIcon.right;
            leftMargin: 12;
        }
    }

    Text {
        id: recentGameCheevos;

        text: numCheevosText;
        color: recentRAGamesListView.currentIndex === index
            ? theme.current.focusTextColor
            : theme.current.blurTextColor;
        horizontalAlignment: Text.AlignRight;

        font {
            pixelSize: parent.height * .38;
            letterSpacing: -0.3;
            bold: true;
        }

        width: parent.width * .3;
        anchors {
            top: parent.top;
            topMargin: vpx(4);
            right: parent.right;
            rightMargin: 12;
        }
    }

    Text {
        id: recentGameConsole;

        text: ConsoleName;
        elide: Text.ElideRight;
        color: recentRAGamesListView.currentIndex === index
            ? theme.current.focusTextColor
            : theme.current.blurTextColor;
        opacity: .8;

        font {
            pixelSize: parent.height * .26;
            letterSpacing: -0.3;
            bold: true;
        }

        width: parent.width * .4;
        anchors {
            top: recentGameTitle.bottom;
            topMargin: vpx(4);
            left: gameIcon.right;
            leftMargin: 12;
        }
    }

    Text {
        id: recentGameLastPlayed;

        text: lastPlayedText;
        elide: Text.ElideRight;
        color: recentRAGamesListView.currentIndex === index
            ? theme.current.focusTextColor
            : theme.current.blurTextColor;
        opacity: .7;

        font {
            pixelSize: parent.height * .26;
            letterSpacing: -0.3;
            bold: false;
        }

        width: parent.width * .35;
        anchors {
            top: recentGameTitle.bottom;
            topMargin: vpx(4);
            left: recentGameConsole.right;
            leftMargin: 12;
        }
    }

    Text {
        id: recentGameHardcoreNum;

        text: numHardcoreText;
        color: recentRAGamesListView.currentIndex === index
            ? theme.current.focusTextColor
            : theme.current.blurTextColor;
        opacity: .7;
        horizontalAlignment: Text.AlignRight;

        font {
            pixelSize: parent.height * .26;
            letterSpacing: -0.3;
            bold: false;
        }

        width: parent.width * .25;
        anchors {
            top: recentGameTitle.bottom;
            topMargin: vpx(4);
            right: parent.right;
            rightMargin: 12;
        }
    }

}

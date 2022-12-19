 import QtQuick 2.15

import '../media' as Media

Item {

    property string dateEarnedText: {
        if (cheevosData.currentGameID === null) return '';

        if (DateEarned == 0) return 'Locked';

        const now = new Date().getTime();

        let time = Math.floor((now - DateEarned) / 1000);
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
        return 'Earned ' + time + ' days ago';
    }

    property string pointsText: {
        return (Hardcore === true ? '(hardcore) ': '')  + Points +' points';
    }
 
    MouseArea {
        anchors.fill: parent;

        onClicked: {
            console.log( 'clicked ' + index );
            if (gameCheevosListView.currentIndex === index) {
                onAcceptPressed();
            } else {
                const updated = updateGameCheevosIndex(index);
                if (updated) { sounds.nav(); }
            }
        }

        onPressAndHold: {
            console.log( 'long pressed ' + index );
            if (gameCheevosListView.currentIndex === index) {
                onDetailsPressed();
            } else {
                const updated = updateGameCheevosIndex(index);
                if (updated) { sounds.nav(); }
            }
        }
    }

    Media.GameImage {
        id: cheevosIcon;

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
        imageSource: debugRA ? '' : 'https://media.retroachievements.org/Badge/' + BadgeName + '.png';
    }

    Text {
        id: cheevosTitle;

        text: Title;
        elide: Text.ElideRight;
        color: gameCheevosListView.currentIndex === index
            ? theme.current.focusTextColor
            : theme.current.blurTextColor;
        opacity: DateEarned == 0 ? .5 : 1;

        font {
            pixelSize: parent.height * .38;
            letterSpacing: -0.3;
            bold: true;
        }

        width: parent.width * .75;
        anchors {
            top: parent.top;
            topMargin: vpx(4);
            left: cheevosIcon.right;
            leftMargin: 12;
        }
    }

    Text {
        id: cheevosPoints;

        text: pointsText;
        color: gameCheevosListView.currentIndex === index
            ? theme.current.focusTextColor
            : theme.current.blurTextColor;
        opacity: DateEarned == 0 ? .5 : 1;
        horizontalAlignment: Text.AlignRight;

        font {
            pixelSize: parent.height * .38;
            letterSpacing: -0.3;
            bold: true;
        }

        width: parent.width * .25;
        anchors {
            top: parent.top;
            topMargin: vpx(4);
            right: parent.right;
            rightMargin: 12;
        }
    }

    Text {
        id: description;

        text: Description;
        elide: Text.ElideRight;
        color: gameCheevosListView.currentIndex === index
            ? theme.current.focusTextColor
            : theme.current.blurTextColor;
        opacity: DateEarned == 0 ? .4 : 8;

        font {
            pixelSize: parent.height * .26;
            letterSpacing: -0.3;
            bold: true;
        }

        width: parent.width * .75;
        anchors {
            top: cheevosTitle.bottom;
            topMargin: vpx(4);
            left: cheevosIcon.right;
            leftMargin: 12;
        }
    }


    Text {
        id: cheevosDate;

        text: dateEarnedText;
        color: gameCheevosListView.currentIndex === index
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
            top: cheevosTitle.bottom;
            topMargin: vpx(4);
            right: parent.right;
            rightMargin: 12;
        }
    }

}

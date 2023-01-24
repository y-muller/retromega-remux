import QtQuick 2.15
import QtGraphicalEffects 1.12

import '../media' as Media

Item {

    property alias gameDetailsVideo: gameDetailsVideo;

    property string genreText: {
        if (currentGame === null) return '';

        if (currentGame.genreList.length === 0) { return null; }

        const genre = currentGame.genreList[0] ?? '';
        const split = genre.split(',');

        if (split[0].length === 0) { return null; }

        return split[0];
    }

    property string lastPlayedText: {
        if (currentGame === null) return '';

        const lastPlayed = currentGame.lastPlayed.getTime();
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

    property string playTimeText: {
        if (currentGame === null) return '';

        const playTime = currentGame.playTime;
        if (playTime == 0) return '';
        
        if (playTime < 60) {
            return 'Play time: ' + playTime + ' seconds';
        }

        let minutes = Math.floor(playTime / 60);
        if (minutes < 60) {
            return 'Play time: ' + minutes + ' minute' + (minutes>1 ? 's' : '');
        }

        let hours = Math.floor(minutes / 60);
        minutes = minutes - hours * 60;
        return 'Play time: ' + hours + ' hr' + (hours>1 ? 's ' : ' ') + (minutes>0 ? minutes + ' min' + (minutes>1 ? 's' : '') : '');
    }

    property string developedByText: {
        if (currentGame === null) return '';

        let devtext = '';
        if (currentGame.developer) {
            devtext = devtext + currentGame.developer;
        }

        if (currentGame.publisher) {
            if (devtext != '')
                devtext = devtext + " / ";
            devtext = devtext + currentGame.publisher;
        }

        return devtext;
    }

    function playTimeCallback(enabled) {
        playTime.visible = enabled;
    }

    Component.onCompleted: {
        playTimeCallback(settings.get('playTime'));
        settings.addCallback('playTime', playTimeCallback);
    }

    Text {
        id: developedBy;
        text: developedByText;

        color: theme.current.detailsColor;
        opacity: .5;
        elide: Text.ElideRight
        maximumLineCount: 1;

        font {
            family: glyphs.name;
            pixelSize: parent.height * .04 * theme.fontScale;
            bold: true;
        }
        
        height: parent.height * .04 + vpx(10) * theme.fontScale;
        anchors {
            top: parent.top;
            left: parent.left;
            leftMargin: vpx(15);
            right: parent.right;
        }
    }

    Text {
        id: genre;
        text: genreText;

        color: theme.current.detailsColor;
        opacity: .7;
        elide: Text.ElideRight
        maximumLineCount: 1;

        font {
            family: glyphs.name;
            pixelSize: parent.height * .05 * theme.fontScale;
            bold: true;
        }

        height: parent.height * .05 + vpx(10) * theme.fontScale;
        anchors {
            top: developedBy.bottom;
            left: parent.left;
            leftMargin: vpx(15);
            right: parent.right;
        }
    }

    Text {
        id: lastPlayed;
        text: lastPlayedText;

        color: theme.current.detailsColor;
        opacity: .5;
        elide: Text.ElideRight
        maximumLineCount: 1;

        font {
            family: glyphs.name;
            pixelSize: parent.height * .045 * theme.fontScale;
            bold: false;
        }

        height: parent.height * .05 + vpx(10) * theme.fontScale;
        anchors {
            top: genre.bottom;
            topMargin: vpx(5) * theme.fontScale;
            left: parent.left;
            leftMargin: vpx(15);
            right: parent.right;
        }
    }

    Text {
        id: playTime;
        text: playTimeText;

        color: theme.current.detailsColor;
        opacity: .5;
        elide: Text.ElideRight
        maximumLineCount: 1;

        font {
            family: glyphs.name;
            pixelSize: parent.height * .035 * theme.fontScale;
            bold: false;
        }

        height: parent.height * .04 + vpx(10) * theme.fontScale;
        anchors {
            top: lastPlayed.bottom;
            topMargin: vpx(1) * theme.fontScale;
            left: parent.left;
            leftMargin: vpx(15);
            right: parent.right;
        }
    }

    Media.GameImage {
        id: gameDetailsScreenshot;

        imageSource: imgScreenshot;

        //height: parent.height * .6;
        anchors {
            top: playTime.bottom;
            topMargin: vpx(20);
            bottom: parent.bottom;
            left: parent.left;
            leftMargin: vpx(15);
            right: parent.right;
        }

    }

    Media.GameVideo {
        id: gameDetailsVideo;

        height: parent.height * .6;
        anchors {
            top: lastPlayed.bottom;
            topMargin: vpx(20);
            bottom: parent.bottom;
            left: parent.left;
            leftMargin: vpx(15);
            right: parent.right;
        }

        settingKey: 'gameDetailsVideo';
        validView: 'gameDetails';

        onVideoToggled: {
            gameDetailsScreenshot.videoPlaying = videoPlaying;
        }
    }

}

import QtQuick 2.15

import '../media' as Media

Item {
    property alias video: gameListVideo;
    property alias gamesListView: gamesListView;
    property var sortingFont: global.fonts.sans;
    property alias letter: skipLetter.letter;

    property double itemHeight: {
        return gamesListView.height * .12 * theme.fontScale;
    }

    property string imgBoxFront: {
        if (currentGame === null) return '';
        return currentGame.assets.boxFront;
    }

    property string imgScreenshot: {
        if (currentGame === null) return '';
        return currentGame.assets.screenshot;
    }

    property var ratingText: {
        if (currentGame === null) return '';
        if (currentGame.rating === 0) return '';

        let stars = [];
        const rating = Math.round(currentGame.rating * 500) / 100;

        for (let i = 0; i < 5; i++) {
            if (rating - i <= 0) {
                stars.push(glyphs.emptyStar);
            } else if (rating - i < 1) {
                stars.push(glyphs.halfStar);
            } else {
                stars.push(glyphs.fullStar);
            }
        }

        return stars.join(' ');
    }

    property string releaseDateText: {
        if (currentGame === null) return '';
        if (!currentGame.releaseYear) return '';
        return currentGame.releaseYear;
    }

    property string playersText: {
        if (currentGame === null) return '';
        if (!currentGame.players) return '';
        return currentGame.players + 'P';
    }

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

    property var sortingText: {
        if (sortKey === 'release') {
            sortingFont = global.fonts.sans;
            return gameData.releaseDateText;
        }

        if (sortKey === 'rating') {
            sortingFont = glyphs.name;
            return gameData.ratingText;
        }

        sortingFont = global.fonts.sans;
        return gameData.lastPlayedText;
    }

    property string noGameText: {
        if (nameFilter != '') {
            return 'No Games With "' + nameFilter + '"';
        }

        return 'No Games';
    }

    function playTimeCallback(enabled) {
        playTime.visible = enabled;
    }

    Component.onCompleted: {
        gamesListView.currentIndex = currentGameIndex;
        gamesListView.positionViewAtIndex(currentGameIndex, ListView.Center);

        settings.addCallback('gameListVideo', function () {
            gameListVideo.switchVideo();
        });

        playTimeCallback(settings.get('playTime'));
        settings.addCallback('playTime', playTimeCallback);
    }

    Text {
        visible: currentGameList.count === 0;
        text: noGameText;
        anchors.centerIn: parent;
        color: theme.current.blurTextColor;
        opacity: 0.5;

        font {
            pixelSize: parent.height * .065;
            letterSpacing: -0.3;
            bold: true;
        }
    }

    ListView {
        id: gamesListView;

        model: currentGameList;
        delegate: lvGameDelegate;
        width: (parent.width / 2) - 20; // 20 is left margin
        height: parent.height - 24;
        highlightMoveDuration: 0;
        preferredHighlightBegin: itemHeight - 12; // height of an item minus top margin
        preferredHighlightEnd: parent.height - (itemHeight + 12); // height of an item plus bottom margin
        highlightRangeMode: ListView.ApplyRange;

        anchors {
            left: parent.left;
            leftMargin: 20;
            top: parent.top;
            topMargin: 12;
            bottom: parent.bottom;
            bottomMargin: 12;
        }

        highlight: Rectangle {
            color: collectionData.getColor(currentShortName);
            opacity: theme.current.bgOpacity;
            radius: 8;
            width: gamesListView.width;
        }

        onCurrentIndexChanged: {
            gameListVideo.switchVideo();
        }
    }

    Component {
        id: lvGameDelegate;

        GameItem {
            width: gamesListView.width;
            height: itemHeight;
        }
    }

    SkipLetter {
        id: skipLetter;

        anchors {
            verticalCenter: gamesListView.verticalCenter;
            horizontalCenter: gamesListView.horizontalCenter;
        }
    }

    /* Vertical pane with rating, players, date */
    VerticalPane {
        id: verticalPane;

        width: vpx(40);
        anchors {
            top: parent.top;
            topMargin: vpx(10);
            bottom: parent.bottom;
            bottomMargin: vpx(10);
            right: parent.right;
            rightMargin: vpx(22);
        }
    }

    Rectangle {
        color: 'transparent';
        width: parent.width / 2 - vpx(62);
        height: parent.height;
        x: parent.width / 2;


        /*Rectangle {
            height: parent.height - gameListBoxart.height * .95 - vpx(10);
            anchors {
                top: parent.top;
                topMargin: vpx(20);
                left: parent.left;
                leftMargin: vpx(70);
                right: parent.right;
                rightMargin: vpx(10);
            }
            color: 'transparent'; border.color: 'magenta';
        }*/

        Media.GameImage {
            id: gameListScreenshot;

            height: parent.height - gameListBoxart.height * .95 - vpx(10);
            anchors {
                top: parent.top;
                topMargin: vpx(20);
                left: parent.left;
                leftMargin: vpx(70);
                right: parent.right;
                rightMargin: vpx(10);
            }
            imageSource: imgScreenshot;
        }

        Media.GameVideo {
            id: gameListVideo;

            height: parent.height - gameListBoxart.height * .95 - vpx(10);
            anchors {
                top: parent.top;
                topMargin: vpx(20);
                left: parent.left;
                leftMargin: vpx(70);
                right: parent.right;
                rightMargin: vpx(10);
            }
            settingKey: 'gameListVideo';
            validView: 'gameList';

            onVideoToggled: {
                gameListScreenshot.videoPlaying = videoPlaying;
            }
        }

        /*Rectangle {
            height: parent.height * .4;
            width: parent.width * .4;
            anchors {
                left: parent.left;
                leftMargin: vpx(50);
                bottom: parent.bottom;
                bottomMargin: vpx(20);
            }
            color: 'transparent'; border.color: 'magenta';
        }*/

        Media.GameImage {
            id: gameListBoxart;

            height: parent.height * .4;
            width: parent.width * .4;
            anchors {
                left: parent.left;
                leftMargin: vpx(50);
                bottom: parent.bottom;
                bottomMargin: vpx(20);
            }
            imageSource: imgBoxFront;
            alignment: Image.AlignLeft;
        }

        Rectangle {
            color: 'transparent';
            anchors {
                top: gameListScreenshot.bottom;
                topMargin: vpx(20);
                left: gameListBoxart.right;
                leftMargin: vpx(20);
                right: parent.right;
                rightMargin: vpx(20);
                bottom: parent.bottom;
                bottomMargin: vpx(20);
            }
            Text {
                id: genre;
                text: genreText;

                color: theme.current.detailsColor;
                opacity: .7;
                elide: Text.ElideRight;
                maximumLineCount: 2;
                wrapMode: Text.WordWrap;
                horizontalAlignment: Text.AlignHCenter;

                font {
                    family: glyphs.name;
                    pixelSize: parent.height * .125 * theme.fontScale;
                    bold: true;
                }

                width: parent.width;
                anchors {
                    bottom: lastPlayed.top;
                }
            }

            Text {
                id: lastPlayed;
                text: lastPlayedText;

                color: theme.current.detailsColor;
                opacity: .5;
                elide: Text.ElideRight;
                maximumLineCount: 1;
                horizontalAlignment: Text.AlignHCenter;

                font {
                    family: glyphs.name;
                    pixelSize: parent.height * .11 * theme.fontScale;
                    bold: false;
                }

                width: parent.width;
                anchors {
                    bottom: playTime.top;
                    //bottomMargin: parent.height * .25;
                }
            }

            Text {
                id: playTime;
                text: playTimeText;

                color: theme.current.detailsColor;
                opacity: .5;
                elide: Text.ElideRight;
                maximumLineCount: 1;
                horizontalAlignment: Text.AlignHCenter;

                font {
                    family: glyphs.name;
                    pixelSize: parent.height * .09 * theme.fontScale;
                    bold: false;
                }

                width: parent.width;
                anchors {
                    bottom: parent.bottom;
                    bottomMargin: parent.height * .25;
                }
            }
        }

    }
}

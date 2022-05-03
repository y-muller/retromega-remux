import QtQuick 2.15
import QtGraphicalEffects 1.12

import '../footer' as Footer
import '../header' as Header
import '../media' as Media

Item {
    anchors.fill: parent;
    property bool fullDescriptionShowing: false;

    function onCancelPressed() {
        if (currentCollection.shortName === 'favorites' || onlyFavorites === true) {
            updateGameIndex(currentGameIndex, true);
        }

        currentView = 'gameList';
        sounds.back();
    }

    function onAcceptPressed() {
        sounds.launch();
        currentGame.launch();
    }

    function onFiltersPressed() {
        currentGame.favorite = !currentGame.favorite;
        sounds.nav();
    }

    function detailsButtonClicked(button) {
        switch (button) {
            case 'play':
                onAcceptPressed();
                break;

            case 'favorite':
                onFiltersPressed();
                break;

        }
    }

    Keys.onUpPressed: {
        event.accepted = true;
        const updated = updateGameIndex(currentGameIndex - 1);
        if (updated) {
            sounds.nav();
            video.switchVideo();
            fullDescription.resetFlickable();
        }
    }

    Keys.onDownPressed: {
        event.accepted = true;
        const updated = updateGameIndex(currentGameIndex + 1);
        if (updated) {
            sounds.nav();
            video.switchVideo();
            fullDescription.resetFlickable();
        }
    }

    Keys.onPressed: {
        if (api.keys.isCancel(event)) {
            event.accepted = true;
            onCancelPressed();
        }

        if (api.keys.isAccept(event)) {
            event.accepted = true;
            onAcceptPressed();
        }

        if (api.keys.isDetails(event)) {
            event.accepted = true;
            onDetailsPressed();
        }

        if (api.keys.isFilters(event)) {
            event.accepted = true;
            onFiltersPressed();
        }
        if (api.keys.isPageDown(event)) {
            event.accepted = true;
            fullDescription.scrollDown();
        }
        if (api.keys.isPageUp(event)) {
            event.accepted = true;
            fullDescription.scrollUp();
        }
    }

    property alias video: gameDetailsVideo;

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

    property string imgSrc: {
        if (currentGame === null) return '';
        return currentGame.assets.screenshot;
    }

    property string favoriteGlyph: {
        if (currentGame === null) return '';
        if (currentGame.favorite) return glyphs.favorite;
        return glyphs.unfavorite;
    }

    property string titleText: {
        if (currentGame === null) return '';
        return currentGame.title;
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

    Component.onCompleted: {
        gameDetailsVideo.switchVideo();
        settings.addCallback('gameDetailsVideo', function () {
            gameDetailsVideo.switchVideo();
        });
    }


    Rectangle {
        color: theme.current.bgColor;
        anchors {
            top: parent.top;
            bottom: detailsFooter.top;
            left: parent.left;
            right: parent.right;
        }

        Rectangle {
            id: titleBlock
            color: 'transparent';
            height: root.height * .115 * theme.fontScale;

            anchors {
                left: parent.left;
                right: parent.right;
                top: parent.top;
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
        
            Text {
                id: title;

                maximumLineCount: 1;
                text: titleText;
                color: theme.current.detailsColor;
                elide: Text.ElideRight;

                width: parent.width - 100;
                anchors {
                    left: parent.left;
                    leftMargin: vpx(32);
                    verticalCenter: parent.verticalCenter;
                }

                font {
                    pixelSize: parent.height * .33;
                    letterSpacing: -0.3;
                    bold: true;
                }
            }

            Text {
                id: favourite;

                text: favoriteGlyph;
                color: theme.current.detailsColor;

                font {
                    family: glyphs.name;
                    pixelSize: parent.height * .5;
                }

                anchors {
                    right: parent.right;
                    rightMargin: vpx(32);
                    verticalCenter: parent.verticalCenter;
                }

                horizontalAlignment: Text.AlignRight;

                MouseArea {
                    anchors.fill: parent;

                    onClicked: {
                        detailsButtonClicked('favorite');
                    }
                }

            }
        }

        GameMetadata {
            id: gamedata;
            
            width: parent.width * .4 - vpx(50);
            pixelSize: parent.height * .055;

            anchors {
                top: titleBlock.bottom;
                topMargin: vpx(25);
                /*bottom: detailsDivider.top;*/
                bottomMargin: vpx(25);
                left: parent.left;
                leftMargin: vpx(25);
            }
        }

    /*   Rectangle {
            color: 'teal';
            opacity: 0.3;

            height: parent.height * .6;
            anchors {
                //top: titleBlock.bottom;
                //topMargin: 10;
                bottom: parent.bottom;
                //bottomMargin: 2;
                left: parent.left;
                right: detailsDivider.left;
            }
        }
    */

        Media.GameImage {
            id: gameDetailsScreenshot;

            imageSource: imgSrc;

            height: parent.height * .6;
            anchors {
                bottom: parent.bottom;
                left: parent.left;
                right: detailsDivider.left;
            }

        }

        Media.GameVideo {
            id: gameDetailsVideo;

            height: parent.height * .6;
            anchors {
                bottom: parent.bottom;
                left: parent.left;
                right: detailsDivider.left;
            }

            settingKey: 'gameDetailsVideo';
            validView: 'gameDetails';

            onVideoToggled: {
                gameDetailsScreenshot.videoPlaying = videoPlaying;
            }
        }

        /* Vertical divider between info and description */
        Rectangle {
            id: detailsDivider;

            color: theme.current.dividerColor;

            width: 1;
            x: parent.width * .4;
            anchors {
                top: titleBlock.bottom;
                topMargin: 22;
                bottom: parent.bottom
                bottomMargin: 22;
            }
        }

        /* Vertical pane with rating, players, date */
        VerticalPane {
            id: verticalPane;

            width: vpx(50);
            anchors {
                top: titleBlock.bottom;
                topMargin: vpx(10);
                bottom: parent.bottom;
                bottomMargin: vpx(10);
                right: parent.right;
                rightMargin: vpx(22);
            }

            Behavior on anchors.topMargin {
                PropertyAnimation { easing.type: Easing.OutCubic; duration: 200  }
            }
        }

        /* Description pane, scrollable */
        GameDescription {
            id: fullDescription;

            anchors {
                top: titleBlock.bottom;
                topMargin: vpx(20);
                left: detailsDivider.right;
                leftMargin: vpx(20);
                right: verticalPane.left;
                rightMargin: vpx(20);
                bottom: parent.bottom;
                bottomMargin: vpx(20);
            }

            Behavior on anchors.topMargin {
                PropertyAnimation { easing.type: Easing.OutCubic; duration: 200  }
            }
        }
    }

    Footer.Component {
        id: detailsFooter;

        total: 0;

        buttons: [
            { title: 'Play', key: 'A', square: false, sigValue: 'accept' },
            { title: 'Back', key: 'B', square: false, sigValue: 'cancel' },
            { title: 'Favorite', key: 'Y', square: false, sigValue: 'filters' },
        ];

        onFooterButtonClicked: {
            if (sigValue === 'accept') onAcceptPressed();
            if (sigValue === 'cancel') onCancelPressed();
            if (sigValue === 'filters') onFiltersPressed();
            if (sigValue === 'details') onDetailsPressed();
        }
    }

}

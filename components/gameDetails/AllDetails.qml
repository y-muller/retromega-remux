import QtQuick 2.15
import QtGraphicalEffects 1.12

import '../media' as Media

Item {
    property alias video: gameDetailsVideo;

    // get rid of newlines for the short description
    // also some weird kerning on periods and commas for some reason
    property var introDescText: {
        if (currentGame === null) return '';

        return currentGame.description
            .replace(/\n/g, ' ')
            .replace(/ {2,}/g, ' ')
            .replace(/\. {1,}/g, '.  ')
            .replace(/, {1,}/g, ',  ');
    }

    property var hasMoreButton: {
        if (currentGame === null) return false;
        if (currentGame.description) return true;
        return false;
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
                leftMargin: 32;
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
                pixelSize: parent.height * .33;
            }

            anchors {
                right: parent.right;
                rightMargin: 32;
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
        
        width: parent.width / 2 - 50;
        pixelSize: parent.height * .055;

        anchors {
            top: titleBlock.bottom;
            topMargin: 25;
            /*bottom: detailsDivider.top;*/
            bottomMargin: 25;
            left: parent.left;
            leftMargin: 25;
        }
    }

/*    Text {
        id: rating;
        
        text: ratingText;
        color: theme.current.detailsColor;
        opacity: 0.7;
        verticalAlignment: Text.AlignBottom;
        horizontalAlignment: Text.AlignHCenter;

        height: 500;
        width: 100;
        anchors {
            top: parent.top;
            bottomMargin: 2;
            right: parent.right;
        }

        font {
            family: glyphs.name;
            pixelSize: parent.height * .04;
        }
        
        transform: Rotation { angle: 90 }
    }
*/

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
            //topMargin: 2;
            bottom: parent.bottom;
            //bottomMargin: 2;
            left: parent.left;
            right: detailsDivider.left;
            //leftMargin: 2;
        }

    }

    Media.GameVideo {
        id: gameDetailsVideo;

        height: parent.height * .6;
        anchors {
            //topMargin: 2;
            bottom: parent.bottom;
            //bottomMargin: 2;
            left: parent.left;
            right: detailsDivider.left;
            //leftMargin: 2;
        }

        settingKey: 'gameDetailsVideo';
        validView: 'gameDetails';

        onVideoToggled: {
            gameDetailsScreenshot.videoPlaying = videoPlaying;
        }
    }

    Rectangle {
        id: detailsDivider;

        color: theme.current.dividerColor;

        width: 1;
        x: parent.width / 2;
        anchors {
            top: titleBlock.bottom;
            topMargin: 22;
            bottom: parent.bottom
            bottomMargin: 22;
        }
    }

    Rectangle {
        id: verticalPane;
 
        color: 'transparent'
       
        width: 40;
        anchors {
            top: titleBlock.bottom;
            topMargin: 10;
            bottom: parent.bottom;
            bottomMargin: 10;
            right: parent.right;
        }

        Text {
            text: ratingText;

            color: theme.current.detailsColor;
            opacity: 0.7;
            verticalAlignment: Text.AlignTop;
            horizontalAlignment: Text.AlignLeft;

            font {
                family: glyphs.name;
                pixelSize: parent.height * .05;
            }
            
            transform: Rotation { origin.x: 0; origin.y: 0; angle: 90 }
 
            //y: verticalPane.height * 0.05;
            anchors {
                left: verticalPane.right;
                leftMargin: -10;
                top: verticalPane.top;
                topMargin: 5;
                //right: verticalPane.right;
                //bottom: verticalPane.bottom;
            }
       
        }

        Text {
            text: playersText;

            color: theme.current.detailsColor;
            opacity: 0.7;
            //verticalAlignment: Text.AlignBottom;
            //horizontalAlignment: Text.AlignHCenter;

            font {
                family: glyphs.name;
                pixelSize: parent.height * .06;
                bold: true;
            }
            
            transform: Rotation { origin.x: 0; origin.y: 0; angle: 270 }

            //x: verticalPane.width  1;
            y: verticalPane.height * 0.65;
            anchors {
                left: verticalPane.left;
                leftMargin: 10;
                //right: verticalPane.right;
                //bottom: verticalPane.bottom;
            }
        
        }

        Text {
            text: releaseDateText;

            color: theme.current.detailsColor;
            opacity: 0.7;
            //verticalAlignment: Text.AlignBottom;
            //horizontalAlignment: Text.AlignHCenter;

            font {
                family: glyphs.name;
                pixelSize: parent.height * .06;
                bold: true;
            }
            
            transform: Rotation { origin.x: 0; origin.y: 0; angle: 270 }

            //x: verticalPane.width  1;
            y: verticalPane.height ;
            anchors {
                left: verticalPane.left;
                leftMargin: 10;
                //right: verticalPane.right;
                //bottom: verticalPane.bottom;
            }
        
        }

    }

    GameDescription {
        id: fullDescription;

        anchors {
            top: titleBlock.bottom;
            left: detailsDivider.right;
            right: verticalPane.left;
            bottom: parent.bottom;

        }

        Behavior on anchors.topMargin {
            PropertyAnimation { easing.type: Easing.OutCubic; duration: 200  }
        }
    }

/*
    MoreButton {
        pixelSize: parent.height * .04 * theme.fontScale;
        visible: hasMoreButton;

        anchors {
            right: parent.right;
            rightMargin: 30;
            bottom: introDesc.bottom;
            bottomMargin: parent.height * .01;
        }
    }
*/
}

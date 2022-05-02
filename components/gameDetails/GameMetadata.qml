import QtQuick 2.15
import QtGraphicalEffects 1.12

Item {
    property double pixelSize;


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
        if (isNaN(lastPlayed)) return '';

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

/*    property string releaseDateText: {
        if (currentGame === null) return '';
        if (!currentGame.releaseYear) return '';
        return currentGame.releaseYear;
    }*/

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

    property var metadataSpacing: {
        if (title.lineCount > 1 && metadataText.length > 3) return 4;
        return 8;
    }

    property var metadataText: {
        const texts = [genreText, developedByText, lastPlayedText];
        return texts.filter(v => { return v !== null })
            .filter(v => { return v !== '' });
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

/*    Text {
        id: title;

        width: parent.width;
        wrapMode: Text.WordWrap;
        maximumLineCount: 2;
        text: titleText;
        color: theme.current.detailsColor;
        elide: Text.ElideRight;

        font {
            pixelSize: pixelSize;
            letterSpacing: -0.35;
            bold: true;
        }

        anchors {
            left: parent.left;
            top: parent.top;
        }
    }
*/

    Column {
        id: metadata;

        spacing: metadataSpacing;
        width: parent.width;

        anchors {
            top: parent.top;
            topMargin: 8;
        }

        Repeater {
            model: metadataText;

            Text {
                text: modelData;
                color: theme.current.detailsColor;
                opacity: 0.5;
                width: parent.width;
                elide: Text.ElideRight
                maximumLineCount: 1;

                font {
                    pixelSize: pixelSize * .75;
                    letterSpacing: -0.35;
                    bold: true;
                }
            }
        }
    }
}
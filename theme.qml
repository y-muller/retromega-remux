import QtQuick 2.15

import 'components/collectionList' as CollectionList
import 'components/gameList' as GameList
import 'components/resources' as Resources

// todo list:
//   [x] system list
//     [x] controller support
//     [x] break up systemscroll.qml
//     [x] # of total in footer
//     [x] rename all 'system' to collection
//     [x] touch support
//     [x] better system name font spacing
//   [o] game list
//     [x] rounded boxart
//     [x] # of total in footer
//     [x] system title in header
//     [x] controller support
//     [x] touch support
//     [o] verify things work when picking multi disk game, but cancelling.
//   [x] footer
//     [x] buttons
//     [x] # of total label
//   [x] header
//     [x] real time battery
//     [x] real time clock
//     [x] tap to switch 24 hour
//     [x] system title with color
//   [o] navigation sounds
//     [x] double sound when going back from game view
//     [x] double sound when navigating after coming back from game view
//     [ ] double sound when starting the theme
//   [o] bg music
//     [x] random playlist
//     [o] suspend on power off
//     [ ] button to start/stop
//   [ ] system colors
//     [ ] make sure they are dark enough
//     [ ] remove duplicates
//   [ ] random select
//   [ ] new collections
//     [ ] ps2
//     [ ] wii
//     [ ] all
//     [ ] favorites
//     [ ] recents
//      https://www.vhv.rs/viewpic/ThTTbhi_wii-controller-hd-png-download/
//      https://www.vhv.rs/viewpic/ThTbhoR_wii-png-download-wii-mario-kart-controller-png/
//      https://www.vhv.rs/viewpic/iibbTRi_transparent-wii-controller-png-wii-classic-controller-pro/
//   [ ] update readme
//   [ ] remove 640x480 from theme.qml
//   [ ] enable game launch

//   [ ] bg music
//     [ ] better way to generate the playlist from files
//   [ ] all/favorites/recents/apps collections
//   [ ] zoomed out system view
//   [ ] game list
//     [ ] white heart on favorites when highlighted
//     [ ] scrolling text instead of elipses
//     [ ] more thematic experience for multi-disk games
//     [ ] use DropShadow instead of image for boxart
//   [ ] game detail view
//   [ ] alphabetic index
//   [ ] filter/sort modal
//   [ ] touch
//   [ ] dark mode
//   [ ] filterable android apps

FocusScope {
    property string currentView: 'collectionList';
    property var bgMusicEnabled: true;
    property var bgMusicSuspended: false;
    property int currentCollectionIndex: 0;
    property var currentCollection;
    property int currentGameIndex: 0;
    property var currentGame;

    Component.onCompleted: {
        currentView = api.memory.get('currentView') ?? 'collectionList';

        currentCollectionIndex = api.memory.get('currentCollectionIndex') ?? 0;
        currentCollection = api.collections.get(currentCollectionIndex);

        currentGameIndex = api.memory.get('currentGameIndex') ?? 0;
        currentGame = currentCollection.games.get(currentGameIndex);

        sounds.startSound.play();

        bgMusicEnabled = api.memory.get('bgMusicEnabled') ?? true;
        if (music.count > 0 && bgMusicEnabled) {
            music.shuffle();
            music.play();
        }
    }

    Component.onDestruction: {
        api.memory.set('currentView', currentView);
        api.memory.set('currentCollectionIndex', currentCollectionIndex);
        api.memory.set('currentGameIndex', currentGameIndex);
        api.memory.set('bgMusicEnabled', bgMusicEnabled);
    }

    Resources.CollectionData { id: collectionData; }
    function collectionColor(shortName) {
        return collectionData.colors[shortName] ?? collectionData.colors['default'];
    }
    function collectionCompany(shortName) {
        return collectionData.companies[shortName] ?? '';
    }

    Resources.Sounds { id: sounds; }
    Resources.Music { id: music; }

    Connections {
        target: Qt.application;
        function onStateChanged() {
            if (!bgMusicEnabled) return;

            if (Qt.application.state === Qt.ApplicationActive) {
                if (!bgMusicSuspended) return;

                music.play();
                bgMusicSuspended = false;
            } else {
                if (bgMusicSuspended) return;

                music.pause();
                bgMusicSuspended = true;
            }
        }
    }

    Rectangle {
        /* x: 200; */
        width: 640;
        height: 480;

        CollectionList.Component {
            visible: currentView === 'collectionList';
            focus: currentView === 'collectionList';
        }

        GameList.Component {
            visible: currentView === 'gameList';
            focus: currentView === 'gameList';
        }

        Rectangle {
            x: 100;
            y: 100;
            width: debug.width + 10;
            height: debug.height + 10;

            color: 'black';
            border.color: 'white';

            Text {
                id: debug;

                text: 'debug';
                color: 'magenta';
                anchors.centerIn: parent;
            }
        }
    }
}

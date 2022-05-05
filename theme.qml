import QtQuick 2.15
import SortFilterProxyModel 0.2
import QtQml.Models 2.15

import 'components/collectionList' as CollectionList
import 'components/gameList' as GameList
import 'components/gameDetails' as GameDetails
import 'components/settings' as Settings
import 'components/resources' as Resources
import 'components/themes' as Themes
import 'components/sorting' as Sorting

FocusScope {
    id: root;

    property string currentView: 'collectionList';
    property string previousView: 'collectionList';
    property var currentViewCallbacks: [];

    property int currentCollectionIndex: -1;
    property var currentCollection;
    property var currentGameList;
    property int currentGameIndex: -1;
    property var currentGame;

    property bool onlyFavorites: false;
    property string sortKey: 'sortBy';
    property var sortDir: Qt.AscendingOrder;
    /* property string nameFilter: ''; */

    function addCurrentViewCallback(callback) {
        currentViewCallbacks.push(callback);
    }

    onCurrentViewChanged: {
        for (let i = 0; i < currentViewCallbacks.length; i++) {
            currentViewCallbacks[i](currentView);
        }
    }

    function clamp(min, val, max) {
        return Math.max(0, Math.min(val, max));
    }

    function wrap(min, val, max) {
        if(val < 0)
            return max;
        else if(val > max)
            return 0;
        return val;
    }

    function updateCollectionIndex(newIndex, skipCollectionListUpdate = false) {
        const boundedIndex = (settings.get('listWrapAround'))
                           ? wrap(0, newIndex, allCollections.length - 1)
                           : clamp(0, newIndex, allCollections.length - 1);

        if (boundedIndex === currentCollectionIndex) return false;

        currentCollectionIndex = boundedIndex;
        currentCollection = allCollections[currentCollectionIndex];

        if (currentCollection.shortName === 'favorites') {
            currentGameList = allFavorites;
        } else if (currentCollection.shortName === 'recents') {
            currentGameList = filterLastPlayed;
        } else {
            currentGameList = sortedCollection;
        }

        updateGameIndex(0, true);

        // this prevents a circular update loop if we're updating from dragging the collection list
        if (!skipCollectionListUpdate) {
            collectionList.updateIndex(currentCollectionIndex);
        }

        return true;
    }

    function updateGameIndex(newIndex, forceUpdate = false) {
        //let moveAnimation = false;
        const boundedIndex = (settings.get('listWrapAround'))
                           ? wrap(0, newIndex, currentGameList.count - 1)
                           : clamp(0, newIndex, currentGameList.count - 1);

        if (!forceUpdate && boundedIndex === currentGameIndex) return false;

        const moveAnimation = ((Math.abs(currentGameIndex-boundedIndex) === currentGameList.count - 1) && (currentGameList.count > 2))
                           ? true : false;

        currentGameIndex = boundedIndex;
        currentGame = getMappedGame(currentGameIndex);
        gameList.updateIndex(currentGameIndex, moveAnimation);

        return true;
    }


    // code to handle reading and writing api.memory
    Component.onCompleted: {
        currentView = api.memory.get('currentView') ?? 'collectionList';

        onlyFavorites = api.memory.get('onlyFavorites') ?? false;
        sortKey = api.memory.get('sortKey') ?? 'sortBy';
        sortDir = api.memory.get('sortDir') ?? Qt.AscendingOrder;
        /* nameFilter = api.memory.get('nameFilter') ?? ''; */

        updateCollectionIndex(api.memory.get('currentCollectionIndex') ?? -1);
        updateGameIndex(api.memory.get('currentGameIndex') ?? -1, true);

        // this is done in here to prevent a quick flash of light mode
        theme.setDarkMode(settings.get('darkMode'));
        theme.setFontScale(settings.get('smallFont'));

        sounds.start();
        
        /*
        let challenges = [
            { id: "rh_gotw", name: "Retro Bits", slots: 1, logo: "rh_gotw.png" },
            { id: "rh_gotm", name: "Games of the Month", slots: 3, logo: "rh_gotm.png" },
        ];
        api.memory.set('challenges', challenges);
        let challengeGames = [
            { challenge: "rh_gotw", slot: 1, file: "/home/yann/ROMs/pcengine/Soldier Blade (U).pce" },
            { challenge: "rh_gotm", slot: 1, file: "/home/yann/ROMs/snes/Super Ghouls 'N Ghosts (E).smc" },
            { challenge: "rh_gotm", slot: 2, file: "/home/yann/ROMs/pcengine/OutRun (J).pce" },
        ];
        api.memory.set('challengeGames', challengeGames);
        //let challengeGamesFromCollection = [];
        for( var i = 0; i < api.allGames.rowCount(); i++ ) {
            for( var j = 0; j < challengeGames.length; j++ ) {
                if( api.allGames.get(i).files.get(0).path === challengeGames[j].file ) {
                    console.log( "FOUND  " + challengeGames[j].file );
                    //challengeGamesFromCollection[j] = api.allGames.get(i);
                    //challengesModel.append( api.allGames.get(i) );                    
                    console.log( "before: " + api.allGames.get(i).challenge );
                    api.allGames.get(i).challenge = challengeGames[j].challenge;
                    console.log( "after: " + api.allGames.get(i).challenge );
                }
            }
        }
         */
    }

    Component.onDestruction: {
        api.memory.set('currentView', currentView);
        api.memory.set('currentCollectionIndex', currentCollectionIndex);
        api.memory.set('currentGameIndex', currentGameIndex);

        api.memory.set('onlyFavorites', onlyFavorites);
        api.memory.set('sortKey', sortKey);
        api.memory.set('sortDir', sortDir);
        /* api.memory.set('nameFilter', nameFilter); */

        settings.saveAll();
    }

    property var challenges: [
        { id: "rh_gotw", name: "Retro Bits", slots: 1, logo: "rh_gotw.png" },
        { id: "rh_gotm", name: "Games of the Month", slots: 3, logo: "rh_gotm.png" },
    ];

    property var challengeGames: [
        { challenge: "rh_gotw", slot: 1, file: "/home/yann/ROMs/pcengine/Soldier Blade (U).pce" },
        { challenge: "rh_gotm", slot: 1, file: "/home/yann/ROMs/snes/Super Ghouls 'N Ghosts (E).smc" },
        { challenge: "rh_gotm", slot: 2, file: "/home/yann/ROMs/pcengine/OutRun (J).pce" },
    ];

/*
    property var challengesProcessed: {
        console.log("processing challenges");
        let challenges = [
            { id: "rh_gotw", name: "Retro Bits", slots: 1, logo: "rh_gotw.png" },
            { id: "rh_gotm", name: "Games of the Month", slots: 3, logo: "rh_gotm.png" },
        ];
        //api.memory.set('challenges', challenges);
        let challengeGames = [
            { challenge: "rh_gotw", slot: 1, file: "/home/yann/ROMs/pcengine/Soldier Blade (U).pce" },
            { challenge: "rh_gotm", slot: 1, file: "/home/yann/ROMs/snes/Super Ghouls 'N Ghosts (E).smc" },
            { challenge: "rh_gotm", slot: 2, file: "/home/yann/ROMs/pcengine/OutRun (J).pce" },
        ];
        //api.memory.set('challengeGames', challengeGames);
        //let challengeGamesFromCollection = [];
        for( var i = 0; i < api.allGames.rowCount(); i++ ) {
            for( var j = 0; j < challengeGames.length; j++ ) {
                if( api.allGames.get(i).files.get(0).path === challengeGames[j].file ) {
                    console.log( "FOUND  " + challengeGames[j].file );
                    //challengeGamesFromCollection[j] = api.allGames.get(i);
                    //challengesModel.append( api.allGames.get(i) );                    
                    console.log( "before: " + api.allGames.get(i).challenge );
                    api.allGames.get(i).challenge = challengeGames[j].challenge;
                    //api.allGames.set(i, 'challenge', challengeGames[j].challenge );
                    console.log( "after: " + api.allGames.get(i).challenge );
                }
            }
        }
        return api.allGames;
    }
*/

    // code to handle collection modification
    property var allCollections: {
        const collections = api.collections.toVarArray();

        collections.unshift({'name': 'Favorites', 'shortName': 'favorites', 'games': allFavorites});
        collections.unshift({'name': 'Last Played', 'shortName': 'recents', 'games': filterLastPlayed});
        collections.unshift({'name': 'All Games', 'shortName': 'allgames', 'games': api.allGames});
        collections.unshift({'name': 'Challenges', 'shortName': 'challenges', 'games': allChallenges});

        return collections;
    };

    function getMappedGame(index) {
        if (currentCollection.shortName === 'favorites') {
            return api.allGames.get(allFavorites.mapToSource(index));
        } else if (currentCollection.shortName === 'recents') {
            return api.allGames.get(filterLastPlayed.mapToSource(index));
        } else if (currentCollection.shortName === 'challenges') {
            return api.allGames.get(allChallenges.mapToSource(index));
        } else {
            return currentCollection.games.get(sortedCollection.mapToSource(index));
        }
    }

    SortFilterProxyModel {
        id: allChallenges;

        sourceModel: api.allGames;
        filters: [
            ExpressionFilter {
                expression: {
                    for( var j = 0; j < challengeGames.length; j++ ) {
                        if( files.get(0).path === challengeGames[j].file ) {
                            return true;
                        }
                    }
                    return false;
                }
            }
        ]
    }

    SortFilterProxyModel {
        id: allFavorites;

        sourceModel: api.allGames;
        filters: [
            ValueFilter { roleName: 'favorite'; value: true; }
        ]
        sorters: RoleSorter { roleName: sortKey; sortOrder: sortDir }
    }

    SortFilterProxyModel {
        id: filterLastPlayed;

        sourceModel: api.allGames;
        filters: [
            ValueFilter { roleName: 'favorite'; value: true; enabled: onlyFavorites; },
            ValueFilter { roleName: 'lastPlayed'; value: ''; inverted: true; },
            /* RegExpFilter { roleName: 'title'; pattern: nameFilter; caseSensitivity: Qt.CaseInsensitive; enabled: nameFilter !== ''; }, */
            IndexFilter { maximumIndex: 24; }
        ]
        sorters: RoleSorter { roleName: 'lastPlayed'; sortOrder: Qt.DescendingOrder; }
    }

    SortFilterProxyModel {
        id: sortedCollection;

        sourceModel: currentCollection.games;
        sorters: RoleSorter { roleName: sortKey; sortOrder: sortDir }
        filters: [
            ValueFilter { roleName: 'favorite'; value: true; enabled: onlyFavorites; }
            /* RegExpFilter { roleName: 'title'; pattern: nameFilter; caseSensitivity: Qt.CaseInsensitive; enabled: nameFilter !== ''; } */
        ]
    }


    // data components
    Settings.Handler { id: settings; }
    Themes.Handler { id: theme; }
    Resources.CollectionData { id: collectionData; }
    Resources.Sounds { id: sounds; }
    Resources.Music { id: music; }
    Sorting.Handler { id: sorting; }

    FontLoader {
        id: glyphs;

        property string favorite: '\ue805';
        property string unfavorite: '\ue802';
        property string settings: '\uf1de';
        property string enabled: '\ue800';
        property string disabled: '\uf096';
        property string play: '\ue801';
        property string ascend: '\uf160';
        property string descend: '\uf161';
        property string fullStar: '\ue803';
        property string halfStar: '\uf123';
        property string emptyStar: '\ue804';

        source: "assets/images/fontello.ttf";
    }


    // ui components
    CollectionList.Component {
        id: collectionList;

        visible: currentView === 'collectionList';
        focus: currentView === 'collectionList';
    }

    GameList.Component {
        id: gameList;

        visible: currentView === 'gameList';
        focus: currentView === 'gameList';
    }

    GameDetails.Component {
        visible: currentView === 'gameDetails';
        focus: currentView === 'gameDetails';
    }

    Settings.Component {
        visible: currentView === 'settings';
        focus: currentView === 'settings';
    }

    Sorting.Component {
        visible: currentView === 'sorting';
        focus: currentView === 'sorting';
    }

    /* Text { id: debug; x: 20; y: 20; width: 20; height: 20; text: 'debug'; } */
    /* Rectangle { width: 640; height: 480; color: 'transparent'; border.color: 'magenta'; } */
    /* Rectangle { width: 1280; height: 720; color: 'transparent'; border.color: 'magenta'; } */
}

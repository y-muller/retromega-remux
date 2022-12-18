import QtQuick 2.15

import '../footer' as Footer
import '../header' as Header

import '../media' as Media

Item {
    property alias recentRAGamesListView: recentRAGamesListView;

    anchors.fill: parent;

    //property string responseUserSummary: '{"RecentlyPlayedCount":5,"RecentlyPlayed":[{"GameID":"449","ConsoleID":"3","ConsoleName":"SNES","Title":"Breath of Fire","ImageIcon":"\/Images\/008646.png","LastPlayed":"2022-12-11 15:31:16"},{"GameID":"11261","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Klonoa: Door to Phantomile","ImageIcon":"\/Images\/026636.png","LastPlayed":"2022-12-08 09:41:41"},{"GameID":"12900","ConsoleID":"25","ConsoleName":"Atari 2600","Title":"Enduro","ImageIcon":"\/Images\/050442.png","LastPlayed":"2022-12-02 10:56:19"},{"GameID":"6100","ConsoleID":"5","ConsoleName":"Game Boy Advance","Title":"Activision Anthology","ImageIcon":"\/Images\/008750.png","LastPlayed":"2022-12-01 17:10:33"},{"GameID":"14601","ConsoleID":"53","ConsoleName":"WonderSwan","Title":"Kaze no Klonoa: Moonlight Museum","ImageIcon":"\/Images\/049923.png","LastPlayed":"2022-11-30 21:48:37"}],"MemberSince":"2019-01-14 23:15:39","LastActivity":{"ID":"55465970","timestamp":"2022-12-11 15:31:16","lastupdate":"2022-12-11 15:31:16","activitytype":"3","User":"RedSideOfTheMoon","data":"449","data2":null},"RichPresenceMsg":"Playing Breath of Fire","LastGameID":"449","LastGame":{"ID":449,"Title":"Breath of Fire","ConsoleID":3,"ForumTopicID":15632,"Flags":0,"ImageIcon":"\/Images\/008646.png","ImageTitle":"\/Images\/002114.png","ImageIngame":"\/Images\/051037.png","ImageBoxArt":"\/Images\/063501.png","Publisher":"Squaresoft","Developer":"Capcom","Genre":"","Released":"1993","IsFinal":false,"ConsoleName":"SNES","RichPresencePatch":""},"ContribCount":"0","ContribYield":"0","TotalPoints":"306","TotalSoftcorePoints":"2113","TotalTruePoints":"563","Permissions":"1","Untracked":"0","ID":"87771","UserWallActive":"1","Motto":"All is red here.","Rank":30066,"Awarded":{"449":{"NumPossibleAchievements":"63","PossibleScore":"625","NumAchieved":"23","ScoreAchieved":"166","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},"11261":{"NumPossibleAchievements":"47","PossibleScore":"516","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},"12900":{"NumPossibleAchievements":"20","PossibleScore":"182","NumAchieved":"11","ScoreAchieved":"37","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},"6100":{"NumPossibleAchievements":"44","PossibleScore":"520","NumAchieved":"1","ScoreAchieved":"25","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},"14601":{"NumPossibleAchievements":"59","PossibleScore":"580","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0}},"RecentAchievements":{"12900":{"73678":{"ID":"73678","GameID":"12900","GameTitle":"Enduro","Title":"Top speed","Description":"Reach 120 Mph","Points":"5","BadgeName":"79103","IsAwarded":"1","DateAwarded":"2022-12-02 11:59:46","HardcoreAchieved":"0"},"65115":{"ID":"65115","GameID":"12900","GameTitle":"Enduro","Title":"Getting Serious!","Description":"Beat the third day.","Points":"5","BadgeName":"68245","IsAwarded":"1","DateAwarded":"2022-12-02 11:19:54","HardcoreAchieved":"0"},"73677":{"ID":"73677","GameID":"12900","GameTitle":"Enduro","Title":"Speed Racer","Description":"Reach 100 Mph and keep it for 3 seconds","Points":"3","BadgeName":"79104","IsAwarded":"1","DateAwarded":"2022-12-02 11:14:57","HardcoreAchieved":"0"},"65113":{"ID":"65113","GameID":"12900","GameTitle":"Enduro","Title":"That was just like training!","Description":"Beat the second day.","Points":"5","BadgeName":"68244","IsAwarded":"1","DateAwarded":"2022-12-02 11:09:34","HardcoreAchieved":"0"},"65110":{"ID":"65110","GameID":"12900","GameTitle":"Enduro","Title":"Green Flags!","Description":"Beat the first day.","Points":"1","BadgeName":"68241","IsAwarded":"1","DateAwarded":"2022-12-02 11:03:29","HardcoreAchieved":"0"},"65109":{"ID":"65109","GameID":"12900","GameTitle":"Enduro","Title":"Nightvision!","Description":"Finish a Night Section without crashing.","Points":"5","BadgeName":"68306","IsAwarded":"1","DateAwarded":"2022-12-02 11:02:08","HardcoreAchieved":"0"},"65105":{"ID":"65105","GameID":"12900","GameTitle":"Enduro","Title":"Snow Master","Description":"Finish a Snow Section witout crashing.","Points":"5","BadgeName":"68304","IsAwarded":"1","DateAwarded":"2022-12-02 11:00:22","HardcoreAchieved":"0"},"65107":{"ID":"65107","GameID":"12900","GameTitle":"Enduro","Title":"Fog Master","Description":"Finish a Fog Section witout crashing.","Points":"5","BadgeName":"68305","IsAwarded":"1","DateAwarded":"2022-11-28 20:25:04","HardcoreAchieved":"0"},"65106":{"ID":"65106","GameID":"12900","GameTitle":"Enduro","Title":"Foggy","Description":"Race in the fog.","Points":"1","BadgeName":"68239","IsAwarded":"1","DateAwarded":"2022-11-28 20:20:33","HardcoreAchieved":"0"}},"6100":{"33931":{"ID":"33931","GameID":"6100","GameTitle":"Activision Anthology","Title":"Roadbuster","Description":"(Enduro) Endure a race for 5 days or more.","Points":"25","BadgeName":"34938","IsAwarded":"1","DateAwarded":"2022-12-01 17:39:32","HardcoreAchieved":"0"}}},"Points":"306","SoftcorePoints":"2113","UserPic":"\/UserPic\/RedSideOfTheMoon.png","TotalRanked":32843,"Status":"Offline"}';
    
    property string pointsText: {
        //return recentRAGamesListView.count;
        if (cheevosData.hardcorePoints ===undefined || cheevosData.softcorePoints === undefined ) {
            return "Updating points...";
        }
        let totalPoints = cheevosData.hardcorePoints + cheevosData.softcorePoints;
        let ptsTxt = totalPoints + ' Points: ';
        if (cheevosData.hardcorePoints > cheevosData.softcorePoints) {
            ptsTxt += cheevosData.hardcorePoints + ' Hardcore points, ' + cheevosData.softcorePoints + ' Softcore points.';
        }
        else {
            ptsTxt += cheevosData.softcorePoints + ' Softcore points, ' + cheevosData.hardcorePoints + ' Hardcore points.';
        }
        return ptsTxt;
    }

    property double itemHeight: {
        return recentRAGamesListView.height * .125 * theme.fontScale;
    }

    function updateIndex(newIndex, moveAnimation=false) {
        if(moveAnimation)
            recentRAGamesListView.highlightMoveDuration = 225;
        recentRAGamesListView.currentIndex = newIndex;
        if(moveAnimation)
            recentRAGamesListView.highlightMoveDuration = 0;
    }

    Keys.onUpPressed: {
        event.accepted = true;
        const updated = updateRARecentGameIndex(currentRARecentGameIndex - 1);
        if (updated) { sounds.nav(); }
    }

    Keys.onDownPressed: {
        event.accepted = true;
        const updated = updateRARecentGameIndex(currentRARecentGameIndex + 1);
        if (updated) { sounds.nav(); }
    }

    function onAcceptPressed() {
        console.log( 'accept pressed' );
        console.log( 'index ' +  recentRAGamesListView.currentIndex );
    }

    function onCancelPressed() {
        currentView = previousView;
        sounds.back();
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
    }

    Rectangle {
        color: theme.current.bgColor;
        anchors.fill: parent;
    }

    Rectangle {
        id: userInfo;
        height: parent.height * .15;
        width: parent.width;
        anchors {
            top: cheevosHeader.bottom;
        }
        color: 'transparent'; //border.color: 'magenta';
        
        Media.GameImage {
            id: avatar;

            height: parent.height;
            width: parent.height;  // make it square
            anchors {
                top: parent.top;
                left: parent.left;
                bottom: parent.bottom;
                topMargin: vpx(20);
                leftMargin: vpx(20);
                bottomMargin: vpx(20);
            }
            imageSource: cheevosData.avatarUrl;
        }

        Text {
            id: username;
            text: cheevosData.userName;

            color: theme.current.detailsColor;
            opacity: .9;
            elide: Text.ElideRight;
            maximumLineCount: 1;
            font {
                pixelSize: parent.height * .27;
                letterSpacing: -0.3;
                bold: true;
            }
            anchors {
                top: parent.top;
                topMargin: vpx(23);
                left: avatar.right;
            }
        }
        Text {
            id: points;
            text: pointsText;

            color: theme.current.detailsColor;
            opacity: .7;
            elide: Text.ElideRight;
            maximumLineCount: 1;
            font {
                pixelSize: parent.height * .19;
                letterSpacing: -0.3;
                bold: false;
            }
            anchors {
                top: username.bottom;
                left: avatar.right;
            }
       }
    }

    Rectangle {
        color: 'transparent'; border.color: 'magenta';
        anchors {
            left: parent.left;
            right: parent.right;
            top: userInfo.bottom;
            bottom: cheevosFooter.top;
        }

        ListView {
            id: recentRAGamesListView;

            model: cheevosData.raRecentGames;
            delegate: lvRecentRAGamesDelegate;
            //width: (parent.width / 2) - 20; // 20 is left margin
            //height: parent.height - 24;
            highlightMoveDuration: 0;
            preferredHighlightBegin: itemHeight - 12; // height of an item minus top margin
            preferredHighlightEnd: parent.height - (itemHeight + 12); // height of an item plus bottom margin
            highlightRangeMode: ListView.ApplyRange;
            clip: true;

            anchors {
                left: parent.left;
                leftMargin: 20;
                right: parent.right;
                rightMargin: 20;
                top: parent.top;
                topMargin: 12;
                bottom: parent.bottom;
                bottomMargin: 12;
            }

            highlight: Rectangle {
                color: 'cyan'; //collectionData.getColor(currentShortName);
                opacity: theme.current.bgOpacity;
                radius: 8;
                width: recentRAGamesListView.width;
            }

            onCurrentIndexChanged: {
                //gameListVideo.switchVideo();
            }
            
            Component.onCompleted: {
                console.log( "recentRAGamesListView.count: " + recentRAGamesListView.count );
            }
        }
    }
    
    Component {
        id: lvRecentRAGamesDelegate;

        RAGameItem {
            width: recentRAGamesListView.width;
            height: itemHeight;
        }
    }

    Footer.Component {
        id: cheevosFooter;

        buttons: [
            { title: 'Details', key: theme.buttonGuide.accept, square: false, sigValue: 'accept' },
            { title: 'Back', key: theme.buttonGuide.cancel, square: false, sigValue: 'cancel' },
        ];

        onFooterButtonClicked: {
            if (sigValue === 'accept') onAcceptPressed();
            if (sigValue === 'cancel') onCancelPressed();
        }
    }

    Header.Component {
        id: cheevosHeader;

        showDivider: true;
        showSorting: false;
        shade: 'dark';
        color: theme.current.bgColor;
        showTitle: true;
        title: 'Retro Achievements';
    }
}

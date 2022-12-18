import QtQuick 2.15

Item {
    property alias raRecentGames: raRecentGames;

    property var userName;
    property var apiKey;
    property var avatarImgPath;
    property var avatarUrl;
    property var softcorePoints;
    property var hardcorePoints;
    property var recentCount: 20;
    property var recentOffset: 0;
    
    property var userSummary;


    Component.onCompleted: {
        let key = api.memory.get( 'raApiKey' );
        if ( key === undefined ) {
            api.memory.set( 'raApiKey', 'Your RA API key here' );
        }
        apiKey = key;

        let user = api.memory.get( 'raUserName' );
        if ( user === undefined ) {
            api.memory.set( 'raUserName', 'You Username here' );
        }
        userName = user;
        
        avatarImgPath = api.memory.get( 'raAvatar' );
        if (userName !== undefined && apiKey !== undefined && avatarImgPath === undefined) {
            updateAvatar();
        }
        
        // TODO can we do this later?
        //updatePoints();
        updateRecentGames();
    }

    onAvatarImgPathChanged: {
        console.log( 'avatar changed to ' + avatarImgPath );
        if (avatarImgPath !== undefined) {
            avatarUrl = 'https://media.retroachievements.org' + avatarImgPath;
        }
    }
    
    
    function updateAvatar() {
        var https = new XMLHttpRequest()
        var url = "https://retroachievements.org/API/API_GetUserSummary.php?z=" + userName + "&y=" + apiKey + "&u=" + userName;
        https.open("GET", url, true);

        https.onreadystatechange = function() { 
            if (https.readyState == XMLHttpRequest.DONE) {
                var response = https.responseText;
                //console.log( response );
                userSummary = JSON.parse( response );

                avatarImgPath = userSummary.UserPic;
                console.log( "avatar: " + avatarImgPath );
                if (avatarImgPath !== undefined) {
                    api.memory.set( 'raAvatar', avatarImgPath );
                }
            }
        }
        https.send();
    }

    function updateRecentGames() {
        /*
        var https = new XMLHttpRequest()
        var url = "https://retroachievements.org/API/API_GetUserRecentlyPlayedGames.php?z=" + userName + "&y=" + apiKey + "&u=" + userName
                    + "&c=" + recentCount + "&o=" + recentOffset;
        https.open("GET", url, true);

        https.onreadystatechange = function() { 
            if (https.readyState == XMLHttpRequest.DONE) {
                var response = https.responseText;
                console.log( response );
                let recents = JSON.parse (response );
                for (let i = 0; i < recents.length; i++) {
                    //console.log( recents[i].Title );
                    // Returned data is of inconsistent types, sometimes integer and sometimes string
                    // The dictionary for each game needs to be reconstructed.
                    raRecentGames.append( { "GameID": parseInt(recents[i].GameID),
                                            "ConsoleID": recents[i].ConsoleID,
                                            "ConsoleName": recents[i].ConsoleName,
                                            "Title": recents[i].Title,
                                            "ImageIcon": recents[i].ImageIcon,
                                            "LastPlayed": recents[i].LastPlayed,
                                            "NumPossibleAchievements": parseInt(recents[i].NumPossibleAchievements),
                                            "PossibleScore": parseInt(recents[i].PossibleScore),
                                            "NumAchieved": parseInt(recents[i].NumAchieved),
                                            "ScoreAchieved": parseInt(recents[i].ScoreAchieved),
                                            "NumAchievedHardcore": parseInt(recents[i].NumAchievedHardcore),
                                            "ScoreAchievedHardcore": parseInt(recents[i].ScoreAchievedHardcore)
                                          } );
            }
        }
        https.send();
        updateRARecentGameIndex( 0, true );
         */

        // DEV - don't call the server each time !
        let response = '[{"GameID":"466","ConsoleID":"3","ConsoleName":"SNES","Title":"Donkey Kong Country 2: Diddy\'s Kong Quest","ImageIcon":"\/Images\/020222.png","LastPlayed":"2022-12-16 23:25:00","NumPossibleAchievements":"80","PossibleScore":"830","NumAchieved":"4","ScoreAchieved":"16","NumAchievedHardcore":"4","ScoreAchievedHardcore":"16"},{"GameID":"14601","ConsoleID":"53","ConsoleName":"WonderSwan","Title":"Kaze no Klonoa: Moonlight Museum","ImageIcon":"\/Images\/049923.png","LastPlayed":"2022-12-15 21:40:30","NumPossibleAchievements":"59","PossibleScore":"580","NumAchieved":"43","ScoreAchieved":"280","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"620","ConsoleID":"53","ConsoleName":"WonderSwan","Title":"Gunpey","ImageIcon":"\/Images\/041376.png","LastPlayed":"2022-12-13 09:58:36","NumPossibleAchievements":0,"PossibleScore":0,"NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"449","ConsoleID":"3","ConsoleName":"SNES","Title":"Breath of Fire","ImageIcon":"\/Images\/008646.png","LastPlayed":"2022-12-12 22:32:45","NumPossibleAchievements":"63","PossibleScore":"625","NumAchieved":"23","ScoreAchieved":"166","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"11261","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Klonoa: Door to Phantomile","ImageIcon":"\/Images\/026636.png","LastPlayed":"2022-12-08 09:41:41","NumPossibleAchievements":"47","PossibleScore":"516","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"12900","ConsoleID":"25","ConsoleName":"Atari 2600","Title":"Enduro","ImageIcon":"\/Images\/050442.png","LastPlayed":"2022-12-02 10:56:19","NumPossibleAchievements":"20","PossibleScore":"182","NumAchieved":"11","ScoreAchieved":"37","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"6100","ConsoleID":"5","ConsoleName":"Game Boy Advance","Title":"Activision Anthology","ImageIcon":"\/Images\/008750.png","LastPlayed":"2022-12-01 17:10:33","NumPossibleAchievements":"44","PossibleScore":"520","NumAchieved":"1","ScoreAchieved":"25","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"9518","ConsoleID":"18","ConsoleName":"Nintendo DS","Title":"Professor Layton and the Curious Village","ImageIcon":"\/Images\/041244.png","LastPlayed":"2022-11-30 21:47:32","NumPossibleAchievements":"42","PossibleScore":"373","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"2","ConsoleID":"1","ConsoleName":"Mega Drive","Title":"Aladdin","ImageIcon":"\/Images\/061384.png","LastPlayed":"2022-11-30 21:44:00","NumPossibleAchievements":"22","PossibleScore":"320","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"2203","ConsoleID":"5","ConsoleName":"Game Boy Advance","Title":"Astro Boy: Omega Factor","ImageIcon":"\/Images\/049845.png","LastPlayed":"2022-11-30 21:32:10","NumPossibleAchievements":"66","PossibleScore":"376","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"11292","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Breath of Fire IV","ImageIcon":"\/Images\/051208.png","LastPlayed":"2022-11-29 22:06:37","NumPossibleAchievements":"129","PossibleScore":"1015","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"11269","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Breath of Fire III","ImageIcon":"\/Images\/019054.png","LastPlayed":"2022-11-29 22:03:14","NumPossibleAchievements":"100","PossibleScore":"850","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"9","ConsoleID":"1","ConsoleName":"Mega Drive","Title":"Castle of Illusion Starring Mickey Mouse","ImageIcon":"\/Images\/048628.png","LastPlayed":"2022-11-28 20:09:22","NumPossibleAchievements":"20","PossibleScore":"205","NumAchieved":"18","ScoreAchieved":"145","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"4923","ConsoleID":"6","ConsoleName":"Game Boy Color","Title":"Survival Kids","ImageIcon":"\/Images\/064496.png","LastPlayed":"2022-10-31 16:23:51","NumPossibleAchievements":"39","PossibleScore":"410","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"16347","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Mizzurna Falls","ImageIcon":"\/Images\/051837.png","LastPlayed":"2022-10-14 17:49:52","NumPossibleAchievements":0,"PossibleScore":0,"NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"16255","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Echo Night 2: Nemuri no Shihaisha","ImageIcon":"\/Images\/000001.png","LastPlayed":"2022-10-13 20:53:54","NumPossibleAchievements":0,"PossibleScore":0,"NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"228","ConsoleID":"3","ConsoleName":"SNES","Title":"Super Mario World","ImageIcon":"\/Images\/043749.png","LastPlayed":"2022-10-11 21:03:45","NumPossibleAchievements":"68","PossibleScore":"681","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"242","ConsoleID":"3","ConsoleName":"SNES","Title":"Terranigma","ImageIcon":"\/Images\/035303.png","LastPlayed":"2022-10-11 20:14:09","NumPossibleAchievements":"98","PossibleScore":"478","NumAchieved":"62","ScoreAchieved":"261","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"558","ConsoleID":"3","ConsoleName":"SNES","Title":"Super Mario World 2: Yoshi\'s Island","ImageIcon":"\/Images\/061087.png","LastPlayed":"2022-10-11 20:14:00","NumPossibleAchievements":"64","PossibleScore":"558","NumAchieved":"5","ScoreAchieved":"18","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"5268","ConsoleID":"8","ConsoleName":"PC Engine","Title":"Splatterhouse","ImageIcon":"\/Images\/028731.png","LastPlayed":"2022-10-09 14:26:44","NumPossibleAchievements":"46","PossibleScore":"650","NumAchieved":"2","ScoreAchieved":"15","NumAchievedHardcore":0,"ScoreAchievedHardcore":0}]';
        let recents = JSON.parse (response );
        for (let i = 0; i < recents.length; i++) {
            //console.log( recents[i].Title );
            // Returned data is of inconsistent types, sometimes integer and sometimes string
            // The dictionary for each game needs to be reconstructed.
            raRecentGames.append( { "GameID": parseInt(recents[i].GameID),
                                    "ConsoleID": recents[i].ConsoleID,
                                    "ConsoleName": recents[i].ConsoleName,
                                    "Title": recents[i].Title,
                                    "ImageIcon": recents[i].ImageIcon,
                                    "LastPlayed": recents[i].LastPlayed,
                                    "NumPossibleAchievements": parseInt(recents[i].NumPossibleAchievements),
                                    "PossibleScore": parseInt(recents[i].PossibleScore),
                                    "NumAchieved": parseInt(recents[i].NumAchieved),
                                    "ScoreAchieved": parseInt(recents[i].ScoreAchieved),
                                    "NumAchievedHardcore": parseInt(recents[i].NumAchievedHardcore),
                                    "ScoreAchievedHardcore": parseInt(recents[i].ScoreAchievedHardcore)
                                  } );
        }
        console.log( "raRecentGames count " + raRecentGames.count );
        updateRARecentGameIndex( 0, true );
    }

    ListModel {
        id: raRecentGames;
    }
}

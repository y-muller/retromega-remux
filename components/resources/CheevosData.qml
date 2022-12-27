import QtQuick 2.15
import SortFilterProxyModel 0.2

Item {
    property alias raRecentGames: raRecentGames;
    property alias sortedGameCheevos: sortedGameCheevos;

    property bool dataInitialised: false; // set to true on first activation of the cheevos view
    property string raUserName: '';
    property string raApiKey: '';
    property var avatarImgPath;
    property var avatarUrl;
    property var softcorePoints;
    property var hardcorePoints;
    property var recentCount: 20;
    property var recentOffset: 0;
    property var currentGameID: -1;
    property var currentGameDetails: { "Title": "",
                                        "ImageIcon": "",
                                        "ConsoleId": "", "ConsoleName": "",
                                        "Genre": "",
                                        "NumAchievements": 0,
                                        "NumAwardedToUserHardcore": 0,
                                        "NumAwardedToUser": 0
                                      };

    property string noGameText;
    property var userSummary;

    property string pointsText: {
        if (cheevosData.hardcorePoints === undefined || cheevosData.softcorePoints === undefined ) {
            return "";
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



    Component.onCompleted: {
        avatarImgPath = api.memory.get( 'raAvatar' );
        raUserName = settings.get('raUserName');
        raApiKey = settings.get('raApiKey');

        settings.addCallback('raUserName', function () {
            raUserName = settings.get('raUserName');
            dataInitialised = false;
            cheevosEnabled = settings.get('raUserName') !== '' && settings.get('raApiKey') !== '';
        });
        settings.addCallback('raApiKey', function () {
            raApiKey = settings.get('raApiKey');
            dataInitialised = false;
            cheevosEnabled = settings.get('raUserName') !== '' && settings.get('raApiKey') !== '';
        });

        // wait for the 'cheevos' view to become active
        checkCheevosView(currentView);
        addCurrentViewCallback(function (currentView) {
            checkCheevosView(currentView);
        });
    }

    onDataInitialisedChanged: {
        //console.log( "RA dataInitialised changed: " + dataInitialised );
    }

    onAvatarImgPathChanged: {
        if (avatarImgPath !== undefined) {
            avatarUrl = 'https://media.retroachievements.org' + avatarImgPath;
        }
        else {
            avatarUrl = '';
        }
    }
    
    onCurrentGameIDChanged: {
        refreshGameCheevos();
    }
    
    function checkCheevosView(currentView) {
        if (currentView === 'cheevos') {
            if (!dataInitialised) {
                if (cheevosEnabled && avatarImgPath === undefined) {
                    updateAvatar();
                }
                
                refreshGamesAndPoints();
                dataInitialised = true;
            }
        }
    }
    
    function raHttpsRequest( api, args, handler) {
        if (!debugRA) {
            // LIVE mode
            var url = "https://retroachievements.org/API/API_" + api + ".php?z=" + raUserName + "&y=" + raApiKey + (args!=="" ? "&" : "") + args;
            //console.log("URL: " + url);
            var https = new XMLHttpRequest()
            https.open("GET", url, true);
            https.onreadystatechange = function() { 
                if (https.readyState == XMLHttpRequest.DONE) {
                    if (https.status == 200) {
                        handler(JSON.parse(https.responseText));
                    }
                    else {
                        noGameText = "Error communicating with RetroAchievements server"
                    }
                }
            }
            https.send();
        }
        else {
            // DEBUG mode
            console.log('RA DEBUG MODE: ' + api); 
            let resp;
            if (api=='GetUserRankAndScore') {
                resp='{"Score":123,"SoftcoreScore":456,"Rank":25428,"TotalRanked":33283}';
            }
            else if (api=='GetUserRecentlyPlayedGames') {
                resp = '[{"GameID":"466","ConsoleID":"3","ConsoleName":"SNES","Title":"Donkey Kong Country 2: Diddy\'s Kong Quest","ImageIcon":"\/Images\/020222.png","LastPlayed":"2022-12-16 23:25:00","NumPossibleAchievements":"80","PossibleScore":"830","NumAchieved":"4","ScoreAchieved":"16","NumAchievedHardcore":"4","ScoreAchievedHardcore":"16"},{"GameID":"14601","ConsoleID":"53","ConsoleName":"WonderSwan","Title":"Kaze no Klonoa: Moonlight Museum","ImageIcon":"\/Images\/049923.png","LastPlayed":"2022-12-15 21:40:30","NumPossibleAchievements":"59","PossibleScore":"580","NumAchieved":"43","ScoreAchieved":"280","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"620","ConsoleID":"53","ConsoleName":"WonderSwan","Title":"Gunpey","ImageIcon":"\/Images\/041376.png","LastPlayed":"2022-12-13 09:58:36","NumPossibleAchievements":0,"PossibleScore":0,"NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"449","ConsoleID":"3","ConsoleName":"SNES","Title":"Breath of Fire","ImageIcon":"\/Images\/008646.png","LastPlayed":"2022-12-12 22:32:45","NumPossibleAchievements":"63","PossibleScore":"625","NumAchieved":"23","ScoreAchieved":"166","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"11261","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Klonoa: Door to Phantomile","ImageIcon":"\/Images\/026636.png","LastPlayed":"2022-12-08 09:41:41","NumPossibleAchievements":"47","PossibleScore":"516","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"12900","ConsoleID":"25","ConsoleName":"Atari 2600","Title":"Enduro","ImageIcon":"\/Images\/050442.png","LastPlayed":"2022-12-02 10:56:19","NumPossibleAchievements":"20","PossibleScore":"182","NumAchieved":"11","ScoreAchieved":"37","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"6100","ConsoleID":"5","ConsoleName":"Game Boy Advance","Title":"Activision Anthology","ImageIcon":"\/Images\/008750.png","LastPlayed":"2022-12-01 17:10:33","NumPossibleAchievements":"44","PossibleScore":"520","NumAchieved":"1","ScoreAchieved":"25","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"9518","ConsoleID":"18","ConsoleName":"Nintendo DS","Title":"Professor Layton and the Curious Village","ImageIcon":"\/Images\/041244.png","LastPlayed":"2022-11-30 21:47:32","NumPossibleAchievements":"42","PossibleScore":"373","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"2","ConsoleID":"1","ConsoleName":"Mega Drive","Title":"Aladdin","ImageIcon":"\/Images\/061384.png","LastPlayed":"2022-11-30 21:44:00","NumPossibleAchievements":"22","PossibleScore":"320","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"2203","ConsoleID":"5","ConsoleName":"Game Boy Advance","Title":"Astro Boy: Omega Factor","ImageIcon":"\/Images\/049845.png","LastPlayed":"2022-11-30 21:32:10","NumPossibleAchievements":"66","PossibleScore":"376","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"11292","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Breath of Fire IV","ImageIcon":"\/Images\/051208.png","LastPlayed":"2022-11-29 22:06:37","NumPossibleAchievements":"129","PossibleScore":"1015","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"11269","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Breath of Fire III","ImageIcon":"\/Images\/019054.png","LastPlayed":"2022-11-29 22:03:14","NumPossibleAchievements":"100","PossibleScore":"850","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"9","ConsoleID":"1","ConsoleName":"Mega Drive","Title":"Castle of Illusion Starring Mickey Mouse","ImageIcon":"\/Images\/048628.png","LastPlayed":"2022-11-28 20:09:22","NumPossibleAchievements":"20","PossibleScore":"205","NumAchieved":"18","ScoreAchieved":"145","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"4923","ConsoleID":"6","ConsoleName":"Game Boy Color","Title":"Survival Kids","ImageIcon":"\/Images\/064496.png","LastPlayed":"2022-10-31 16:23:51","NumPossibleAchievements":"39","PossibleScore":"410","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"16347","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Mizzurna Falls","ImageIcon":"\/Images\/051837.png","LastPlayed":"2022-10-14 17:49:52","NumPossibleAchievements":0,"PossibleScore":0,"NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"16255","ConsoleID":"12","ConsoleName":"PlayStation","Title":"Echo Night 2: Nemuri no Shihaisha","ImageIcon":"\/Images\/000001.png","LastPlayed":"2022-10-13 20:53:54","NumPossibleAchievements":0,"PossibleScore":0,"NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"228","ConsoleID":"3","ConsoleName":"SNES","Title":"Super Mario World","ImageIcon":"\/Images\/043749.png","LastPlayed":"2022-10-11 21:03:45","NumPossibleAchievements":"68","PossibleScore":"681","NumAchieved":0,"ScoreAchieved":0,"NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"242","ConsoleID":"3","ConsoleName":"SNES","Title":"Terranigma","ImageIcon":"\/Images\/035303.png","LastPlayed":"2022-10-11 20:14:09","NumPossibleAchievements":"98","PossibleScore":"478","NumAchieved":"62","ScoreAchieved":"261","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"558","ConsoleID":"3","ConsoleName":"SNES","Title":"Super Mario World 2: Yoshi\'s Island","ImageIcon":"\/Images\/061087.png","LastPlayed":"2022-10-11 20:14:00","NumPossibleAchievements":"64","PossibleScore":"558","NumAchieved":"5","ScoreAchieved":"18","NumAchievedHardcore":0,"ScoreAchievedHardcore":0},{"GameID":"5268","ConsoleID":"8","ConsoleName":"PC Engine","Title":"Splatterhouse","ImageIcon":"\/Images\/028731.png","LastPlayed":"2022-10-09 14:26:44","NumPossibleAchievements":"46","PossibleScore":"650","NumAchieved":"2","ScoreAchieved":"15","NumAchievedHardcore":0,"ScoreAchievedHardcore":0}]';
            }
            else if (api=='GetGameInfoAndUserProgress') {
                resp = '{"ID":9,"Title":"Castle of Illusion Starring Mickey Mouse","ConsoleID":1,"ForumTopicID":373,"Flags":0,"ImageIcon":"\/Images\/048628.png","ImageTitle":"\/Images\/000776.png","ImageIngame":"\/Images\/000777.png","ImageBoxArt":"\/Images\/051879.png","Publisher":"Sega","Developer":"Sega","Genre":"","Released":"November 20, 1990","IsFinal":false,"ConsoleName":"Mega Drive","RichPresencePatch":"a725e1afc8e03c96da15cee6cbe9f0ab","NumAchievements":20,"NumDistinctPlayersCasual":"3595","NumDistinctPlayersHardcore":"1627","Achievements":{"176":{"ID":"176","NumAwarded":"3005","NumAwardedHardcore":"1397","Title":"High Powered Mouse","Description":"Get a Power Level of 5 (Normal or Hard Difficulty)","Points":"5","TrueRatio":"5","Author":"GamerPupUK","DateModified":"2022-03-27 01:52:19","DateCreated":"2013-04-11 18:36:49","BadgeName":"04979","DisplayOrder":"10","MemAddr":"1498273b744cebeeac7df1b552a6ee12","DateEarned":"2022-11-28 08:07:35"},"177":{"ID":"177","NumAwarded":"838","NumAwardedHardcore":"410","Title":"Lucky Seven","Description":"Obtain 7 Lives","Points":"5","TrueRatio":"10","Author":"GamerPupUK","DateModified":"2022-03-27 01:52:20","DateCreated":"2013-04-11 19:16:19","BadgeName":"04978","DisplayOrder":"20","MemAddr":"a4a9c187b7ca83392e1d55999c3a3e5a","DateEarned":"2022-11-28 14:50:18"},"58":{"ID":"58","NumAwarded":"2207","NumAwardedHardcore":"1167","Title":"Keeps The Doctor Away","Description":"Collect 30 apples","Points":"5","TrueRatio":"5","Author":"Scott","DateModified":"2022-03-27 01:52:18","DateCreated":"2012-12-01 23:01:36","BadgeName":"04983","DisplayOrder":"50","MemAddr":"434b1eac81f60280efd9033db03b0026","DateEarned":"2022-11-28 11:29:17"},"4319":{"ID":"4319","NumAwarded":"1995","NumAwardedHardcore":"1059","Title":"Losing Your Marbles","Description":"Collect 30 marbles","Points":"5","TrueRatio":"6","Author":"Scott","DateModified":"2022-03-27 01:52:20","DateCreated":"2014-01-04 00:42:17","BadgeName":"04946","DisplayOrder":"51","MemAddr":"67f675641e5c16a78ba4cd9e09e123af","DateEarned":"2022-11-28 13:47:51"},"4343":{"ID":"4343","NumAwarded":"644","NumAwardedHardcore":"418","Title":"Mickey Mage","Description":"Collect 15 fireballs","Points":"10","TrueRatio":"21","Author":"Scott","DateModified":"2022-03-27 01:52:21","DateCreated":"2014-01-04 22:29:44","BadgeName":"04984","DisplayOrder":"52","MemAddr":"3670100aa320cc05177d58a8f7e25e66"},"4316":{"ID":"4316","NumAwarded":"1873","NumAwardedHardcore":"964","Title":"Hi Scoring Mouse","Description":"Get Over 75000 Points","Points":"5","TrueRatio":"6","Author":"Scott","DateModified":"2020-06-06 10:41:39","DateCreated":"2014-01-03 23:54:58","BadgeName":"04944","DisplayOrder":"60","MemAddr":"b9f04f86d84d5fd594e809222f4f3fff","DateEarned":"2022-11-28 11:43:30"},"4317":{"ID":"4317","NumAwarded":"1120","NumAwardedHardcore":"591","Title":"Mousetacular","Description":"Get Over 150000 Points","Points":"5","TrueRatio":"8","Author":"Scott","DateModified":"2020-06-06 10:41:38","DateCreated":"2014-01-04 00:06:24","BadgeName":"04972","DisplayOrder":"61","MemAddr":"4e9035f69285dbc5cf4890db57b442d7","DateEarned":"2022-11-28 14:50:20"},"4318":{"ID":"4318","NumAwarded":"675","NumAwardedHardcore":"340","Title":"Taking The Mickey","Description":"Get Over 250000 Points","Points":"10","TrueRatio":"25","Author":"Scott","DateModified":"2020-06-06 10:41:36","DateCreated":"2014-01-04 00:06:47","BadgeName":"04980","DisplayOrder":"62","MemAddr":"7a243ef2c77e72594b0a0b206f6490b0","DateEarned":"2022-11-28 16:09:52"},"4336":{"ID":"4336","NumAwarded":"1073","NumAwardedHardcore":"585","Title":"Milky Way","Description":"Jump Inside The Milk Bottle","Points":"5","TrueRatio":"8","Author":"Scott","DateModified":"2019-03-13 15:34:24","DateCreated":"2014-01-04 18:04:39","BadgeName":"04960","DisplayOrder":"80","MemAddr":"b701c76a1eba368a55f4a6bd87947e20","DateEarned":"2022-11-28 15:07:37"},"4348":{"ID":"4348","NumAwarded":"1492","NumAwardedHardcore":"785","Title":"Secret Squeak","Description":"Earn a Secret Bonus of over 25000","Points":"5","TrueRatio":"7","Author":"Scott","DateModified":"2020-06-06 10:41:33","DateCreated":"2014-01-04 23:42:36","BadgeName":"04982","DisplayOrder":"90","MemAddr":"baba72f4caf3fd0d48febc76cc8ae8eb","DateEarned":"2022-11-28 11:35:07"},"4349":{"ID":"4349","NumAwarded":"1027","NumAwardedHardcore":"560","Title":"Technicallly Brilliant","Description":"Earn a Technical Bonus of 10000","Points":"10","TrueRatio":"17","Author":"Scott","DateModified":"2020-06-06 10:41:32","DateCreated":"2014-01-04 23:47:49","BadgeName":"04981","DisplayOrder":"91","MemAddr":"ebcc16e282f8dac2766b80075b8cf71a","DateEarned":"2022-11-28 14:50:11"},"4337":{"ID":"4337","NumAwarded":"2540","NumAwardedHardcore":"1296","Title":"Red Gem","Description":"Collect the Red Gem","Points":"5","TrueRatio":"5","Author":"Scott","DateModified":"2020-06-06 10:41:31","DateCreated":"2014-01-04 19:26:57","BadgeName":"04971","DisplayOrder":"101","MemAddr":"3c081bdf1f0fb51811f32f53340d2898","DateEarned":"2022-11-28 11:35:00"},"4338":{"ID":"4338","NumAwarded":"1580","NumAwardedHardcore":"864","Title":"Orange Gem","Description":"Collect the Orange Gem","Points":"5","TrueRatio":"6","Author":"Scott","DateModified":"2020-06-06 10:41:29","DateCreated":"2014-01-04 19:32:08","BadgeName":"04962","DisplayOrder":"102","MemAddr":"d4e24a5b546ab83668c891362023ca36","DateEarned":"2022-11-28 14:50:03"},"4339":{"ID":"4339","NumAwarded":"1089","NumAwardedHardcore":"588","Title":"Yellow Gem","Description":"Collect the Yellow Gem","Points":"10","TrueRatio":"17","Author":"Scott","DateModified":"2020-06-06 10:41:27","DateCreated":"2014-01-04 19:37:51","BadgeName":"04970","DisplayOrder":"103","MemAddr":"b8ad826fb70ee00790b2798e52638c45","DateEarned":"2022-11-28 15:05:52"},"4340":{"ID":"4340","NumAwarded":"1035","NumAwardedHardcore":"566","Title":"Green Gem","Description":"Collect the Green Gem","Points":"10","TrueRatio":"17","Author":"Scott","DateModified":"2020-06-06 10:41:26","DateCreated":"2014-01-04 19:52:14","BadgeName":"04968","DisplayOrder":"104","MemAddr":"81a0473f83fd4101279f566ed207e81d","DateEarned":"2022-11-28 15:09:49"},"4342":{"ID":"4342","NumAwarded":"942","NumAwardedHardcore":"500","Title":"Blue Gem","Description":"Collect the Blue Gem","Points":"10","TrueRatio":"19","Author":"Scott","DateModified":"2020-06-06 10:41:25","DateCreated":"2014-01-04 22:21:23","BadgeName":"04973","DisplayOrder":"105","MemAddr":"47206e42939c8f4096c23209fed06b43","DateEarned":"2022-11-28 15:25:04"},"4344":{"ID":"4344","NumAwarded":"836","NumAwardedHardcore":"426","Title":"Indigo Gem","Description":"Collect the Indigo Gem","Points":"10","TrueRatio":"21","Author":"Scott","DateModified":"2020-06-06 10:41:23","DateCreated":"2014-01-04 22:33:13","BadgeName":"04974","DisplayOrder":"106","MemAddr":"ff2937feefb6b14e68b82e7e68524535","DateEarned":"2022-11-28 15:52:24"},"4345":{"ID":"4345","NumAwarded":"804","NumAwardedHardcore":"403","Title":"Violet Gem","Description":"Collect the Violet Gem","Points":"10","TrueRatio":"22","Author":"Scott","DateModified":"2020-06-06 10:41:22","DateCreated":"2014-01-04 22:52:09","BadgeName":"04975","DisplayOrder":"107","MemAddr":"0c8667835e6eb012e47a36cd498dbcec","DateEarned":"2022-11-28 16:09:57"},"4346":{"ID":"4346","NumAwarded":"752","NumAwardedHardcore":"369","Title":"Save Minnie","Description":"Rescue Minnie From Mizrabel","Points":"25","TrueRatio":"58","Author":"Scott","DateModified":"2020-06-06 10:41:20","DateCreated":"2014-01-04 23:17:53","BadgeName":"04976","DisplayOrder":"150","MemAddr":"342b7ea9e620ba9f2f3370c5cec42ea0","DateEarned":"2022-11-28 20:09:38"},"4347":{"ID":"4347","NumAwarded":"246","NumAwardedHardcore":"117","Title":"Mighty Mouse","Description":"Rescue Minnie From Mizrabel on Hard Difficulty","Points":"50","TrueRatio":"307","Author":"Scott","DateModified":"2020-06-06 10:41:18","DateCreated":"2014-01-04 23:24:42","BadgeName":"04977","DisplayOrder":"151","MemAddr":"b8f8f713b1eb19a5b37390daa3496eef"}},"NumAwardedToUser":18,"NumAwardedToUserHardcore":0,"UserCompletion":"90.00%","UserCompletionHardcore":"0.00%"}';
            }
            else if (api=='GetUserSummary') {
                resp = '{"Points":"306","SoftcorePoints":"2395","UserPic":"\/UserPic\/RedSideOfTheMoon.png","TotalRanked":33282,"Status":"Offline"}';
            }
            else {
                console.log("Not implemented: " + api);
                return '';
            }
            handler(JSON.parse(resp));
        }
    }

    function updateAvatar() {
        raHttpsRequest('GetUserSummary', "u=" + raUserName, function(response) {
            avatarImgPath = response.UserPic;
            if (avatarImgPath !== undefined) {
                api.memory.set( 'raAvatar', avatarImgPath );
            }
        } );
    }

    function updatePoints() {
        raHttpsRequest('GetUserRankAndScore', "u=" + raUserName, function(response) {
            softcorePoints = response.SoftcoreScore;
            hardcorePoints = response.Score;
       
        } );
    }

    function updateRecentGames() {
        raHttpsRequest('GetUserRecentlyPlayedGames', "u=" + raUserName + "&c=" + recentCount + "&o=" + recentOffset, function(response) {
            for (let i = 0; i < response.length; i++) {
                //console.log( response[i].Title );
                // Returned data is of inconsistent types, sometimes integer and sometimes string
                // The dictionary for each game needs to be reconstructed.
                raRecentGames.append( { "GameID": parseInt(response[i].GameID),
                                        "ConsoleID": response[i].ConsoleID,
                                        "ConsoleName": response[i].ConsoleName,
                                        "Title": response[i].Title,
                                        "ImageIcon": response[i].ImageIcon,
                                        "LastPlayed": response[i].LastPlayed,
                                        "NumPossibleAchievements": parseInt(response[i].NumPossibleAchievements),
                                        "PossibleScore": parseInt(response[i].PossibleScore),
                                        "NumAchieved": parseInt(response[i].NumAchieved),
                                        "ScoreAchieved": parseInt(response[i].ScoreAchieved),
                                        "NumAchievedHardcore": parseInt(response[i].NumAchievedHardcore),
                                        "ScoreAchievedHardcore": parseInt(response[i].ScoreAchievedHardcore)
                                      } );
            }
            updateRARecentGameIndex( 0, true );
            if (raRecentGames.count === 0) {
                noGameText = 'No Game';
            }
        } );
    }

    function updateGameCheevos() {
        raHttpsRequest('GetGameInfoAndUserProgress', "u=" + raUserName+ "&g=" + currentGameID, function(response) {
            for (var key in response.Achievements) {
                //console.log( response.Achievements[key].Title );
                let dateEarned = '';
                let hardcore = false;
                if (response.Achievements[key].DateEarned !== undefined) {
                    dateEarned = response.Achievements[key].DateEarned;
                }
                if (response.Achievements[key].DateEarnedHardcore !== undefined) {
                    dateEarned = response.Achievements[key].DateEarnedHardcore;
                    hardcore = true;
                }
                let timestampEarned = Date.parse(dateEarned);
                if (isNaN(timestampEarned)) { timestampEarned = 0; }
                raGameCheevos.append( { "Title": response.Achievements[key].Title,
                                        "Description": response.Achievements[key].Description,
                                        "Points": parseInt(response.Achievements[key].Points),
                                        "BadgeName": response.Achievements[key].BadgeName,
                                        "DisplayOrder": parseInt(response.Achievements[key].DisplayOrder),
                                        "DateEarned": timestampEarned,
                                        "Hardcore": hardcore
                                      } );
            }
            currentGameDetails = { "Title": response.Title,
                                   "ImageIcon": response.ImageIcon,
                                   "ConsoleId": response.ConsoleID, "ConsoleName": response.ConsoleName,
                                   "Genre": response.Genre,
                                   "NumAchievements": parseInt(response.NumAchievements),
                                   "NumAwardedToUserHardcore": parseInt(response.NumAwardedToUserHardcore),
                                   "NumAwardedToUser": parseInt(response.NumAwardedToUser)
                                 };
            updateGameCheevosIndex( 0, true );
            if (raGameCheevos.count === 0) {
                noGameText = 'This game has no Retro Achievement';
            }
        } );
    }

    function refreshGamesAndPoints() {
        noGameText = "Updating..."
        updatePoints();
        // Remove all from the games list and reload
        raRecentGames.clear();
        updateRecentGames();
    }

    function refreshGameCheevos() {
        noGameText = "Updating..."
        updatePoints();
        // Remove all from the cheevos list and reload
        raGameCheevos.clear();
        updateGameCheevos();
    }

    ListModel {
        id: raRecentGames;
    }

    ListModel {
        id: raGameCheevos;
    }

    SortFilterProxyModel {
        id: sortedGameCheevos;

        sourceModel: raGameCheevos;
        sorters: [
            RoleSorter { roleName: 'DateEarned'; sortOrder: Qt.DescendingOrder; },
            RoleSorter { roleName: 'DisplayOrder'; sortOrder: Qt.DescendingOrder }
        ]
    }

}

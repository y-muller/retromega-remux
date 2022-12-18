import QtQuick 2.15

Item {
    Component.onCompleted: {
        var https = new XMLHttpRequest()
        var url = "https://retroachievements.org/API/API_GetUserRankAndScore.php?z=RedSideOfTheMoon&y=aOI576EEjnvQNUoi2HlzPjVDjcKiD5TV";
        https.open("GET", url, true);

        // Send the proper header information along with the request
        https.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        //https.setRequestHeader("Content-length", params.length);
        //https.setRequestHeader("Connection", "close");

        https.onreadystatechange = function() { // Call a function when the state changes.
            if (https.readyState == XMLHttpRequest.DONE) {
                var response = https.responseText;
                console.log( response );
                return response;
                //if (https.status == 200) {
                //            console.log("ok")
                //        } else {
                //            console.log("HTTPS error: " + https.status)
                //        }
            }
        }
        https.send();

    }
}

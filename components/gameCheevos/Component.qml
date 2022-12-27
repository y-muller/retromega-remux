import QtQuick 2.15

import '../footer' as Footer
import '../header' as Header

import '../media' as Media

Item {
    property alias gameCheevosListView: gameCheevosListView;

    anchors.fill: parent;
    
    property double itemHeight: {
        return gameCheevosListView.height * .125 * theme.fontScale;
    }

    function updateIndex(newIndex, moveAnimation=false) {
        if(moveAnimation)
            gameCheevosListView.highlightMoveDuration = 225;
        gameCheevosListView.currentIndex = newIndex;
        if(moveAnimation)
            gameCheevosListView.highlightMoveDuration = 0;
    }

    Keys.onUpPressed: {
        event.accepted = true;
        const updated = updateGameCheevosIndex(currentGameCheevosIndex - 1);
        if (updated) { sounds.nav(); }
    }

    Keys.onDownPressed: {
        event.accepted = true;
        const updated = updateGameCheevosIndex(currentGameCheevosIndex + 1);
        if (updated) { sounds.nav(); }
    }

    function onAcceptPressed() {
        // console.log( 'index ' +  gameCheevosListView.currentIndex );
    }

    function onCancelPressed() {
        currentView = previousView;
        sounds.back();
    }

    function onRefreshPressed() {
        cheevosData.refreshGameCheevos();
        sounds.nav();
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

        if (api.keys.isFilters(event)) {
            event.accepted = true;
            onRefreshPressed();
        }
    }

    Rectangle {
        color: theme.current.bgColor;
        anchors.fill: parent;
    }

    GameSummary {
        id: gameSummary;
        height: parent.height * .125;
        anchors {
            left: parent.left;
            right: parent.right;
            top: gameCheevosHeader.bottom;
        }

    }

    Rectangle {
        color: 'transparent'; //border.color: 'magenta';
        anchors {
            left: parent.left;
            right: parent.right;
            top: gameSummary.bottom;
            bottom: gameCheevosFooter.top;
        }

        Text {
            visible: cheevosData.sortedGameCheevos.count === 0;
            text: cheevosData.noGameText;
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
            id: gameCheevosListView;

            model: cheevosData.sortedGameCheevos;
            delegate: lvRAGameCheevosDelegate;
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
                color: '#c8482e';
                opacity: theme.current.bgOpacity;
                radius: 8;
                width: gameCheevosListView.width;
            }

            onCurrentIndexChanged: {
            }
            
            Component.onCompleted: {
            }
        }
    }
    
    Component {
        id: lvRAGameCheevosDelegate;

        RACheevosItem {
            width: gameCheevosListView.width;
            height: itemHeight;
        }
    }

    Footer.Component {
        id: gameCheevosFooter;
        index: currentGameCheevosIndex + 1;
        total: cheevosData.sortedGameCheevos.count;

        buttons: [
            { title: 'Back', key: theme.buttonGuide.cancel, square: false, sigValue: 'cancel' },
            { title: 'Refresh', key: theme.buttonGuide.details, square: false, sigValue: 'refresh' },
        ];

        onFooterButtonClicked: {
            if (sigValue === 'accept') onAcceptPressed();
            if (sigValue === 'cancel') onCancelPressed();
            if (sigValue === 'refresh') onRefreshPressed();
        }
    }

    Header.Component {
        id: gameCheevosHeader;

        showDivider: true;
        showSorting: false;
        shade: 'dark';
        color: theme.current.bgColor;
        showTitle: false;

        Media.GameImage {
            id: raLogo;

            height: parent.height;
            width: parent.height;  // make it square
            anchors {
                top: parent.top;
                left: parent.left;
                bottom: parent.bottom;
                topMargin: vpx(10);
                leftMargin: vpx(20);
                bottomMargin: vpx(10);
            }
            imageSource: '../../assets/images/RA-logo.png';
        }

        Media.GameImage {
            id: avatar;

            height: parent.height;
            width: parent.height;  // make it square
            anchors {
                top: parent.top;
                left: raLogo.right;
                bottom: parent.bottom;
                topMargin: vpx(10);
                leftMargin: vpx(20);
                bottomMargin: vpx(10);
            }
            imageSource: cheevosData.avatarUrl;
        }

        Text {
            id: userName;
            text: cheevosData.raUserName;

            color: theme.current.detailsColor;
            opacity: .9;
            elide: Text.ElideRight;
            maximumLineCount: 1;
            font {
                pixelSize: parent.height * .32;
                letterSpacing: -0.3;
                bold: true;
            }
            anchors {
                top: parent.top;
                topMargin: vpx(14);
                left: avatar.right;
                leftMargin: vpx(15);
            }
        }
        Text {
            id: points;
            text: cheevosData.pointsText;

            color: theme.current.detailsColor;
            opacity: .7;
            elide: Text.ElideRight;
            maximumLineCount: 1;
            font {
                pixelSize: parent.height * .23;
                letterSpacing: -0.3;
                bold: false;
            }
            anchors {
                top: userName.bottom;
                left: avatar.right;
                leftMargin: vpx(15);
            }
       }

    }
}

import QtQuick 2.15

import '../footer' as Footer
import '../header' as Header

Item {
    anchors.fill: parent;
    property bool textInputShowing: false;

    function showModal() {
        textInputShowing = true;
        textInputModal.anchors.topMargin = 0;
        textInputModal.textInput.text = textInputValue;
    }

    function hideModal() {
        textInputShowing = false;
        textInputModal.anchors.topMargin = root.height;
    }

    Keys.onUpPressed: {
        if (textInputShowing) return;

        const prevIndex = settingsScroll.settingsListView.currentIndex;
        event.accepted = true;
        settingsScroll.settingsListView.decrementCurrentIndex();
        const currentIndex = settingsScroll.settingsListView.currentIndex;

        if (currentIndex !== prevIndex) {
            sounds.nav();
        }
    }

    Keys.onDownPressed: {
        if (textInputShowing) return;

        const prevIndex = settingsScroll.settingsListView.currentIndex;
        event.accepted = true;
        settingsScroll.settingsListView.incrementCurrentIndex();
        const currentIndex = settingsScroll.settingsListView.currentIndex;

        if (currentIndex !== prevIndex) {
            sounds.nav();
        }
    }

    function onAcceptPressed(muteSound = false) {
        if (textInputShowing) {
            const currentIndex = settingsScroll.settingsListView.currentIndex;
            const currentKey = settings.keys[currentIndex];
            settings.set( currentKey, textInputModal.textInput.text );
            hideModal();
            sounds.forward();
            return;
        }

        const currentIndex = settingsScroll.settingsListView.currentIndex;
        const currentKey = settings.keys[currentIndex];
        const currentValue = settings.get(currentKey);
        if (typeof currentValue === 'boolean') {
            settings.toggle(currentKey);
        }
        else if (typeof currentValue === 'string') {
            textInputTitle = settings.titles[currentKey];
            textInputValue = currentValue;
            textInputNote = settings.notes[currentKey] || '';
            showModal();
        }
        if (!muteSound) sounds.nav();
    }

    function onCancelPressed() {
        if (textInputShowing) {
            hideModal();
            sounds.back();
            return;
        };

        currentView = previousView;
        sounds.back();
    }

    function onClearPressed() {
        if (!textInputShowing) return;

        textInputModal.textInput.clear();
    }


    function onFiltersPressed() {
        raCredentialsShowing = true;
        raCredentials.anchors.topMargin = 0;
        sounds.forward();
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
            if (textInputShowing) {
                onClearPressed();
            }
            else {
                onCancelPressed();
            }
        }
    }

    Item {
        id: allDetailsBlur;

        anchors.fill: parent;

        Rectangle {
            color: theme.current.bgColor;
            anchors.fill: parent;
        }

        SettingsScroll {
            id: settingsScroll;

            anchors {
                top: settingsHeader.bottom;
                bottom: settingsFooter.top;
                left: parent.left;
                right: parent.right;
            }
        }

        Footer.Component {
            id: settingsFooter;

            total: 0;

            buttons: [
                { title: 'Set', key: theme.buttonGuide.accept, square: false, sigValue: 'accept' },
                { title: 'Back', key: theme.buttonGuide.cancel, square: false, sigValue: 'cancel' },
            ];

            onFooterButtonClicked: {
                if (sigValue === 'accept') onAcceptPressed();
                if (sigValue === 'cancel') onCancelPressed();
            }
        }

        Header.Component {
            id: settingsHeader;

            showDivider: true;
            showSorting: false;
            shade: 'dark';
            color: theme.current.bgColor;
            showTitle: true;
            title: 'Settings';
        }
    }
    
    TextInputModal {
        id: textInputModal;

        height: parent.height;
        width: parent.width;
        blurSource: allDetailsBlur;

        anchors {
            top: parent.top;
            topMargin: root.height;
            left: parent.left;
            right: parent.right;
        }

        Behavior on anchors.topMargin {
            PropertyAnimation { easing.type: Easing.OutCubic; duration: 200; }
        }
    }

}

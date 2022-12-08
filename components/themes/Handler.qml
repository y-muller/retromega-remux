import QtQuick 2.15

Item {
    property Item current: lightTheme;
    property Item buttonGuide: switchButtons;
    property var valueButtonsXBox: false;
    property var valueButtonsPlaystation: false;
    property double fontScale: 1.0;

    function setFontScale(smallFont) {
        if (smallFont) {
            fontScale = 0.6;
        } else {
            fontScale = 1.0;
        }
    }

    function setDarkMode(value) {
        if (value) {
            current = darkTheme;
        } else {
            current = lightTheme;
        }
    }

    function setButtonGuide(value) {
        if (valueButtonsXBox && valueButtonsPlaystation) {
            buttonGuide = psButtons;
        } else if (!valueButtonsXBox && valueButtonsPlaystation) {
            buttonGuide = psJapanButtons;
        } else if (valueButtonsXBox && !valueButtonsPlaystation) {
            buttonGuide = xboxButtons;
        } else {
            buttonGuide = switchButtons;
        }
    }

    function setButtonGuideXBox(value) {
        valueButtonsXBox = value;
        setButtonGuide();
    }

    function setButtonGuidePlaystation(value) {
        valueButtonsPlaystation = value;
        setButtonGuide();
    }

    Component.onCompleted: {
        settings.addCallback('darkMode', setDarkMode);
        settings.addCallback('buttonsXBox', setButtonGuideXBox);
        settings.addCallback('buttonsPlaystation', setButtonGuidePlaystation);
        settings.addCallback('smallFont', setFontScale);
    }

    LightTheme { id: lightTheme; }
    DarkTheme { id: darkTheme; }
    SwitchButtons { id: switchButtons; }
    XboxButtons { id: xboxButtons; }
    PlaystationButtons { id: psButtons; }
    PlaystationJapanButtons { id: psJapanButtons; }
}

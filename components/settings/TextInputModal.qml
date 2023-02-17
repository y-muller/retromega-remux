import QtQuick 2.15
import QtGraphicalEffects 1.12

import '../footer' as Footer

Item {
    property var blurSource;
    property alias textInput: textInput;

    property var displayNote: {
        return (textInputNote !== '');
    }

    // background to lighten or darken the blur effect, since it's translucent
    Rectangle {
        color: theme.current.bgColor;
        anchors.fill: parent;

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                onCancelPressed();
            }
        }
    }

    FastBlur {
        width: root.width;
        height: root.height;
        radius: 80;
        opacity: .4;
        source: blurSource;
        cached: true;
    }

    Rectangle {
        radius: 10;
        height: parent.height * (displayNote ? 0.43 : 0.38);
        width: parent.width * .7;
        color: theme.current.bgColor;
        border.color: theme.current.dividerColor;

        anchors {
            top: parent.top;
            topMargin: root.height * (displayNote ? .03 : .06);
            horizontalCenter: parent.horizontalCenter;
        }

        Text {
            id: modalTitle;

            text: textInputTitle;
            height: root.height * .115;
            verticalAlignment: Text.AlignVCenter;
            color: theme.current.defaultHeaderNameColor

            font {
                pixelSize: parent.height * .11;
                letterSpacing: -0.3;
                bold: true;
            }

            anchors {
                top: parent.top;
                left: parent.left;
                leftMargin: 27;
            }
        }

        Rectangle {
            id: modalDividerTop;

            height: 1;
            color: theme.current.dividerColor;

            anchors {
                top: modalTitle.bottom;
                left: parent.left;
                leftMargin: 23;
                right: parent.right;
                rightMargin: 23;
            }
        }

        Text {
            id: modalNote;

            text: textInputNote;
            height: root.height * (displayNote ? .05 : 0);
            verticalAlignment: Text.AlignVCenter;
            wrapMode: Text.WordWrap;
            //color: theme.current.defaultHeaderNameColor

            font {
                pixelSize: height * .49;
                //letterSpacing: -0.3;
                bold: false;
            }

            anchors {
                top: modalDividerTop.top;
                topMargin: displayNote ? 20 : 0;
                left: parent.left;
                leftMargin: 27;
                right: parent.right;
                rightMargin: 27;
            }
        }

        Rectangle {
            id: textBox;

            border.color: theme.current.textInputBorderColor;
            color: theme.current.textInputBackgroundColor;

            anchors {
                top: modalNote.bottom;
                topMargin: 20;
                left: parent.left;
                leftMargin: 27;
                right: parent.right;
                rightMargin: 27;
                bottom: textInputModalFooter.top;
                bottomMargin: 20;
            }

            /*Text {
                text: '(no filter)';
                verticalAlignment: Text.AlignVCenter;
                color: theme.current.textInputPlaceholderColor;
                visible: textInput.preeditText === '' && textInput.text === '';

                anchors {
                    fill: parent;
                    leftMargin: 10;
                }

                font {
                    pixelSize: parent.height * .6;
                    letterSpacing: -0.3;
                    bold: true;
                }
            }*/

            TextInput {
                id: textInput;

                text: textInputValue;
                verticalAlignment: Text.AlignVCenter;
                color: theme.current.defaultHeaderNameColor
                clip: true;

                anchors {
                    fill: parent;
                    leftMargin: 10;
                }

                font {
                    pixelSize: parent.height * .6;
                    letterSpacing: -0.3;
                    bold: true;
                }
            }
        }

        Footer.Component {
            id: textInputModalFooter;

            total: 0;
            radius: 11;

            anchors {
                bottomMargin: 1;
                leftMargin: 1;
                rightMargin: 1;
            }

            buttons: [
                { title: 'Accept', key: theme.buttonGuide.accept, square: false, sigValue: 'accept' },
                { title: 'Cancel', key: theme.buttonGuide.cancel, square: false, sigValue: 'cancel' },
                { title: 'Clear', key: theme.buttonGuide.details, square: false, sigValue: 'clear' },
            ];

            onFooterButtonClicked: {
                if (sigValue === 'accept') onAcceptPressed();
                if (sigValue === 'cancel') onCancelPressed();
                if (sigValue === 'clear') onClearPressed();
            }
        }
    }
}

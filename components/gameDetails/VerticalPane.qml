import QtQuick 2.15
import QtGraphicalEffects 1.12

Item {

    Rectangle {
        id:vertMain

        width: parent.width;
        height: parent.height;
        
        color: 'transparent'
    }

    Rectangle {

        width: parent.height;
        height: parent.width;
        
        color: 'transparent'

        rotation: -90;
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        anchors {
            //left: verticalPane.right;
            //leftMargin: -30;
            //top: verticalPane.top;
            //topMargin: 5;
            //right: verticalPane.left;
            //bottom: verticalPane.bottom;
        }

        Text {
            text: ratingText;

            color: theme.current.detailsColor;
            opacity: 0.7;
            //verticalAlignment: Text.AlignTop;
            //horizontalAlignment: Text.AlignLeft;

            font {
                family: glyphs.name;
                pixelSize: vertMain.height * .05;
                bold: true;
            }
            
            //transform: Rotation { origin.x: 0; origin.y: 0; angle: 90 }
 
            //y: verticalPane.height * 0.05;
            anchors {
                right: parent.right;
                rightMargin: vpx(15);
                //top: parent.top;
                //topMargin: 35;
                //left: parent.left;
                //bottom: parent.bottom;
                verticalCenter: parent.verticalCenter;
            }
       
        }

        Text {
            text: playersText;

            color: theme.current.detailsColor;
            opacity: 0.7;
            //verticalAlignment: Text.AlignBottom;
            //horizontalAlignment: Text.AlignHCenter;

            font {
                family: glyphs.name;
                pixelSize: vertMain.height * .05;
                bold: true;
            }
            
            //transform: Rotation { origin.x: 0; origin.y: 0; angle: 90 }

            //x: verticalPane.width  1;
            //y: verticalPane.height * 0.55;
            width: parent.width * .2;
            anchors {
                //left: verticalPane.right;
                //leftMargin: -25;
                //right: verticalPane.right;
                //bottom: verticalPane.bottom;
                verticalCenter: parent.verticalCenter;
                horizontalCenter: parent.horizontalCenter;

            }
        
        }

        Text {
            text: releaseDateText;

            color: theme.current.detailsColor;
            opacity: 0.7;
            //verticalAlignment: Text.AlignBottom;
            //horizontalAlignment: Text.AlignHCenter;

            font {
                family: glyphs.name;
                pixelSize: vertMain.height * .05;
                bold: true;
            }
            
            //transform: Rotation { origin.x: 0; origin.y: 0; angle: 90 }

            //x: verticalPane.width  1;
            //y: verticalPane.height - vpx(90) ;
            anchors {
                //top: parent.top;
                left: parent.left;
                leftMargin: vpx(15);
                //right: verticalPane.right;
                //bottom: parent.bottom;
                //bottomMargin: releaseDateText.height ;
                verticalCenter: parent.verticalCenter;
            }
        
        }
    }

}

import MuseScore 3.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FileIO 3.0

MuseScore {
    title: "Trill Realizer"
    pluginType: "dialog"
    menuPath: "Plugins.UI"
    description: "Converts a selected note into a written-out trill."
    version: "1.0"

    width: 400
    height: 400

    function consoleLog(text) {
        consoleBox.text += text + "\n";
    }

    function smartQuit() {
        if (mscoreMajorVersion < 4) {
            Qt.quit()
        } else {
            quit()
        }
    }

    function realizeTrill() {
        try {                        
            var selection = curScore.selection.elements;
            if (selection.length === 0) {
                consoleLog("Nothing selected");
                return;
            }

            for (var i = 0; i < selection.length; i++) {
                var note = selection[i];
                if (note.type !== Element.NOTE) {
                    consoleLog("Selection index " + i + " is not a note");
                    return;
                }
                var chord = note.parent;
                if (chord.notes.length !== 1) {
                    consoleLog("selected note cant be in a chord");
                    return;
                }
            }

            var speed = 32;
            if (speed16.checked) {
                speed = 16;
            } else if (speed32.checked) {
                speed = 32;
            } else if (speed64.checked) {
                speed = 64;
            }

            var interval = 2;
            if (interval1.checked) {
                interval = 1;
            } else if (interval2.checked) {
                interval = 2;
            } else if (interval3.checked) {
                interval = 3;
            }

            curScore.startCmd();
            for (var i = 0; i < selection.length; i++) {
                var note = selection[i];
                var chord = note.parent;
                var segment = chord.parent;
                // get original duration and pitch
                var noteDur = chord.duration;
                var notePitch = note.pitch;
                // get the cursor to write new notes
                var cursor = curScore.newCursor();
                // position cursor at the start of the note
                cursor.track = note.track;
                cursor.rewindToTick(segment.tick);
                // calculate how many notes we need
                var numNotes = Math.floor(
                    noteDur.numerator * speed / noteDur.denominator
                );
                // write the trill notes
                for (var j = 0; j < numNotes; j++) {
                    var currentPitch = (j % 2 === 0) ? notePitch : (notePitch + interval);
                    consoleLog("wrote" + currentPitch);
                    cursor.setDuration(1, speed);
                    cursor.addNote(currentPitch);
                }
            }
            curScore.endCmd();
            smartQuit();
        } catch (error) {
            consoleLog(error);
        }
    }

    Dialog {
        id: mainDialog
        width: 400
        height: 400
        visible: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Label {
                text: "Trill Realizer"
                font.family: "Corbel"
                color: "white"
                font.pixelSize: 20 
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                spacing: 5

                Label {
                    text: "Trill Speed"
                    font.family: "Corbel"
                    color: "white"
                    font.pixelSize: 14 
                    Layout.alignment: Qt.AlignHLeft
                }

                // Radio Buttons
                RadioButton {
                    id: speed16
                    text: "1/16 Notes"
                    checked: false
                    // Custom Indicator
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        x: speed16.leftPadding
                        y: parent.height / 2 - height / 2
                        border.color: speed16.checked ? "#3399ff" : "#888888" 
                        border.width: 2
                        color: "transparent"

                        // The Inner Dot
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 5
                            anchors.centerIn: parent
                            color: "#3399ff"
                            visible: speed16.checked
                        }
                    }
                }

                RadioButton {
                    id: speed32
                    text: "1/32 Notes"
                    checked: true
                    // Custom Indicator
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        x: speed32.leftPadding
                        y: parent.height / 2 - height / 2
                        border.color: speed32.checked ? "#3399ff" : "#888888" 
                        border.width: 2
                        color: "transparent"

                        // The Inner Dot
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 5
                            anchors.centerIn: parent
                            color: "#3399ff"
                            visible: speed32.checked
                        }
                    }
                }

                RadioButton {
                    id: speed64
                    text: "1/64 Notes"
                    checked: false
                    // Custom Indicator
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        x: speed64.leftPadding
                        y: parent.height / 2 - height / 2
                        border.color: speed64.checked ? "#3399ff" : "#888888" 
                        border.width: 2
                        color: "transparent"

                        // The Inner Dot
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 5
                            anchors.centerIn: parent
                            color: "#3399ff"
                            visible: speed64.checked
                        }
                    }
                }
            }

            RowLayout {
                spacing: 5

                Label {
                    text: "Trill Interval"
                    font.family: "Corbel"
                    color: "white"
                    font.pixelSize: 14 
                    Layout.alignment: Qt.AlignHLeft
                }

                // Radio Buttons
                RadioButton {
                    id: interval1
                    text: "+1"
                    checked: false
                    // Custom Indicator
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        x: interval1.leftPadding
                        y: parent.height / 2 - height / 2
                        border.color: interval1.checked ? "#3399ff" : "#888888" 
                        border.width: 2
                        color: "transparent"

                        // The Inner Dot
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 5
                            anchors.centerIn: parent
                            color: "#3399ff"
                            visible: interval1.checked
                        }
                    }
                }

                RadioButton {
                    id: interval2
                    text: "+2"
                    checked: true
                    // Custom Indicator
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        x: interval2.leftPadding
                        y: parent.height / 2 - height / 2
                        border.color: interval2.checked ? "#3399ff" : "#888888" 
                        border.width: 2
                        color: "transparent"

                        // The Inner Dot
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 5
                            anchors.centerIn: parent
                            color: "#3399ff"
                            visible: interval2.checked
                        }
                    }
                }

                RadioButton {
                    id: interval3
                    text: "+3"
                    checked: false
                    // Custom Indicator
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        x: interval3.leftPadding
                        y: parent.height / 2 - height / 2
                        border.color: interval3.checked ? "#3399ff" : "#888888" 
                        border.width: 2
                        color: "transparent"

                        // The Inner Dot
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 5
                            anchors.centerIn: parent
                            color: "#3399ff"
                            visible: interval3.checked
                        }
                    }
                }
            }

            Button {
                id: applyBtn
                text: "Apply"
                onClicked: {
                    realizeTrill();
                }
            }

            // debug text box
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                TextArea {
                    id: consoleBox
                    readOnly: true
                    wrapMode: Text.Wrap
                    font.pixelSize: 14
                    color: "white"
                    background: Rectangle { color: "black"; radius: 5 }

                    onTextChanged: {
                        cursorPosition = length
                    }
                }
            }
        }
    }
}

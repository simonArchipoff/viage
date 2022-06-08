import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

import Places

ScrollView {
    ScrollBar.vertical.policy: ScrollBar.AlwaysOff
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

    property bool editing: true
    property bool completed: exterior.completed

    FlickableItem {
        BackgroundRect {
            ColumnLayout {
                width: parent.width
                Layout.minimumWidth: 200

                ColumnLayout {
                    spacing: 12
                    Layout.margins: 12
                    Layout.fillWidth: true

                    GroupBox {
                        label: Label {
                            text: qsTr("Parking")
                            font.italic: true
                        }
                        Layout.topMargin: 12
                        Layout.fillWidth: true
                        contentHeight: contentItem.childrenRect.height

                        ColumnLayout {
                            width: parent.width
                            spacing: 0

                            RowLayout {
                                spacing: 0

                                CheckBox {
                                    checked: exterior.hasParking
                                    onCheckStateChanged: exterior.hasParking = checked
                                    text: qsTr("Disponible")
                                    checkable: editing
                                }

                                IntChooser {
                                    maximum: 20
                                    numberOf: exterior.parkingSurface
                                    onEdit: function(val) { exterior.parkingSurface = val }
                                    canEdit: editing
                                    name: qsTr("Surface (m2)")
                                    visible: exterior.hasParking
                                }

                                TextField {
                                    text: exterior.parkingSurface + ' m2'
                                    readOnly: true
                                    visible: !editing && exterior.hasParking
                                    Layout.fillWidth: true
                                }

                                IntChooser {
                                    maximum: 10
                                    numberOf: exterior.parkingSpots
                                    onEdit: function(val) { exterior.parkingSpots = val }
                                    canEdit: editing
                                    name: qsTr("Nombre de places")
                                    visible: exterior.hasParking
                                }
                            }

                            TextField {
                                text: exterior.parkingSpots + ' places'
                                readOnly: true
                                visible: !editing && exterior.hasParking
                                Layout.fillWidth: true
                            }

                            GroupBox {
                                label: Label {
                                    text: qsTr("Type de places")
                                    font.italic: true
                                }
                                visible: exterior.hasParking
                                Layout.topMargin: 12
                                Layout.bottomMargin: 12
                                Layout.fillWidth: true

                                ColumnLayout {
                                    width: parent.width

                                    ColumnLayout {
                                        id: parkingTypeColumn
                                        spacing: 0

                                        CheckBox {
                                            id: bikeCheck
                                            text: qsTr("Moto")
                                            onCheckStateChanged: parkingTypeColumn.setTypes()
                                            checkable: editing
                                        }
                                        CheckBox {
                                            id: carCheck
                                            text: qsTr("Voiture")
                                            onCheckStateChanged: parkingTypeColumn.setTypes()
                                            checkable: editing
                                        }
                                        CheckBox {
                                            id: indoorCheck
                                            text: qsTr("Interieur")
                                            onCheckStateChanged: parkingTypeColumn.setTypes()
                                            checkable: editing
                                        }
                                        CheckBox {
                                            id: outdoorCheck
                                            text: qsTr("Exterieur")
                                            onCheckStateChanged: parkingTypeColumn.setTypes()
                                            checkable: editing
                                        }
                                        CheckBox {
                                            id: individualCheck
                                            text: qsTr("Individuel")
                                            onCheckStateChanged: parkingTypeColumn.setTypes()
                                            checkable: editing
                                        }
                                        CheckBox {
                                            id: colectiveCheck
                                            text: qsTr("Collectif")
                                            onCheckStateChanged: parkingTypeColumn.setTypes()
                                            checkable: editing
                                        }

                                        property bool checking: false

                                        function setTypes() {
                                            if (!checking) {
                                                let bytes = 0
                                                if (bikeCheck.checked) bytes += 1
                                                if (carCheck.checked) bytes += 2
                                                if (indoorCheck.checked) bytes += 4
                                                if (outdoorCheck.checked) bytes += 8
                                                if (individualCheck.checked) bytes += 16
                                                if (colectiveCheck.checked) bytes += 32

                                                exterior.parkingType = bytes
                                            }
                                        }

                                        function checkTypes() {
                                            checking = true
                                            bikeCheck.checked = bridge.hasFlag(exterior.parkingType, 1)
                                            carCheck.checked = bridge.hasFlag(exterior.parkingType, 2)
                                            indoorCheck.checked = bridge.hasFlag(exterior.parkingType, 4)
                                            outdoorCheck.checked = bridge.hasFlag(exterior.parkingType, 8)
                                            individualCheck.checked = bridge.hasFlag(exterior.parkingType, 16)
                                            colectiveCheck.checked = bridge.hasFlag(exterior.parkingType, 32)
                                            checking = false
                                        }

                                        Connections {
                                            target: exterior
                                            function onParkingTypeChanged() {
                                                parkingTypeColumn.checkTypes()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    GroupBox {
                        label: Label {
                            text: qsTr("Terrain")
                            font.italic: true
                        }
                        Layout.topMargin: 12
                        Layout.fillWidth: true
                        contentHeight: contentItem.childrenRect.height

                        ColumnLayout {
                            width: parent.width
                            spacing: 0

                            LabeledTextField {
                                name: qsTr("Description")
                                textOf: exterior.terrainDescription
                                canEdit: editing
                                onEdit: function(txt) { exterior.terrainDescription = txt }
                                placeHolder: qsTr("* Optionnel")
                            }

                            IntChooser {
                                name: qsTr("Surface (m2)")
                                minimum: 1
                                maximum: 2000
                                numberOf: exterior.terrainSurface
                                onEdit: function(val) { exterior.terrainSurface = val }
                                canEdit: editing
                            }

                            TextField {
                                text: "Surface de " + exterior.terrainSurface + ' m2'
                                readOnly: true
                                visible: !editing
                                placeholderText: qsTr("* Optionnel")
                            }
                        }
                    }

                    GroupBox {
                        label: Label {
                            text: qsTr("Equipements de proximité")
                            font.italic: true
                        }
                        Layout.topMargin: 12
                        Layout.bottomMargin: 12
                        Layout.fillWidth: true

                        ColumnLayout {
                            width: parent.width

                            ColumnLayout {
                                id: equipementColumn
                                spacing: 0

                                CheckBox {
                                    id: healthCheck
                                    text: qsTr("Santé")
                                    onCheckStateChanged: equipementColumn.setTypes()
                                    checkable: editing
                                }
                                CheckBox {
                                    id: foodCheck
                                    text: qsTr("Restauration")
                                    onCheckStateChanged: equipementColumn.setTypes()
                                    checkable: editing
                                }
                                CheckBox {
                                    id: educationCheck
                                    text: qsTr("Education")
                                    onCheckStateChanged: equipementColumn.setTypes()
                                    checkable: editing
                                }
                                CheckBox {
                                    id: leasureCheck
                                    text: qsTr("Loisirs")
                                    onCheckStateChanged: equipementColumn.setTypes()
                                    checkable: editing
                                }
                                CheckBox {
                                    id: shopsCheck
                                    text: qsTr("Comerces")
                                    onCheckStateChanged: equipementColumn.setTypes()
                                    checkable: editing
                                }
                                CheckBox {
                                    id: transportsCheck
                                    text: qsTr("Transports")
                                    onCheckStateChanged: equipementColumn.setTypes()
                                    checkable: editing
                                }

                                property bool checking: false

                                function setTypes() {
                                    if (!checking) {

                                        let bytes = 0
                                        if (healthCheck.checked) bytes += 1
                                        if (foodCheck.checked) bytes += 2
                                        if (educationCheck.checked) bytes += 4
                                        if (leasureCheck.checked) bytes += 8
                                        if (shopsCheck.checked) bytes += 16
                                        if (transportsCheck.checked) bytes += 32

                                        exterior.equipement = bytes
                                    }
                                }

                                function checkTypes() {
                                    checking = true
                                    healthCheck.checked = bridge.hasFlag(exterior.equipement, 1)
                                    foodCheck.checked = bridge.hasFlag(exterior.equipement, 2)
                                    educationCheck.checked = bridge.hasFlag(exterior.equipement, 4)
                                    leasureCheck.checked = bridge.hasFlag(exterior.equipement, 8)
                                    shopsCheck.checked = bridge.hasFlag(exterior.equipement, 16)
                                    transportsCheck.checked = bridge.hasFlag(exterior.equipement, 32)
                                    checking = false
                                }

                                Connections {
                                    target: exterior
                                    function onEquipementChanged() {
                                        equipementColumn.checkTypes()
                                    }
                                }
                            }
                        }
                    }

                    RowLayout {
                        Label {
                            text: qsTr("Etat général")
                            font.bold: true
                        }

                        ToolButton {
                            icon.source: exterior.rating < 1 ? "qrc:/icons/empty-star.svg"
                                                             : "qrc:/icons/star.svg"
                            icon.color: exterior.rating < 1 ? Material.foreground
                                                            : Material.accent
                            onClicked: exterior.rating = 1
                        }

                        ToolButton {
                            icon.source: exterior.rating < 2 ? "qrc:/icons/empty-star.svg"
                                                             : "qrc:/icons/star.svg"
                            icon.color: exterior.rating < 2 ? Material.foreground
                                                            : Material.accent
                            onClicked: exterior.rating = 2
                        }

                        ToolButton {
                            icon.source: exterior.rating < 3 ? "qrc:/icons/empty-star.svg"
                                                             : "qrc:/icons/star.svg"
                            icon.color: exterior.rating < 3 ? Material.foreground
                                                            : Material.accent
                            onClicked: exterior.rating = 3
                        }

                        ToolButton {
                            icon.source: exterior.rating < 4 ? "qrc:/icons/empty-star.svg"
                                                             : "qrc:/icons/star.svg"
                            icon.color: exterior.rating < 4 ? Material.foreground
                                                            : Material.accent
                            onClicked: exterior.rating = 4
                        }

                        ToolButton {
                            icon.source: exterior.rating < 5 ? "qrc:/icons/empty-star.svg"
                                                             : "qrc:/icons/star.svg"
                            icon.color: exterior.rating < 5 ? Material.foreground
                                                            : Material.accent
                            onClicked: exterior.rating = 5
                        }
                    }
                }
            }
        }
    }
}

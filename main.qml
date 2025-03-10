import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 1.4
import database.manager 1.0
import variables.manager 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.10
ApplicationWindow {
    id:mainWindow
    visible: true
    width: 850
    height: 750
    title: "Satış Verileri"
    x:500
    y:100

    property string messageFromCalendar:""
    DatabaseManager{
        id:db
    }

    Variables{
        id:variables
    }

    Rectangle{
        color: "white"
        anchors.fill: parent
    }

    Row{
        id:pageRow
        width: parent.width
        height: parent.height
        spacing:10
        padding: 10
        Column{
            id:columnFilter
            width:(parent.width*0.3)
            height: parent.height
            spacing:20
            ComboBox {
                id:comboboxFilter
                width: parent.width
                height:parent.height*0.1
                model: [
                    "Tümünü Getir" ,
                    "İlk 100 Satır" ,
                    "İlk 200 Satır" ,
                    "Son 100 Satır" ,
                    "Son 200 Satır" ,
                    "Özel Olarak Ayarla",
                    "Tarih Aralığı"
                ]
                onCurrentIndexChanged: {
                    getSalesNumber.visible = false
                    radiobutton.visible = false
                    firstDateSelect.visible = false
                    lastDateSelect.visible = false
                    getSalesNumber.text = ""
                    if(comboboxFilter.currentIndex === (comboboxFilter.count-1)){
                        firstDateSelect.visible = true
                        lastDateSelect.visible = true
                    }else if(comboboxFilter.currentIndex === (comboboxFilter.count-2)){
                        getSalesNumber.visible = true
                        radiobutton.visible = true
                    }
                }
            }
            Button{
                id:firstDateSelect
                visible:false
                text: "Başlangıç Tarihini Seç"
                width: parent.width
                height:(parent.height*0.1)
                onClicked:{
                    variables.setDateType("first");
                    var component = Qt.createComponent("CalendarDialog.qml")
                    if(component.status === Component.Ready){
                        var window    = component.createObject(variables)
                        window.sendData.connect(function(message){
                            firstDateSelect.text = "<center>Başlangıç Tarihini Seç <br>" + message +"</center>"
                        })
                        window.show();
                    }else{
                        console.log("Pencere Yüklenemedi");
                    }
                }
            }
            Button{
                id:lastDateSelect
                visible:false
                text: "Bitiş Tarihini Seç"
                width: parent.width
                height:(parent.height*0.1)
                onClicked:{
                    variables.setDateType("last");
                    var component = Qt.createComponent("CalendarDialog.qml")
                    if(component.status === Component.Ready){
                        var window    = component.createObject(variables)
                        window.sendData.connect(function(message){
                            lastDateSelect.text = "<center>Bitiş Tarihini Seç <br>" + message +"</center>"
                        })
                        window.show();
                    }else{
                        console.log("Pencere Yüklenemedi");
                    }
                }
            }
            TextField{
                id:getSalesNumber
                visible:false
                focus: true
                width: parent.width
                height:parent.height*0.1
                validator: IntValidator{}
                horizontalAlignment: TextInput.AlignHCenter
                placeholderText: "Sayı Giriniz"
                style:TextFieldStyle{
                    textColor: "black"
                    background: Rectangle {
                        radius: 5
                        color: "#F0EBEB"
                        border.color: "#000000"
                        border.width: 1
                    }
                }
            }
            Row {
                id:radiobutton
                visible:false
                width: parent.width
                spacing: 20
                ExclusiveGroup { id: tabPositionGroup }
                RadioButton {
                    id:asc
                    text: qsTr("Baştan Getir")
                    checked: true
                    exclusiveGroup: tabPositionGroup
                }
                RadioButton {
                    id:desc
                    text: qsTr("Sondan Getir")
                    checked: false
                    exclusiveGroup: tabPositionGroup
                }
            }

            Button{
                width: parent.width
                height:parent.height*0.1
                text: "Verileri Getir"

                onClicked: {
                    var data;
                    if(comboboxFilter.currentIndex === (comboboxFilter.count-1)){
                        data = db.selectReceiptInfo(variables.getFirstDate(),variables.getLastDate())
                        if(data[0] !== undefined)
                            infoBoxSuccess.visible = true
                    }else if(comboboxFilter.currentIndex === (comboboxFilter.count-2)){
                        if(getSalesNumber.text != ""){
                            data = db.getSalesData(getSalesNumber.text,asc.checked ? 'ASC' : 'DESC')
                            infoBoxSuccess.visible = true
                        }else{
                            console.log("Hata! Bir Değer Giriniz.")
                            infoBoxError.visible = true
                            return;
                        }
                    }else{
                        switch (comboboxFilter.currentIndex){
                            case 0:{
                                data = db.getSalesData()
                            }
                            break;
                            case 1:{
                                data = db.getSalesData(100,"ASC")
                            }
                            break;
                            case 2:{
                                data = db.getSalesData(200,"ASC")
                            }
                            break;
                            case 3:{
                                data = db.getSalesData(100,"DESC")
                            }
                            break;
                            case 4:{
                                data = db.getSalesData(200,"DESC")
                            }
                            break;
                            default:{
                                infoBoxSuccess.visible = false
                                return;
                            }
                        }
                    }
                    infoBoxSuccess.visible = true
                    tableModel.clear();
                    for(var i = 0; i < data.length; i++){
                        tableModel.append(data[i]);
                    }
                }
            }
            Button{
                id:buttonClear
                width: parent.width
                height:parent.height*0.1
                text: "Tabloyu Temizle"
                anchors.alignWhenCentered: true
                onClicked: {
                    tableModel.clear();
                    infoBoxSuccess.visible = false
                    infoBoxError.visible = false
                }
            }
            Rectangle{
                id:infoBoxError
                visible: false
                width:parent.width
                height: parent.height*0.2
                radius: 10
                gradient: Gradient{
                    GradientStop{position: 0.0;color:"#D8464B"}
                    GradientStop{position: 1.0;color:"#EA9A9D"}
                }
                Text {
                    id: infoTextError
                    anchors.centerIn: parent
                    color: "#fff"
                    font.pixelSize: 18
                    text: qsTr("HATA")
                }
            }
            Rectangle{
                id:infoBoxSuccess
                visible: false
                width:parent.width
                height: parent.height*0.2
                radius: 10
                gradient: Gradient{
                    GradientStop{position: 0.0;color:"#2EB242"}
                    GradientStop{position: 1.0;color:"#7DDE8C"}
                }
                Text {
                    id:infoTextSuccess
                    anchors.centerIn: parent
                    color: "#fff"
                    font.pixelSize: 18
                    text: qsTr("Başarılı")
                }
            }
        }

        Column{
            id:tableColumn
            width: (parent.width-columnFilter.width-pageRow.spacing-30)
            height: parent.height-30
//            ListView{
//                   width: parent.width
//                   height: parent.height
//                   model:ListModel{
//                       id:listmodel
//                   }

//                   delegate:Item{
//                       id:item
//                       width:parent.width
//                       height: 50
//                        ListElement{
//                            type:"name"
//                        }
//                   }
//            }

            TableView{
//                visible:false
                id:salesTable
                width: parent.width
                height:parent.height

                implicitWidth: 100
                implicitHeight: 60

                model:ListModel{
                    id:tableModel
                }
                TableViewColumn{
                    role:"receipt_no"
                    title:"Receipt ID"
                    width:100
                }
                TableViewColumn{
                    role:"date_"
                    title:"Tarih"
                    width:100
                }
                TableViewColumn{
                    role:"name"
                    title:"İsim"
                    width:100
                }
                TableViewColumn{
                    role:"explanation"
                    title:"Açıklama"
                    width:150
                }
                TableViewColumn{
                    role:"paid_amount"
                    title:"Toplam Tutar"
                    width:100
                }
            }
        }
    }
}

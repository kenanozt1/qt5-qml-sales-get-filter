import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 1.4
import variables.manager 1.0

ApplicationWindow {
    id:calendarWindow
    width: 600
    height: 600
    title:"Tarih Seç"
    x:(mainWindow.width/2)-(calendarWindow.width/2)+mainWindow.x
    y:(mainWindow.height/2)-(calendarWindow.height/2)+mainWindow.y


    property int buttonheight:(height*10/100) > 30 ? (height*10/100) : 30

    signal sendData(var message)

    Column{
        id:dialogColumn
        anchors.fill:parent
        Component.onCompleted: {
            if(variables.getDateType() === "first"){
               calendarWindow.title = "Başlangıç Tarihini Seçin"
                if(!isNaN(variables.getMaxDate())){
                    dateCalendar.maximumDate = variables.getMaxDate();
                }
            }else{
                calendarWindow.title = "Bitiş Tarihini Seçin"
                if(!isNaN(variables.getMinDate())){
                    dateCalendar.minimumDate = variables.getMinDate();
                }
            }
        }

        Calendar{
            id:dateCalendar
            locale:Qt.locale("tr-TR")
            width:parent.width
            height:(parent.height-buttonheight)
            onSelectedDateChanged: {
                if(!variables.getDateType() === "first"){
                    dateCalendar.minimumDate = variables.getMinDate();
                }
            }
        }

        Row{
            id:buttonRow
            height:buttonheight
            Button{
                id:selectDate
                text: "Seç"
                width:(calendarWindow.width/2)
                height: parent.height
                onClicked: {
                    calendarWindow.sendData(Qt.formatDateTime(dateCalendar.selectedDate,"dd/MM/yyyy"))
                    if(variables.getDateType() === "first"){
                        variables.setFirstDate(Qt.formatDateTime(dateCalendar.selectedDate,"yyyy-MM-dd"))

                        variables.setMinDate(dateCalendar.selectedDate);
                    }else{
                        variables.setLastDate(Qt.formatDateTime(dateCalendar.selectedDate,"yyyy-MM-dd"))

                        variables.setMaxDate(dateCalendar.selectedDate);
                    }
                    calendarWindow.close()
                }
            }

            Button{
                id:cancelDate
                text: "İptal"
                width:(calendarWindow.width/2)
                height: parent.height
                onClicked: {
                    console.log("İptal Edildi")
                    calendarWindow.close()
                }
            }
        }
    }
}

#include "databasemanager.h"

#include <QDebug>
#include <QtSql/QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDate>
#include <QStringList>
#include <QString>
#include <QVariant>
DatabaseManager::DatabaseManager(QObject *parent) : QObject(parent)
{
    connetToDatabase();
}

DatabaseManager::~DatabaseManager()
{
    if(db.isOpen())
        db.close();
}

void DatabaseManager::connetToDatabase()
{
    if(!db.isValid())
        db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("../../sales_date_filter.db");
    if(!db.open()){
        qDebug() << "Veri Tabanı Bağlantısı Başarısız";
        return;
    }
    qDebug() << "Veri Tabanı Bağlantısı Başarılı";
}

QVariantList DatabaseManager::selectReceiptInfo(QDate firstDate, QDate lastDate)
{
    QVariantList result;

    if(!firstDate.isValid()){
        qDebug() << "Başlangıç Tarihi Seçin!";
    }else if(!lastDate.isValid()){
        qDebug() << "Bitiş Tarihi Seçin!";
    }else if(lastDate < firstDate){
        qDebug() << "Bitiş günü başlangıç gününden önce olamaz!";
    }else if(firstDate == lastDate){
        qDebug() << "Başlangıç günü ve bitiş günü aynı gün olamaz";
    }else{
        if(!db.isOpen())
            return result;
        QString queryString = QString("SELECT * FROM getReceiptInfo");
        QSqlQuery query;
        if(query.exec(queryString)){
            while (query.next()) {
                QString year = query.value("date_").toString().split("-")[0];
                QString mounth = query.value("date_").toString().split("-")[1];
                QString day = query.value("date_").toString().split("-")[2];

                QDate queryDate = QDate(year.toInt(),mounth.toInt(),day.toInt());
                if((queryDate >= firstDate) && (queryDate <= lastDate)){
                    QVariantMap row;
                    row["receipt_no"]= query.value("receipt_no").toString();
                    row["date_"]= query.value("date_").toString();
                    row["name"]= query.value("name").toString();
                    row["explanation"]= query.value("explanation").toString();
                    row["paid_amount"]= query.value("paid_amount").toString();
                    result.append(row);
                }
            }
        }else{
            sqlErrorType(QSqlError::ErrorType(),query.lastError().text());
        }
    }
    return result;
}

QVariantList DatabaseManager::getSalesData(QString quantity, QString order)
{
    QVariantList result;
    QString queryString;
    if(!db.isOpen())
        return result;

    if(quantity == ""){
        queryString = QString("SELECT * FROM getReceiptInfo");
    }else{
        queryString = QString("SELECT * FROM getReceiptInfo ORDER BY receipt_no "+order +" LIMIT "+quantity);
    }

    QSqlQuery query;
    if(query.exec(queryString)){
        while (query.next()) {

            QVariantMap row;
            row["receipt_no"]= query.value("receipt_no").toString();
            row["date_"]= query.value("date_").toString();
            row["name"]= query.value("name").toString();
            row["explanation"]= query.value("explanation").toString();
            row["paid_amount"]= query.value("paid_amount").toString();
            result.append(row);
        }
    }else{
        sqlErrorType(QSqlError::ErrorType(),query.lastError().text());
    }
    return result;
}

void DatabaseManager::sqlErrorType(qint32 errorType, QString lastError)
{
    switch (errorType) {
        case 0:
            qDebug() << "Sorgu Hatası : No error occurred.";
        break;
        case 1:
            qDebug() << "Sorgu Hatası : Connection error.";
        break;
        case 2:
            qDebug() << "Sorgu Hatası : SQL statement syntax error.";
        break;
        case 3:
            qDebug() << "Sorgu Hatası : Transaction failed error.";
        break;
        case 4:
            qDebug() << "Sorgu Hatası : Unknown error.";
        break;
        default:
            qDebug() << "Sorgu Hatası :" + lastError;
    }
}

QVariant DatabaseManager::data(const QModelIndex &index, int role)
{
    //
}

QHash<int, QByteArray> DatabaseManager::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[RECEİPTNO] = "receipt_no";
    roles[DATE] = "date_";
    roles[NAME] = "name";
    roles[EXPLANATİON] = "explanation";
    roles[AMOUNT] = "paid_amount";
    return roles;
}


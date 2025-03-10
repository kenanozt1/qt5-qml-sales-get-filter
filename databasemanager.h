#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include "QtSql/QSqlDatabase"
#include <QDate>
#include <QStandardItemModel>
#include <QVariantList>
class DatabaseManager : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();
    void connetToDatabase();
    Q_INVOKABLE QVariantList selectReceiptInfo(QDate firstDate, QDate lastDate);
    Q_INVOKABLE QVariantList getSalesData(QString quantity = "", QString order = "ASC");
    void sqlErrorType(qint32 errorType,QString lastError);

    QVariant data(const QModelIndex &index, int role);
    QHash<int,QByteArray> roleNames() const;
    enum salesRoles{
        RECEİPTNO,
        DATE,
        NAME,
        EXPLANATİON,
        AMOUNT
    };


private:
    QSqlDatabase db;

signals:
public slots:
};

#endif // DATABASEMANAGER_H

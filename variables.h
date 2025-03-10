#ifndef VARIABLES_H
#define VARIABLES_H

#include <QObject>
#include <QDate>
#include <QDebug>
#include <QQuickItem>

class Variables : public QObject
{
    Q_OBJECT
public:
    explicit Variables(QObject *parent = nullptr);
    Q_INVOKABLE void setDateType(QString type);
    Q_INVOKABLE QString getDateType();

    Q_INVOKABLE QDate getFirstDate();
    Q_INVOKABLE void setFirstDate(QDate date);

    Q_INVOKABLE QDate getLastDate();
    Q_INVOKABLE void setLastDate(QDate date);

    Q_INVOKABLE void setMinDate(QDate date);
    Q_INVOKABLE QDate getMinDate();

    Q_INVOKABLE void setMaxDate(QDate date);
    Q_INVOKABLE QDate getMaxDate();


private:
    QDate firstDate = *new QDate();
    QDate lastDate = *new QDate();
    QDate maxDate = *new QDate();
    QDate minDate = *new QDate();
    QString dateType = "";
signals:


public slots:
};

#endif // VARIABLES_H

#include "variables.h"

Variables::Variables(QObject *parent) : QObject(parent)
{

}

void Variables::setDateType(QString type)
{
    dateType = type;
}

QString Variables::getDateType()
{
    return dateType;
}

QDate Variables::getFirstDate()
{
    return firstDate;
}

void Variables::setFirstDate(QDate date)
{
    firstDate = date;
}

QDate Variables::getLastDate()
{
    return lastDate;
}

void Variables::setLastDate(QDate date)
{
    lastDate = date;
}

void Variables::setMinDate(QDate date)
{
    minDate = date.addDays(1);
}

QDate Variables::getMinDate()
{
    return minDate;
}

void Variables::setMaxDate(QDate date)
{
    maxDate = date;
}

QDate Variables::getMaxDate()
{
    return maxDate.addDays(-1);
}

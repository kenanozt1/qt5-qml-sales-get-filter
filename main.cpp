#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "databasemanager.h"
#include "variables.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<DatabaseManager>("database.manager",1,0,"DatabaseManager");
    qmlRegisterType<Variables>("variables.manager",1,0,"Variables");


    QQmlApplicationEngine engine;

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

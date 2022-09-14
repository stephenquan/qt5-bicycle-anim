#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QJsonDocument>
#include <QDebug>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QFile appInfoFile(":/appinfo.json");
    appInfoFile.open(QIODevice::ReadOnly);
    QString appInfoText = appInfoFile.readAll();
    QVariantMap appInfo = QJsonDocument::fromJson(appInfoText.toUtf8()).toVariant().toMap();
    QVariantMap appInfoVersion = appInfo["version"].toMap();
    int appInfoMajor = appInfoVersion["major"].toInt();
    int appInfoMinor = appInfoVersion["minor"].toInt();
    int appInfoMicro = appInfoVersion["micro"].toInt();
    QString appInfoVersionString = QString::number(appInfoMajor) + "." + QString::number(appInfoMinor) + "." + QString::number(appInfoMicro);
    appInfo["versionString"] = appInfoVersionString;

    QFile itemInfoFile(":/iteminfo.json");
    itemInfoFile.open(QIODevice::ReadOnly);
    QString itemInfoText = itemInfoFile.readAll();
    QVariantMap itemInfo = QJsonDocument::fromJson(itemInfoText.toUtf8()).toVariant().toMap();

    QQmlApplicationEngine engine;
    QQmlContext* rootContext = engine.rootContext();
    rootContext->setContextProperty("qtVersion", QString::fromUtf8(qVersion()));
    rootContext->setContextProperty("appInfo", appInfo);
    rootContext->setContextProperty("itemInfo", itemInfo);
    const QUrl url(QStringLiteral("qrc:/qt5app-main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

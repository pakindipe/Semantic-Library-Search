#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "ResultModel.h"
#include "searchController.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ResultsModel resultsModel;
    SearchController searchController(&resultsModel);
    engine.rootContext()->setContextProperty("resultsModel", &resultsModel);
    engine.rootContext()->setContextProperty("searchController", &searchController);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("LibrarySemanticSearch", "Main");

    return app.exec();
}

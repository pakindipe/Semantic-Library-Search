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
    ResultsModel popularModel;
    SearchController searchController(&resultsModel);
    engine.rootContext()->setContextProperty("resultsModel", &resultsModel);
    engine.rootContext()->setContextProperty("popularModel", &popularModel);
    engine.rootContext()->setContextProperty("searchController", &searchController);
    engine.rootContext()->setContextProperty("appDir", QCoreApplication::applicationDirPath());

    QObject::connect(&searchController,
                     &SearchController::popularReady,
                     &popularModel,
                     &ResultsModel::setResults);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("LibrarySemanticSearch", "Main");

    return app.exec();
}

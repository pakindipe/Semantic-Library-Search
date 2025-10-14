// GUI Files/RegisterSearch.cpp
#include <QtQml/qqml.h>     // qmlRegisterSingletonType
#include <QQmlEngine>
#include <QJSEngine>

#include "../core/SearchService.h"

// Factory for the singleton object used from QML
static QObject* createSearchSingleton(QQmlEngine*, QJSEngine*) {
    return new SearchService();
}

// Portable static-initializer that runs before main()
// (avoids Q_COREAPP_STARTUP_FUNCTION macro entirely)
namespace {
struct RegisterSearchAtStartup {
    RegisterSearchAtStartup() {
        qmlRegisterSingletonType<SearchService>(
            "LibrarySemanticSearch", 1, 0, "Search", &createSearchSingleton);
    }
} _registerSearchAtStartup; // NOLINT: global instance to trigger registration
} // namespace

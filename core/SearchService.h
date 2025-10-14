#pragma once
#include <QObject>
#include <QVariant>
#include "SearchBridge.h"

// Thin QObject wrapper so QML can call:  Search.search("query")
class SearchService : public QObject {
    Q_OBJECT
public:
    explicit SearchService(QObject* parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QVariant search(const QString& query) {
        QString err;
        QVariant v = SearchBridge::search(query, &err);
        if (!err.isEmpty()) {
            QVariantMap m; m["error"] = err; return m;
        }
        return v;
    }
};

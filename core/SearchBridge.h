#pragma once
#include <QString>
#include <QVariant>

// Calls the Python script with a query.
// Returns QVariantMap { "query": QString, "results": QVariantList }.
// On error, returns {} and writes a message to errorOut.
class SearchBridge {
public:
    static QVariant search(const QString& query, QString* errorOut = nullptr);
};

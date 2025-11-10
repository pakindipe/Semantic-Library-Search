#pragma once
#include <QObject>
#include <QVector>
#include "ResultModel.h"
#include "book.h"
#include "bookConversion.h"

class SearchController : public QObject {
    Q_OBJECT
public:
    explicit SearchController(ResultsModel* model, QObject* parent = nullptr);

    // Call from QML: searchController.search("dune")
    Q_INVOKABLE void search(const QString& query);

    // Call once to load demo data regardless of query
    Q_INVOKABLE void loadDemo();

private:
    ResultsModel* m_model;

    QVector<BookDTO> buildDemoData() const;
    QVector<BookDTO> filterByQuery(const QVector<BookDTO>& all, const QString& q) const;
};

#pragma once
#include <QObject>
#include <QVector>
#include "ResultModel.h"
#include "book.h"
#include "bookConversion.h"
#include <QProcess>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

#include <QProcess>
class SearchController : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool backendReady READ backendReady NOTIFY backendReadyChanged)
public:
    explicit SearchController(ResultsModel* model, QObject* parent = nullptr);
    bool backendReady()  { return m_backendready; }
    Q_INVOKABLE void search(const QString& query);
    Q_INVOKABLE void initialBooks();


private slots:
    void handleOutput();
signals:
    void resultsReady(QVariantList results);
    void popularReady(const QVector<BookDTO>& rows);
    void backendReadyChanged();


private:
    ResultsModel* m_model;
    QProcess *process = nullptr;
    QByteArray buffer;
    QVector<BookDTO> buildDemoData() const;
    QVector<BookDTO> filterByQuery(const QVector<BookDTO>& all, const QString& q) const;
   bool  m_bootstrapping = true;
   bool m_backendready = false;
};

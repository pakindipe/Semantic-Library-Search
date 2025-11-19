#include "searchcontroller.h"
#include <algorithm>
#include <QProcess>
#include <QJsonObject>
#include <QJsonDocument>

SearchController::SearchController(ResultsModel* model, QObject* parent): QObject(parent), m_model(model)
    {
        process = new QProcess(this);
        process->setProcessChannelMode(QProcess::SeparateChannels);
        process->start("python", {"all_in_one.py"});
        connect(process, &QProcess::readyReadStandardOutput, this, &SearchController::handleOutput);
        connect(process, &QProcess::readyReadStandardError, this, [this]{
            qWarning().noquote() << process->readAllStandardError();
        });
        connect(process, &QProcess::errorOccurred, this, [](QProcess::ProcessError e){
            qWarning() << "search proc error" << e;
        });
        const bool ok = process->waitForStarted(3000);
        qInfo() << "[proc] started?" << ok << "state=" << process->state() << "pid=" << process->processId();

        // qInfo("Python started");
    };

void SearchController::handleOutput() {
    buffer += process->readAllStandardOutput();
    int nl;
    while ((nl = buffer.indexOf('\n')) != -1) {
        const QByteArray oneLine = buffer.left(nl);
        buffer.remove(0, nl + 1);

        QJsonParseError err{};
        const QJsonDocument doc = QJsonDocument::fromJson(oneLine, &err);
        qDebug() << doc;
        if (err.error != QJsonParseError::NoError || !doc.isObject()) continue;
        const QJsonObject obj = doc.object();

        if (obj.contains(QStringLiteral("flag"))) {
            const QString flag = obj.value(QStringLiteral("flag")).toString();
            qInfo() << "[proc] flag received:" << flag;
            if (flag.compare(QStringLiteral("model is loaded"), Qt::CaseInsensitive) == 0) {
                if (!m_backendready) {
                    m_backendready = true;
                    emit backendReadyChanged();
                    qInfo() << "[proc] backend marked ready";
                }
            }
            continue;
        }

        const QJsonArray arr = obj.value(QStringLiteral("result:")).toArray();

        QVector<BookDTO> rows;
        rows.reserve(arr.size());
        for (const QJsonValue &v : arr) {
            const QJsonObject o = v.toObject();
            Book b{
                o.value("title").toString().toStdString(),
                o.value("author").toString().toStdString(),
                o.value("year_published").toInt(),
                o.value("desc").toString().toStdString(),
                o.value("genre").toString().toStdString(),
                o.value("filename").toString().toStdString(),
                true,
            };

            rows.push_back(bookConvert(b));
        }
        if (m_bootstrapping) {
            m_bootstrapping = false;
            emit popularReady(rows);      // for popularModel
            qDebug() << "Initial Books Signalled\n";
        } else {
            m_model->setResults(rows);
            qDebug() << "Result Model Set\n";
        }
    }
}


void SearchController::search(const QString& query) {
    qInfo() << "[ui] search() invoked with =" << query;
    if (!process || process->state() != QProcess::Running) {
        qWarning() << "[proc] not running";
        return;
    }

    QJsonObject msg{
        {QStringLiteral("req_id"), 1},
        {QStringLiteral("op"),     QStringLiteral("query")},
        {QStringLiteral("payload"), query}
    };
    const QByteArray jsonl = QJsonDocument(msg).toJson(QJsonDocument::Compact) + '\n';

    const qint64 n = process->write(jsonl);
    qInfo() << "[proc][stdin] wrote bytes=" << n
            << "jsonl_preview=" << QString::fromUtf8(jsonl.left(160));
    if (n == -1) {
        qWarning() << "[proc] write failed";
        return;
    }
    if (!process->waitForBytesWritten(1000))
        qWarning() << "[proc] waitForBytesWritten timeout";
}


void SearchController::initialBooks() {
    qInfo() << "[ui] search() invoked with Initial Books";
    if (!process || process->state() != QProcess::Running) {
        qWarning() << "[proc] not running";
        return;
    }

    QJsonObject msg{
        {QStringLiteral("req_id"), 1},
        {QStringLiteral("op"),     QStringLiteral("homepage_display")},
        {QStringLiteral("payload"), QStringLiteral("query")}
    };
    const QByteArray jsonl = QJsonDocument(msg).toJson(QJsonDocument::Compact) + '\n';

    const qint64 n = process->write(jsonl);
    qInfo() << "[proc][stdin] wrote bytes=" << n
            << "jsonl_preview=" << QString::fromUtf8(jsonl.left(160));
    if (n == -1) {
        qWarning() << "[proc] write failed";
        return;
    }
    if (!process->waitForBytesWritten(1000))
        qWarning() << "[proc] waitForBytesWritten timeout";
}

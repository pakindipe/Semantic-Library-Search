#include "SearchBridge.h"

#include <QProcess>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStringList>
#include <QDebug>

#ifndef PY_SCRIPT_PATH
#define PY_SCRIPT_PATH "python_interface.py" // CMake overrides this with an absolute path
#endif

// --- Choose which Python to run ------------------------------------------------
static QString pythonExe()
{
    // If "python" works in your terminal, leave this as-is:
    return QStringLiteral("python");

    // Or hardcode your interpreter (uncomment & adjust):
    // return QStringLiteral("C:/Users/vikra/AppData/Local/Programs/Python/Python313/python.exe");
}
// ------------------------------------------------------------------------------

// Accept either JSON (`{"query": "...","results":[...]}`) or plain line-per-result.
static QVariantMap parsePythonOutput(const QByteArray& rawStdout)
{
    QVariantMap out;
    const QString text = QString::fromUtf8(rawStdout).trimmed();

    // Try JSON first
    QJsonParseError jerr{};
    const QJsonDocument doc = QJsonDocument::fromJson(text.toUtf8(), &jerr);
    if (jerr.error == QJsonParseError::NoError && doc.isObject()) {
        out = doc.object().toVariantMap();
        return out;
    }

    // Fallback: split lines into a simple list of titles
    QVariantList results;
    const QStringList lines = text.split('\n', Qt::SkipEmptyParts);
    for (const QString& line : lines)
        results.push_back(line.trimmed());
    out.insert("results", results);
    return out;
}

QVariant SearchBridge::search(const QString& query, QString* errorOut)
{
    QProcess p;
    p.setProgram(pythonExe());
    p.setArguments({ QStringLiteral(PY_SCRIPT_PATH), query });

    // IMPORTANT: keep stdout and stderr separate; we only parse stdout.
    p.setProcessChannelMode(QProcess::SeparateChannels);

    p.start();
    if (!p.waitForStarted(5000)) {
        if (errorOut) *errorOut = QStringLiteral("Failed to start Python process.");
        return {};
    }

    // Generous timeout because first run may download a model.
    if (!p.waitForFinished(60000)) {
        p.kill();
        if (errorOut) *errorOut = QStringLiteral("Python process timed out.");
        return {};
    }

    const QByteArray outStd = p.readAllStandardOutput().trimmed();
    const QByteArray outErr = p.readAllStandardError();

    // Optional: log stderr to the console for debugging (won't affect parsing)
    if (!outErr.isEmpty())
        qWarning().noquote() << "[python stderr]" << QString::fromUtf8(outErr);

    if (outStd.isEmpty()) {
        if (errorOut) *errorOut = QStringLiteral("Python returned no data.");
        return {};
    }

    QVariantMap map = parsePythonOutput(outStd);
    map.insert("query", query);
    return map;
}

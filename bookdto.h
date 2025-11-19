#pragma once
#include <QString>
#include <QStringList>
#include <QDate>

struct BookDTO {
    QString id;
    QString title;
    QString author;
    QDate   releaseDate;
    QString description;
    QString genres;
    QString filename;
    bool available = false;
};

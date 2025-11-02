#pragma once
#include <QAbstractListModel>
#include "bookdto.h"

class ResultsModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)


public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        AuthorRole,
        ReleaseRole,
        DescriptionRole,
        GenresRole,
        AvailableRole
    };
    explicit ResultsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void clear();
    void setResults(const QVector<BookDTO> &newResults);
    
signals:
    void countChanged();

private:
    QVector<BookDTO> m_books;
};

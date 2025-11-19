#pragma once
#include <QAbstractListModel>
#include "bookdto.h"

class ResultsModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)
    Q_PROPERTY(int totalCount READ totalCount NOTIFY totalCountChanged)
    Q_PROPERTY(int page READ page WRITE setPage NOTIFY pageChanged)
    Q_PROPERTY(int totalPages READ totalPages NOTIFY totalPagesChanged)

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        AuthorRole,
        ReleaseRole,
        DescriptionRole,
        GenresRole,
        AvailableRole,
        FilenameRole
    };
    explicit ResultsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int totalCount() const { return m_books.size(); }

    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void clear();
    void setResults(const QVector<BookDTO> &newResults);
    void rebuildMap();
    
    int page() const {return m_page;}
    int totalPages() const;
    int pageSize() const {return m_pageSize;}
    Q_INVOKABLE void setPage(int p);
    Q_INVOKABLE void nextPage();
    Q_INVOKABLE void prevPage();
    Q_INVOKABLE void lastPage();
    Q_INVOKABLE void firstPage();

signals:
    void countChanged();
    void totalCountChanged();
    void pageChanged();
    void totalPagesChanged();
    void pageSizeChanged();

public slots:
    void setFilter(QString filter);


private:
    QVector<BookDTO> m_books;
    QVector<int> m_map;
    QString filter;
    int m_page = 1;
    int m_pageSize = 10;

    int offset() const {return (m_page - 1) * m_pageSize;}
};

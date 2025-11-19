#include "ResultModel.h"

ResultsModel::ResultsModel(QObject *parent) : QAbstractListModel(parent) {}

int ResultsModel::rowCount(const QModelIndex &) const {
    int offset = this->offset();
    int remaining = m_map.size() - offset;
    if (remaining <= 0) return 0;
    return remaining < m_pageSize ? remaining : m_pageSize;
}

QVariant ResultsModel::data(const QModelIndex &index, int role) const {
    int i = index.row() + offset();
    if (!index.isValid() || i >= m_map.size() || i < 0) return {};
    const BookDTO &b = m_books[m_map[i]];
    switch (role) {
    case IdRole: return b.id;
    case TitleRole: return b.title;
    case AuthorRole: return b.author;
    case ReleaseRole: {
        QDate date = b.releaseDate;
    if (!date.isValid()) {
        qDebug() << "Invalid QDate for" << b.releaseDate;
    } else {
        qDebug() << "Valid QDate:" << date.toString(Qt::ISODate);
    }
    return date;
    }
    //return b.releaseDate;
    case DescriptionRole: return b.description;
    case GenresRole: return b.genres;
    case AvailableRole: return b.available;
    case FilenameRole: return b.filename;
    }
    return {};
}

QHash<int, QByteArray> ResultsModel::roleNames() const {
    return {
        {IdRole, "id"},
        {TitleRole, "title"},
        {AuthorRole, "author"},
        {ReleaseRole, "releaseDate"},
        {DescriptionRole, "description"},
        {GenresRole, "genres"},
        {AvailableRole, "available"},
        {FilenameRole, "filename"}
    };
}

void ResultsModel::clear() {
    beginResetModel();
    m_books.clear();
    m_page = 1;
    endResetModel();
    emit countChanged();
    emit totalCountChanged();
    emit totalPagesChanged();
}

void ResultsModel::setResults(const QVector<BookDTO> &newResults) {
    beginResetModel();
    m_books = newResults;
    rebuildMap();
    m_page = 1;
    endResetModel();
    emit countChanged();
    emit totalCountChanged();
    emit totalPagesChanged();
}

int ResultsModel::totalPages() const {
    return m_pageSize <= 0 ? 0 : (m_books.size() + m_pageSize - 1) / m_pageSize;
}

void ResultsModel::setPage(int p) {
    int tp = totalPages();
    if (p < 1) p = 1;
    else if (tp < p && tp > 0) p = tp;
    if (p == m_page) return;

    beginResetModel();
    m_page = p;
    endResetModel();

    emit pageChanged();
    emit countChanged();
}

void ResultsModel::setFilter(QString f) {
    if (filter == f) return;
    filter = std::move(f); // deep copy just in case shenanigans
    qInfo() << f;
    beginResetModel();        // or layoutAboutToBeChanged/layoutChanged
    rebuildMap();
    endResetModel();
}

void ResultsModel::rebuildMap() {
    m_map.clear();
    for (int i = 0; i < m_books.size(); ++i) {
        const auto& b = m_books[i];
        if (filter == "" ||
            filter == "Ascending" ||
            filter == "Descending" ||
            b.title.contains(filter) ||
            b.author.contains(filter) == true ||
            b.genres == filter)  m_map.push_back(i);
        if (filter == "Ascending") {
            std::sort(m_map.begin(), m_map.end(),
                      [&](int a, int b) {
                          return m_books[a].releaseDate < m_books[b].releaseDate;
                      });
        }
        if (filter == "Descending") {
            std::sort(m_map.begin(), m_map.end(),
                      [&](int a, int b) {
                          return m_books[a].releaseDate > m_books[b].releaseDate;
                      });
        }
    }
}

void ResultsModel::nextPage() {setPage(m_page + 1);}

void ResultsModel::prevPage() {setPage(m_page - 1);}

void ResultsModel::firstPage() {setPage(1);}

void ResultsModel::lastPage() {setPage(totalPages());}

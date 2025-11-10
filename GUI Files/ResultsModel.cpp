#include "ResultModel.h"

ResultsModel::ResultsModel(QObject *parent) : QAbstractListModel(parent) {}

int ResultsModel::rowCount(const QModelIndex &) const { return m_books.size(); }

QVariant ResultsModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_books.size()) return {};
    const BookDTO &b = m_books[index.row()];
    switch (role) {
    case IdRole: return b.id;
    case TitleRole: return b.title;
    case AuthorRole: return b.author;
    case ReleaseRole: return b.releaseDate;
    case DescriptionRole: return b.description;
    case GenresRole: return b.genres;
    case AvailableRole: return b.available;
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
        {AvailableRole, "available"}
    };
}

void ResultsModel::clear() {
    beginResetModel();
    m_books.clear();
    endResetModel();
    emit countChanged();
}

void ResultsModel::setResults(const QVector<BookDTO> &newResults) {
    beginResetModel();
    m_books = newResults;
    endResetModel();
    emit countChanged();
}

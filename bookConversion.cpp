#include "bookConversion.h"
#include <QStringList>

BookDTO bookConvert(Book& b) {
    BookDTO dto;
    dto.id = QString::fromStdString(b.getTitle());
    dto.title = QString::fromStdString(b.getTitle());
    dto.author = QString::fromStdString(b.getAuthor());
    auto d = b.getReleaseDate();
    dto.releaseDate = QDate(d.getYear(), d.getMonth(), d.getDay());
    dto.description = QString::fromStdString(b.getDescription());
    dto.genres = QString::fromStdString(b.getGenres());
    dto.filename = QString::fromStdString(b.getFilename());
    dto.available = b.getAvailability();
    return dto;
}

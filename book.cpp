#include <string>
#include "date.h"
#include "book.h"

    Book::Book(std::string title, std::string author, int year, int month, int day,
               std::string description, std::string genres, bool availability)
        : Title(std::move(title)),
        Author(std::move(author)),
        Release_Date(Date(year, month, day)),
        Description(std::move(description)),
        Genres(std::move(genres)),
        Availability(availability) {}

    Book::Book(std::string title,std::string author, int year, std::string description, std::string genres, std::string filename, bool availability)
        : Title(std::move(title)), Author(std::move(author)), Release_Date(Date(year)), Description(std::move(description)), Genres(std::move(genres)), Filename(std::move(filename)), Availability(availability) {}

    void Book::setTitle(std::string title)
    {
        Title = title;
    }

    const std::string& Book::getTitle()const
    {
        return Title;
    }

    void Book::setAuthor(std::string author)
    {
        Author = author;
    }

    const std::string& Book::getAuthor() const
    {
        return Author;
    }

    void Book::setDescription(std::string description)
    {
        Description = description;
    }

    const std::string& Book::getDescription()const
    {
        return Description;
    }

    void Book::setGenres(std::string genres)
    {
        Genres = genres;
    }

    const std::string& Book::getGenres()const
    {
        return Genres;
    }

    void Book::setAvailability(bool availability)
    {
        Availability = availability;
    }

    bool Book::getAvailability()const
    {
        return Availability;
    }

    Date Book::getReleaseDate() const
    {
        return Release_Date;
    }
    //Add check for if valid date
    void Book::setDate(int year, int month, int day)
    {
        Release_Date.setYear(year);
        Release_Date.setMonth(month);
        Release_Date.setDay(day);
    }

    void Book:: setFilename(std::string filename) {
        Filename = filename;
    }

    const std::string& Book::getFilename() const {
        return Filename;
    }

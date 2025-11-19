#ifndef BOOK_H
#define BOOK_H

#include <string>
#include <vector>
#include "date.h"

class Book {
private:
    std::string Title;
    std::string Author;
    Date Release_Date;
    std::string Description;
    std::string Genres;
    std::string Filename;
    bool Availability;

public:
    // Constructor
    Book(std::string title,
         std::string author,
         int year,
         int month,
         int day,
         std::string description,
         std::string genres,
         bool availability = 0);

    Book(std::string title,
         std::string author,
         int year,
         std::string description,
         std::string genres,
         std::string filename,
         bool availability = 0);

    // Setters
    void setTitle(std::string title);
    void setAuthor(std::string author);
    void setDescription(std::string description);
    void setGenres(std::string genres);
    void setAvailability(bool availability);
    void setDate(int year, int month, int day);
    void setFilename(std::string filename);

    // Getters
    const std::string& getTitle() const;
    const std::string& getAuthor() const;
    const std::string& getDescription() const;
    const std::string& getGenres() const;
    const std::string& getFilename() const;
    bool getAvailability() const;
    Date getReleaseDate() const;

    void addGenre(std::string genre);
    void removeGenre(std::string genre);
};

#endif // BOOK_H

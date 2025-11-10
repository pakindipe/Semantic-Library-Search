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
    std::vector<std::string> Genres;
    bool Availability;

public:
    // Constructor
    Book(std::string title,
         std::string author,
         int year,
         int month,
         int day,
         std::string description,
         std::vector<std::string> genres,
         bool availability);

    // Setters
    void setTitle(std::string title);
    void setAuthor(std::string author);
    void setDescription(std::string description);
    void setGenres(std::vector<std::string> genres);
    void setAvailability(bool availability);
    void setDate(int year, int month, int day);

    // Getters
    const std::string& getTitle() const;
    const std::string& getAuthor() const;
    const std::string& getDescription() const;
    const std::vector<std::string>& getGenres() const;
    bool getAvailability() const;
    Date getReleaseDate() const;

    void addGenre(std::string genre);
    void removeGenre(std::string genre);
};

#endif // BOOK_H

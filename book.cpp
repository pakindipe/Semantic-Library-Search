#include <iostream>
#include <string>
#include <vector>
#include "date.h"
#include "book.h"

class Book
{
    private:
        std::string Title;
        std::string Author;
        Date Release_Date;
        std::string Description;
        std::vector<std::string> Genres;
        bool Availability;
    public:
        Book(std::string title, std::string author, int year, int month, int day, std::string description, std::vector<std::string> genres, bool availability): 
        Title(std::move(title)),
        Author(std::move(author)),
        Release_Date(Date(year, month, day)),
        Description(std::move(description)),
        Genres(std::move(genres)),
        Availability(availability) {}
        

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

        const std::string& Book::getAuthor()
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

        void Book::setGenres(std::vector<std::string> genres)
        {
            Genres = genres;
        }

        const std::vector<std::string>& Book::getGenres()const
        {
            return Genres;
        }

        void Book::addGenre(std::string new_genre)
        {
            //Check if genre has already been added
            for (std::string genre: Genres)
            {
                if (genre != new_genre)
                {
                    Genres.push_back(new_genre);
                    std::cout << "Genre has been added\n";
                    return;
                }
            }
            std::cout << "Genre is already in vector\n";
            return;
        }

        void Book::removeGenre(std::string remove_genre)
        {
            //Check if genre is in vector
            for (std::string genre: Genres)
            {
                if (genre == remove_genre)
                {
                    Genres.pop_back();
                    std::cout << "Genre has been removed\n";
                    return;
                }
            }
            std::cout << "Genre was not found\n";
            return;
        }

        void Book::setAvailability(bool availability)
        {
            Availability = availability;
        }

        const bool Book::getAvailability()const
        {
            return Availability;
        }

        const Date Book::getReleaseDate() const
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

};
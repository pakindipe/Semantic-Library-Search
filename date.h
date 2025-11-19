#ifndef DATE_H
#define DATE_H

class Date {
private:
    int Year;
    int Month;
    int Day;

public:
    // Constructor
    Date(int year, int month, int day);
    Date(int year);

    // Getters
    int getYear() const;
    int getMonth() const;
    int getDay() const;

    // Setters
    void setYear(int year);
    void setMonth(int month);
    void setDay(int day);

    // Comparison
    bool isBefore(const Date& date) const;
};

#endif // DATE_H

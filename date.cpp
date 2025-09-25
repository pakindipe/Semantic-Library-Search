#include <iostream>
#include "date.h"

class Date
{
    private:
        int Year;
        int Month;
        int Day;
    public:
        Date (int year, int month, int day):
        Year(std::move(year)),
        Month(std::move(month)),
        Day(std::move(day)) {}

        const int Date::getYear()const
        {
            return Year;
        }

        const int Date::getMonth() const
        {
            return Month;
        }

        const int Date::getDay() const
        {
            return Day;
        }

        void Date::setYear(int year)
        {
            Year = year;
        }

        void Date::setMonth(int month)
        {
            Month = month;
        }

        void Date::setDay(int day)
        {
            Day = day;
        }

        //Returns true if the date the method is called occurs before the input date
        bool Date::isBefore(Date date)
        {
            if (Year < date.Year)
            {
                return true;
            }
            else if (Year == date.Year)
            {
                if (Month < date.Month)
                {
                    return true;
                }
                else if (Month == date.Month)
                {
                    if (Day < date.Day)
                    {
                        return true;
                    }
                    else return false;
                }
            }
            else return false;
        }


};
#include <iostream>
#include "date.h"

        Date::Date(int year, int month, int day)
            : Year(year), Month(month), Day(day) {}

       int Date::getYear()const
       {
           return Year;
       }
       int Date::getMonth() const
       {
           return Month;
       }
       int Date::getDay() const
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
       bool Date::isBefore(const Date& date) const
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
                   else
                       return false;
               }
               else
                    return false;
           }
           else
               return false;
       }

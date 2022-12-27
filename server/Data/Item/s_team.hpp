#ifndef S_TEAM_HPP
#define S_TEAM_HPP

#include <nanodbc/nanodbc.h>
#include <Item/team_item.hpp>

namespace Data
{

struct s_team : public team_item
{
    explicit s_team();

    int companyId{0};

    void read(const nanodbc::result& res);
    void read(const Json::Value& json) { team_item::read(json); }

    const std::string insert() const;
    static const constexpr auto select()
    {
        return "SELECT * "
               "FROM Team ";
    }

};

}

#endif // S_COMPANY_HPP

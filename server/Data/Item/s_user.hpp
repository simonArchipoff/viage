#ifndef S_USER_HPP
#define S_USER_HPP

#include <nanodbc/nanodbc.h>
#include "s_person.hpp"
#include "s_address.hpp"
#include <Item/user_item.hpp>

namespace Data
{
namespace People
{
struct s_user : public user_item
              , public s_person
{
    s_user();

    void read(const nanodbc::result& res);
//    void write(nanodbc::result& res);

protected:
    Places::s_address sa;
};

}
}

#endif // S_USER_HPP

#ifndef S_ADDRESS_HPP
#define S_ADDRESS_HPP

#include <nanodbc/nanodbc.h>

namespace Data
{
namespace Places
{
struct address_item;

struct s_address
{
    explicit s_address(address_item* ai);

    void read(const nanodbc::result& res);
//    void write(nanodbc::result& res);

protected:
    address_item* address;
};

}
}

#endif // S_ADDRESS_HPP

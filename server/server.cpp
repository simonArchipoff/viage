#include <utility>

#include <drogon/drogon.h>

#include "server.hpp"

#define DEFAULT_TIMEOUT 1200

namespace server
{
server& server::get()
{
    static server instance;
    return instance;
}

void server::init(const Json::Value& json_config)
{
    drogon::app().loadConfigJson(json_config);
    drogon::app().enableSession(DEFAULT_TIMEOUT); // force enable session
    drogon::app().run();
}

bool server::user_connected(const std::string& uuid)
{
    if (const auto it{connected_users.find(uuid)}; it != connected_users.end())
    {
        const auto then{trantor::Date::date().after(-DEFAULT_TIMEOUT)};

        if (it->second.last_access < then)
        {
            remove_connected_user(uuid);
            return false;
        }

        return true;
    }

    return false;
}

Data::People::s_user& server::connected_user(const std::string& uuid) noexcept
{
    return std::get<Data::People::s_user>(*connected_users.find(uuid));
}

void server::add_connected_user(const Data::People::s_user& usr,
                                const std::string& uuid)
{
    if (user_connected(uuid)) return;

    connected_users[uuid] = usr;
}

void server::remove_connected_user(const std::string& uuid)
{
    if (!user_connected(uuid)) return;

    connected_users.erase(uuid);
}

drogon::orm::Result server::execute(const std::string &query)
{
    return drogon::app().getDbClient()->execSqlSync(query);
}

void server::execute(const std::vector<std::string> &queries)
{
    for (const auto& query : queries)
        drogon::app().getDbClient()->execSqlSync(query);
}

void server::error_reply(std::function<void (const drogon::HttpResponsePtr &)> &callback)
{
    drogon::HttpResponsePtr resp{drogon::HttpResponse::newHttpResponse()};
    resp->setStatusCode(drogon::k500InternalServerError);
    callback(resp);
}

void server::handle_query(const drogon::HttpRequestPtr& req,
                          std::function<void (const drogon::HttpResponsePtr&)>& callback,
                          const std::function<bool (Json::Value&, const Data::People::s_user&)>& handler)
{
    drogon::HttpResponsePtr resp;
    auto uuid{req->session()->sessionId()};

    if (user_connected(uuid))
    {
        const auto usr{connected_user(uuid)};

        Json::Value json;

        if (handler(json, usr) && usr.clearance > Data::People::user_item::None)
        {
            resp = drogon::HttpResponse::newHttpJsonResponse(json);
        }
        else
        {
            resp = drogon::HttpResponse::newHttpResponse();
            resp->setStatusCode(drogon::k401Unauthorized);
        }
    }
    else
    {
        resp = drogon::HttpResponse::newHttpResponse();
        resp->setStatusCode(drogon::k511NetworkAuthenticationRequired);
    }

    callback(resp);
}

std::vector<std::string> server::combine(const std::string& q1, const std::string& q2)
{
    return {q1, q2};
}

std::vector<std::string> server::combine(std::vector<std::string>& q1, const std::string& q2)
{
    q1.emplace_back(q2);
    return q1;
}

}

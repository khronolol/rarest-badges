-- create a new roblox place, create a new script and insert it in "ServerScriptService", test the game, then look in console
-- remember to enable "Allow HTTP Requests" in game settings

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    local userId = player.UserId
    print(userId)
    local badges = {}
    local cursor = ""
    local hasMoreBadges = true

    while hasMoreBadges do
        local url = "https://badges.roproxy.com/v1/users/"..userId.."/badges?limit=100&sortOrder=Asc&cursor="..cursor
        local response = HttpService:GetAsync(url)
        local data = HttpService:JSONDecode(response)
        wait(0.2)

        for _, badge in ipairs(data.data) do
            table.insert(badges, {
                badgeId = badge.id,
                name = badge.name,
                awardedCount = badge.statistics.awardedCount,
                badgeUrl = "https://roblox.com/badges/"..badge.id.."/"..badge.name:gsub(" ", "-"),
                badgeImageId = badge.iconImageId
            })
        end
        print("Counting badges... "..#badges)

        if data.nextPageCursor then
            cursor = data.nextPageCursor else
            hasMoreBadges = false
        end
    end
    table.sort(badges, function(a, b)
        return a.awardedCount > b.awardedCount
    end)
    print("Badge amount: "..#badges)
    print(badges)

    for i, badge in ipairs(badges) do
        print(string.format("Badge %d:", i))
        print("Name: "..badge.name)
        print("Awarded Count: "..badge.awardedCount)
        print("Badge URL: "..badge.badgeUrl)
        print("Badge Image ID: "..badge.badgeImageId)
        print("-----------------------------------")
    end
end)
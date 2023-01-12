-- Idk got bored, hub loader I guess?
local m = {}
function m:Load(placeIdTable, github)
    if (typeof(placeIdTable) ~= "table") then warn("[projection loader] - your place id table MUST be a table ex: {gameId1, gameId2, gameId3}"); return end
    for i, v in pairs(placeIdTable) do
        if (typeof(v) ~= "number") then warn("[projection loader] - your place id table MUST only contain integers"); return end
        if (game.PlaceId ~= v) then continue end
        loadstring(game:HttpGet(github.. tostring(game.PlaceId).. ".lua", true))()
    end
end; return m

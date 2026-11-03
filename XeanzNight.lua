
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local BASE = "https://raw.githubusercontent.com/xDTaraZz/Roblox-Scripts/refs/heads/main/All%20Map/"
local DISCORD = "discord.gg/FHVfmeSceA"

local GAMES = {
    [10436530264] = "Build An Ant Empire",
    [10418224975] = "TNT Mining",
    [10684750879] = "Loot To Forge",
    [10765091041] = "Open Sea For Animals",
    [66654135] = "Murder Mystery 2",
    [1202096104] = "Driving Empire",
    [9534705677] = "Sniper Arena",
    [6739698191] = "Violence District",
    [10708913337] = "Anime Dice",
    [10035204815] = "Ride A Pet",
    [10031505426] = "AirDrop Arena",
    [10765298801] = "Stone Skipping",
    [10765288803] = "Break and Steal an Egg",
    [10765012427] = "Build the Pyramid",
}

-- LOADING SCREEN MINECRAFT

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "XeanzNightLoading"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local parentOK = pcall(function()
    gui.Parent = game:GetService("CoreGui")
end)

if not parentOK then
    gui.Parent = player:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 165)
main.Position = UDim2.new(0.5, -170, 0.5, -82)
main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
main.BorderSizePixel = 0
main.Parent = gui

local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(15, 15, 15)
border.Thickness = 4
border.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 38)
title.Position = UDim2.new(0, 0, 0, 12)
title.BackgroundTransparency = 1
title.Text = "XEANZ NIGHT"
title.TextColor3 = Color3.fromRGB(100, 255, 100)
title.TextSize = 27
title.Font = Enum.Font.Arcade
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 28)
subtitle.Position = UDim2.new(0, 0, 0, 55)
subtitle.BackgroundTransparency = 1
subtitle.Text = "MEMUAT SCRIPT ⚔️"
subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
subtitle.TextSize = 17
subtitle.Font = Enum.Font.Arcade
subtitle.Parent = main

local barBG = Instance.new("Frame")
barBG.Size = UDim2.new(0, 290, 0, 22)
barBG.Position = UDim2.new(0.5, -145, 0, 105)
barBG.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
barBG.BorderSizePixel = 3
barBG.Parent = main

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(75, 220, 55)
bar.BorderSizePixel = 0
bar.Parent = barBG

local percent = Instance.new("TextLabel")
percent.Size = UDim2.new(1, 0, 0, 22)
percent.Position = UDim2.new(0, 0, 0, 132)
percent.BackgroundTransparency = 1
percent.Text = "0%"
percent.TextColor3 = Color3.fromRGB(255, 255, 255)
percent.TextSize = 15
percent.Font = Enum.Font.Arcade
percent.Parent = main

local function SetProgress(value)
    value = math.clamp(value, 0, 100)

    TweenService:Create(
        bar,
        TweenInfo.new(0.25),
        {Size = UDim2.new(value / 100, 0, 1, 0)}
    ):Play()

    percent.Text = tostring(math.floor(value)) .. "%"
end

local function CloseLoading()
    if gui and gui.Parent then
        gui:Destroy()
    end
end

local StarterGui = game:GetService("StarterGui")

local function Notify(text, detail)
    warn("[XEANZ NIGHT] " .. text, detail or "")

    task.spawn(function()
        for _ = 1, 20 do
            local shown = pcall(StarterGui.SetCore, StarterGui, "SendNotification", {
                Title = "Xeanzz hub",
                Text = text,
                Duration = 10,
            })

            if shown then return end
            task.wait(0.5)
        end
    end)
end

-- FETCH SYSTEM

local function LooksLikeScript(body)
    if type(body) ~= "string" or body == "" then
        return false
    end

    local head = body:sub(1, 80)
    return not (head:find("^%s*<") or head:find("^%d%d%d:"))
end

local function FetchOnce(url)
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)

    if ok and LooksLikeScript(body) then
        return body
    end

    local send = request or http_request or
        (syn and syn.request) or
        (http and http.request)

    if not send then
        return nil, ok and "bad reply from HttpGet" or tostring(body)
    end

    local sent, reply = pcall(send, {
        Url = url,
        Method = "GET"
    })

    if not sent or type(reply) ~= "table" then
        return nil, tostring(reply)
    end

    if reply.StatusCode ~= 200 then
        return nil, "HTTP " .. tostring(reply.StatusCode)
    end

    if not LooksLikeScript(reply.Body) then
        return nil, "bad reply body"
    end

    return reply.Body
end

local function Fetch(url)
    local why

    for attempt = 1, 3 do
        local body, err = FetchOnce(url)

        if body then
            return body
        end

        why = err

        if attempt < 3 then
            task.wait(1)
        end
    end

    return nil, why
end

-- GAME CHECK

local name = GAMES[game.GameId]

if not name then
    CloseLoading()
    Notify("This game is not supported yet. Join " .. DISCORD .. " for the list.")
    return
end

-- LOADING ANIMATION WHILE FETCHING

local source
local why
local finished = false

task.spawn(function()
    local ok, result, err = pcall(function()
        return Fetch(BASE .. (name:gsub(" ", "%%20")) .. ".lua")
    end)

    if ok then
        source = result
        why = err
    else
        why = tostring(result)
    end

    finished = true
end)

local progress = 0

while not finished do
    progress = math.min(progress + 2, 90)
    SetProgress(progress)
    task.wait(0.12)
end

if not source then
    CloseLoading()
    Notify("Could not download " .. name .. ". Check your connection and try again, or ask in " .. DISCORD, why)
    return
end

SetProgress(100)
subtitle.Text = "LOADING COMPLETE ⚔️"

task.wait(0.6)
CloseLoading()

-- LOAD SCRIPT

local chunk, compileErr = loadstring(source)

if not chunk then
    Notify(name .. " failed to load: " .. tostring(compileErr))
    return
end

local ok, trace = xpcall(chunk, function(err)
    return debug.traceback(tostring(err), 2)
end)

if not ok then
    Notify(
        name .. " stopped with an error: " ..
        tostring(trace):match("^[^\n]*"),
        "\n" .. tostring(trace)
    )
end

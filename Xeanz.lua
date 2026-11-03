
-- XEANZ NIGHT | Violence District
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local URL = "https://raw.githubusercontent.com/xDTaraZz/Roblox-Scripts/refs/heads/main/All%20Map/Violence%20District.lua"

local ok, source = pcall(function()
    return game:HttpGet(URL)
end)

if not ok or type(source) ~= "string" then
    warn("XEANZ NIGHT: Gagal mengambil script.")
    return
end

-- Ganti branding Mario
source = source:gsub("Mario Hub", "XEANZ NIGHT")
source = source:gsub("MarioBanner", "XeanzBanner")

-- Ganti banner Mario dengan tulisan loading
source = source:gsub(
    "pcall%(XeanzBanner%.Show%)",
    'print("⚔️ XEANZ NIGHT | MEMUAT SCRIPT ⚔️")'
)

-- Tema hijau ala Minecraft
source = source:gsub(
    'Theme = "Overworld"',
    'Theme = "Jungle"'
)

-- Compile dan jalankan
local fn, err = loadstring(source)

if not fn then
    warn("XEANZ NIGHT ERROR: " .. tostring(err))
    return
end

fn()

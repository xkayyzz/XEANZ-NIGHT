-- XEANZ NIGHT | Violence District
-- Loader yang mengambil script lengkap dari repository xDTaraZz,
-- lalu mengganti branding Mario tanpa mengubah logika fitur.

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local SOURCE_URL = "https://raw.githubusercontent.com/xDTaraZz/Roblox-Scripts/refs/heads/main/All%20Map/Violence%20District.lua"

local function notify(message)
    warn("[XEANZ NIGHT] " .. tostring(message))
end

notify("⚔️ MEMUAT SCRIPT ⚔️")

local ok, source = pcall(function()
    return game:HttpGet(SOURCE_URL)
end)

if not ok or type(source) ~= "string" or #source < 1000 then
    notify("Gagal mengambil script sumber. Periksa koneksi atau URL.")
    return
end

-- Pastikan yang terunduh memang script Violence District, bukan halaman error.
if not source:find("Violence District", 1, true)
    or not source:find("xDTaraZ", 1, true) then
    notify("Isi sumber tidak cocok dengan script Violence District.")
    return
end

-- Ganti nama banner dan teks branding.
source = source:gsub("Mario Hub", "XEANZ NIGHT")
source = source:gsub("MarioBanner", "XeanzBanner")
source = source:gsub("Classic XEANZ NIGHT UI is back", "XEANZ NIGHT UI")
source = source:gsub("Classic Mario Hub UI is back", "XEANZ NIGHT UI is back")

-- Jangan tampilkan gambar ASCII Mario. Tampilkan loading XEANZ NIGHT.
source = source:gsub(
    "pcall%(XeanzBanner%.Show%)",
    'print("[XEANZ NIGHT] ⚔️ MEMUAT SCRIPT ⚔️")'
)

-- Ganti label progress lama.
source = source:gsub("%[Mario Hub%]", "[XEANZ NIGHT]")

local chunk, compileError = loadstring(source)
if not chunk then
    notify("Gagal compile: " .. tostring(compileError))
    return
end

local ran, runError = pcall(chunk)
if not ran then
    notify("Script berhenti karena error: " .. tostring(runError))
end

hs.settings.set("1", "Firefox")
hs.settings.set("2", "Emacs")
hs.settings.set("3", "Ghostty")
hs.settings.set("4", "Bitwarden")

-- Check if a settings.lua file exists and if not, skip. This lets me apply any
-- customizations I need for work without needing to modify my personal settings.
local settings_file = hs.configdir .. "/settings.lua"
local settings = io.open(settings_file, "r")
if settings then
	dofile(settings_file)
else
	print("Settings file not found. Skipping...")
end

local apps =
{
	["1"] = hs.settings.get("1"),
	["2"] = hs.settings.get("2"),
	["3"] = hs.settings.get("3"),
	["4"] = hs.settings.get("4"),
    ["5"] = hs.settings.get("5"),
}
for key, app in pairs(apps) do
	hs.hotkey.bind({"cmd", "ctrl"}, key, function()
		hs.application.launchOrFocus(app)
	end)
end

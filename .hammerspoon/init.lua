local apps =
{
	["1"] = "Firefox",
	["2"] = "emacs",
	["3"] = "Ghostty",
	["4"] = "Bitwarden",
}
for key, app in pairs(apps) do
	hs.hotkey.bind({"cmd", "ctrl"}, key, function()
		hs.application.launchOrFocus(app)
	end)
end

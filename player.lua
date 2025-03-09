local uilib = loadstring(game:HttpGet('https://raw.githubusercontent.com/skidvape/Bruise/refs/heads/main/core/ui/interface.lua'))()
local url = 'https://api.soundcloud.com/tracks/TRACK_ID'
local cloneref = cloneref or function(v) return v; end;
local Workspace: Workspace = cloneref(game:GetService('Workspace'));

local Window = uilib:Window({
	Title = "musicPlayer",
	Subtitle = "A music-player that uses sound-clouds api to play music",
	Size = UDim2.fromOffset(960, 426),
	DragStyle = 1,
	DisabledWindowControls = {},
	ShowUserInfo = true,
	Keybind = Enum.KeyCode.RightShift,
	AcrylicBlur = true,
});

local globalSettings = {
	UIBlurToggle = Window:GlobalSetting({
		Name = "UI Blur",
		Default = Window:GetAcrylicBlurState(),
		Callback = function(bool)
			Window:SetAcrylicBlurState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " UI Blur",
				Lifetime = 5
			})
		end,
	}),
	NotificationToggler = Window:GlobalSetting({
		Name = "Notifications",
		Default = Window:GetNotificationsState(),
		Callback = function(bool)
			Window:SetNotificationsState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " Notifications",
				Lifetime = 5
			})
		end,
	}),
	ShowUserInfo = Window:GlobalSetting({
		Name = "Show User Info",
		Default = Window:GetUserInfoState(),
		Callback = function(bool)
			Window:SetUserInfoState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Showing" or "Redacted") .. " User Info",
				Lifetime = 5
			})
		end,
	}),
    FPSCap = Window:GlobalSetting({
		Name = "Unlock FPS",
		Default = false,
		Callback = function(bool)
            setfpscap(bool and 9e9 or 60);
		end,
	})
};

local tabs = {
	music = Window:TabGroup()
};

local uitabs = {
    music = tabs.music:Tab({
        Name = "Music",
        Image = "rbxassetid://14368350193"
    })
};

local sections = {
	music = {
		left = uitabs.render:Section({
			Side = 'Left'
		})
	}
};

--// musicplayer module/api handling
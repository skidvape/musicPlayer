-- trackId = 1953263803

local uilib = loadstring(game:HttpGet('https://raw.githubusercontent.com/skidvape/Bruise/refs/heads/main/core/ui/interface.lua'))()
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

run = function(v)
    local suc, res = pcall(function()
        v();
    end);
    
    if res then
		warn(tostring(res))
	end;
end;

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
streamURL = function(track)
    return string.format(game:HttpGet('https://api.soundcloud.com/tracks/%s/stream'), track)
end

run(function()
	local MusicPlayer
	local TrackId
	local Volume
    local Loop
    local newAudio
	MusicPlayer = sections.music.left:Toggle({
        Name = "MusicPlayer",
        Default = false,
        Callback = function(callback)
            if callback and TrackId.Value ~= "" then
				newAudio = Instance.new("Sound", workspace)
				newAudio.SoundId = streamURL(TrackId.Value)
				newAudio.Volume = Volume.Value
				newAudio.Looped = Loop.Value
				newAudio:Play()
			end
		end
	})
	Volume = sections.music.left:Slider({
        Name = "Volume",
        Default = 1,
        Minimum = 0,
        Maximum = 1,
        DisplayMethod = "Percent",
        Callback = function(value)
            Volume.Value = value
            if value then newAudio.Volume = value end
        end,
    }, "Volume")
    Loop = sections.utility.left:Toggle({
        Name = "Loop",
        Default = false,
        Callback = function(value)
            Loop.Value = value;
            if value then newAudio.Looped = value end
        end,
    }, "Loop")
	TrackId = sections.music.left:Input({
		Name = 'TrackID',
		Placeholder = '1234',
		AcceptedCharacters = "Numeric",
		Callback = function(value)
			TrackId.Value = value
			if newaudio and newAudio.IsPlaying then
				newAudio:Stop()
				newAudio.SoundId = streamURL(value)
				newAudio:Play()
			end
		end
	}, 'TrackId')
end)
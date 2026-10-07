repeat task.wait() until game:IsLoaded()
if shared.receba then shared.receba:Uninject() end

local receba
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and receba then
		receba:CreateNotification('RECEBA', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local queue_on_teleport = queue_on_teleport or function() end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local cloneref = cloneref or function(obj)
	return obj
end
local playersService = cloneref(game:GetService('Players'))

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/'..readfile('receba/profiles/repo_owner.txt')..'/'..readfile('receba/profiles/repo_name.txt')..'/'..readfile('receba/profiles/commit.txt')..'/'..select(1, path:gsub('receba/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--RECEBA cache marker. Remove this line from a cached file to keep that file across RECEBA updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function finishLoading()
	receba.Init = nil
	receba:Load()
	task.spawn(function()
		repeat
			receba:Save()
			task.wait(10)
		until not receba.Loaded
	end)

	local teleportedServers
	receba:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
		if (not teleportedServers) and (not shared.RecebaIndependent) then
			teleportedServers = true
			local teleportScript = [[
				shared.recebareload = true
				if shared.RecebaDeveloper then
					loadstring(readfile('receba/loader.lua'), 'loader')()
				else
					loadstring(game:HttpGet('https://raw.githubusercontent.com/'..readfile('receba/profiles/repo_owner.txt')..'/'..readfile('receba/profiles/repo_name.txt')..'/'..readfile('receba/profiles/commit.txt')..'/loader.lua', true), 'loader')()
				end
			]]

			if shared.RecebaDeveloper then
				teleportScript = 'shared.RecebaDeveloper = true\n'..teleportScript
			end

			if shared.RecebaCustomProfile then
				teleportScript = 'shared.RecebaCustomProfile = "'..shared.RecebaCustomProfile..'"\n'..teleportScript
			end

			receba:Save()
			queue_on_teleport(teleportScript)
		end
	end))

	if not shared.recebareload then
		if not receba.Categories then return end
		if receba.Settings.GUI.Options['GUI bind indicator'].Enabled then
			receba:CreateNotification('Finished Loading', receba.VapeButton and 'Press the button in the top right to open GUI' or 'Press '..table.concat(receba.GUIBind.Keys, ' + '):upper()..' to open GUI', 5)
		end
	end
end

if not isfile('receba/profiles/gui.txt') then
	writefile('receba/profiles/gui.txt', 'new')
end
local gui = 'new'--readfile('receba/profiles/gui.txt')

if not isfolder('receba/assets/'..gui) then
	makefolder('receba/assets/'..gui)
end
receba = loadstring(downloadFile('receba/guis/'..gui..'.lua'), 'gui')()
shared.receba = receba

if not shared.RecebaIndependent then
	loadstring(downloadFile('receba/games/universal.lua'), 'universal')()
	if isfile('receba/games/'..game.PlaceId..'.lua') then
		loadstring(readfile('receba/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
	else
		if not shared.RecebaDeveloper then
			local success, data = pcall(downloadFile, 'receba/games/'..game.PlaceId..'.lua')
			if success then
				loadstring(data, tostring(game.PlaceId))(...)
			end
		end
	end
	finishLoading()
else
	receba.Init = finishLoading
	return receba
end
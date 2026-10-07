local receba = shared.receba
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and receba then
		receba:CreateNotification('RECEBA', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
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

receba.Place = 16483433878
if isfile('receba/games/'..receba.Place..'.lua') then
	loadstring(readfile('receba/games/'..receba.Place..'.lua'), 'blocktales')()
else
	if not shared.RecebaDeveloper then
		local success, result = pcall(downloadFile, 'receba/games/'..receba.Place..'.lua')
		if success and result then
			loadstring(result, 'blocktales')()
		end
	end
end
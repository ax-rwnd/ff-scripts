IncludeScript("base_chatcommands")

---------------------------
-- Position chatcommands --
---------------------------

pos_table = {}
angle_table = {}

chatbase_addcommand("saveme", "Save your position.", "saveme")
function chat_saveme(player)
	if IsPlayer(player) then
		local key = GetSteamID(player)

		origin = player:GetOrigin()
		pos_table[key] = Vector(origin.x, origin.y, origin.z)
		angles = player:GetAngles()
		angle_table[key] = QAngle(angles.x,angles.y,angles.z)

		ChatToPlayer(player, "Your position was saved.")
	end
end

chatbase_addcommand("posme", "Restores your position.", "posme")
function chat_posme(player)
	if IsPlayer(player) then
		key = GetSteamID(player)
		if pos_table[key] ~= nil and angle_table[key] ~= nil then
			local neworigin = pos_table[key]
			local newangles = angle_table[key]
			local newvelocity = Vector(0,0,0)
			player:Teleport(neworigin, newangles, newvelocity)
			ChatToPlayer(player, "Your position was restored.")
		else
			ChatToPlayer(player, "You haven't set any position yet.")
		end
	end
end

time_table = {}

------------
-- Noclip --
------------
-- The wiki is outdated, SetConvar doesn't even accept player as a var
-- chatbase_addcommand("clipon", "Enable noclip for 120 seconds.", "clipon")
-- function chat_clipon(player)
-- 	if IsPlayer(player) then
-- 		player:SetConvar(player, "noclip", "1")
-- 		AddSchedule("clipoff", 120, chat_clipoff, player)
-- 	end
-- end

-- chatbase_addcommand("clipoff", "Disable noclip.", "clipoff")
-- function chat_clipoff(player)
-- 	if IsPlayer(player) then
-- 		SetConvar(player, "noclip", "0")
-- 	end
-- end

--------------------
-- Timer commands --
--------------------

-- credit to jesseadams@github
function sec_to_str(sec)
	if sec<=0 then
		return "00:00:00"
	else
		h = string.format("%02.f", math.floor(sec/3600))
		m = string.format("%02.f", math.floor( (sec - (h * 60)) / 60))
		s = string.format("%02.f", math.floor(sec - (h * 3600) - (m * 60)))
		return h..":"..m..":"..s
	end	
end

function start_timer(player)
	key = player:GetSteamID()

	-- reset player
	player:Respawn()
	angle_table[key] = nil
	pos_table[key] = nil

	if time_table[key] ~=nil then
		ChatToPlayer(player, "Timer reset!")
	else
		ChatToPlayer(player, "Timer started!")
	end
	time_table[key] = os.clock()
end

function stop_timer(player, flag)
	if time_table[key] ~= nil then
		local time = os.clock()-time_table[key]
		local output = string.format("Your time was %s seconds.", sec_to_str(time))
		time_table[key] = nil
		ChatToPlayer(player, output)
	else
		ChatToPlayer(player,"You haven't started a timer yet.")
	end
end

chatbase_addcommand("timer", "Manages timer", "timer <start|stop>")
function chat_timer(player, setting)
	if IsPlayer(player) then
		if setting == "start" then
			start_timer(player)
		elseif setting == "stop" then
			stop_timer(player, false)
		end
	end
end

-- to stop timer
function baseflag:touch(ent)
	player = CastToPlayer(ent)
	key = player:GetSteamID()

	if time_table[key] ~= nil then
		stop_timer(player, true)
	end
end

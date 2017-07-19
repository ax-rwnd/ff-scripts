-- Skill Utilities redux, b1
-- Author: RWND, original plugin by hlstriker
-- Features: saveme, posme, timer
-- Missing: Noclip (just add it using sv_cheats...)

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
		local neworigin = pos_table[key]
		local newangles = angle_table[key]
		local newvelocity = Vector(0,0,0)
		player:Teleport(neworigin, newangles, newvelocity)
		ChatToPlayer(player, "Your position was restored.")
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

chatbase_addcommand("timer", "Manages timer", "timer <start|stop>")
function chat_timer(player, setting)
	if IsPlayer(player) then
		key = player:GetSteamID()
		if setting == "start" then
			if time_table[key] ~=nil then
				ChatToPlayer(player, "Timer reset!")
			else
				ChatToPlayer(player, "Timer started!")
			end
			time_table[key] = os.clock()

		elseif setting == "stop" then
			if time_table[key] ~= nil then
				local output = string.format("Your time was %d seconds.", os.clock()-time_table[key])
				time_table[key] = nil
				ChatToPlayer(player, output)
			else
				ChatToPlayer(player,"You haven't started a timer yet.")
			end
		end
	end
end

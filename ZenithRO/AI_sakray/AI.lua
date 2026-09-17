
require "AI\\Const"
require "AI\\Util"					

-----------------------------
-- state
-----------------------------
IDLE_ST					= 0
FOLLOW_ST				= 1
CHASE_ST				= 2
ATTACK_ST				= 3
MOVE_CMD_ST				= 4
STOP_CMD_ST				= 5
ATTACK_OBJECT_CMD_ST			= 6
ATTACK_AREA_CMD_ST			= 7
PATROL_CMD_ST				= 8
HOLD_CMD_ST				= 9
SKILL_OBJECT_CMD_ST			= 10
SKILL_AREA_CMD_ST			= 11
FOLLOW_CMD_ST				= 12
----------------------------


------------------------------------------
-- global variable
------------------------------------------
MyState				= IDLE_ST	-- 최초의 상태는 휴식
MyEnemy				= 0		-- 적 id
MyDestX				= 0		-- 목적지 x
MyDestY				= 0		-- 목적지 y
MyPatrolX			= 0		-- 정찰 목적지 x
MyPatrolY			= 0		-- 정찰 목적지 y
ResCmdList			= List.new()	-- 예약 명령어 리스트 
MyID				= 0		-- 호문클루스 id
MySkill				= 0		-- 호문클루스의 스킬
MySkillLevel		= 0		-- 호문클루스의 스킬 레벨
LastAmiBulwarkTick	= 0
LastAmiBloodlustTick	= 0
LastCastlingTick	= 0
LastLifAvoidTick	= 0
LastLifHealTick		= 0
LastFilirFlitTick	= 0
LastFilirSpeedTick	= 0
LastOffensiveSkillTick	= 0
------------------------------------------


------------- command process  ---------------------

function	OnMOVE_CMD (x,y)
	
	TraceAI ("OnMOVE_CMD")

	if ( x == MyDestX and y == MyDestY and MOTION_MOVE == GetV(V_MOTION,MyID)) then
		return		-- 현재 이동중인 목적지와 같은 곳이면 처리하지 않는다. 
	end

	local curX, curY = GetV (V_POSITION,MyID)
	if (math.abs(x-curX)+math.abs(y-curY) > 15) then		-- 목적지가 일정 거리 이상이면 (서버에서 먼거리는 처리하지 않기 때문에)
		List.pushleft (ResCmdList,{MOVE_CMD,x,y})			-- 원래 목적지로의 이동을 예약한다. 	
		x = math.floor((x+curX)/2)							-- 중간지점으로 먼저 이동한다.  
		y = math.floor((y+curY)/2)							-- 
	end

	Move (MyID,x,y)	
	
	MyState = MOVE_CMD_ST
	MyDestX = x
	MyDestY = y
	MyEnemy = 0
	MySkill = 0

end



function	OnSTOP_CMD ()

	TraceAI ("OnSTOP_CMD")

	if (GetV(V_MOTION,MyID) ~= MOTION_STAND) then
		Move (MyID,GetV(V_POSITION,MyID))
	end
	MyState = IDLE_ST
	MyDestX = 0
	MyDestY = 0
	MyEnemy = 0
	MySkill = 0

end



function	OnATTACK_OBJECT_CMD (id)

	TraceAI ("OnATTACK_OBJECT_CMD")

	MySkill = 0
	MyEnemy = id
	MyState = CHASE_ST

end



function	OnATTACK_AREA_CMD (x,y)

	TraceAI ("OnATTACK_AREA_CMD")

	if (x ~= MyDestX or y ~= MyDestY or MOTION_MOVE ~= GetV(V_MOTION,MyID)) then
		Move (MyID,x,y)	
	end
	MyDestX = x
	MyDestY = y
	MyEnemy = 0
	MyState = ATTACK_AREA_CMD_ST
	
end



function	OnPATROL_CMD (x,y)

	TraceAI ("OnPATROL_CMD")

	MyPatrolX , MyPatrolY = GetV (V_POSITION,MyID)
	MyDestX = x
	MyDestY = y
	Move (MyID,x,y)
	MyState = PATROL_CMD_ST

end



function	OnHOLD_CMD ()

	TraceAI ("OnHOLD_CMD")

	MyDestX = 0
	MyDestY = 0
	MyEnemy = 0
	MyState = HOLD_CMD_ST

end



function	OnSKILL_OBJECT_CMD (level,skill,id)

	TraceAI ("OnSKILL_OBJECT_CMD")

	MySkillLevel = level
	MySkill = skill
	MyEnemy = id
	MyState = CHASE_ST

end



function	OnSKILL_AREA_CMD (level,skill,x,y)

	TraceAI ("OnSKILL_AREA_CMD")

	Move (MyID,x,y)
	MyDestX = x
	MyDestY = y
	MySkillLevel = level
	MySkill = skill
	MyState = SKILL_AREA_CMD_ST
	
end



function	OnFOLLOW_CMD ()

	-- 대기명령은 대기상태와 휴식상태를 서로 전환시킨다. 
	if (MyState ~= FOLLOW_CMD_ST) then
		MoveToOwner (MyID)
		MyState = FOLLOW_CMD_ST
		MyDestX, MyDestY = GetV (V_POSITION,GetV(V_OWNER,MyID))
		MyEnemy = 0 
		MySkill = 0
		TraceAI ("OnFOLLOW_CMD")
	else
		MyState = IDLE_ST
		MyEnemy = 0 
		MySkill = 0
		TraceAI ("FOLLOW_CMD_ST --> IDLE_ST")
	end

end



function	ProcessCommand (msg)

	if		(msg[1] == MOVE_CMD) then
		OnMOVE_CMD (msg[2],msg[3])
		TraceAI ("MOVE_CMD")
	elseif	(msg[1] == STOP_CMD) then
		OnSTOP_CMD ()
		TraceAI ("STOP_CMD")
	elseif	(msg[1] == ATTACK_OBJECT_CMD) then
		OnATTACK_OBJECT_CMD (msg[2])
		TraceAI ("ATTACK_OBJECT_CMD")
	elseif	(msg[1] == ATTACK_AREA_CMD) then
		OnATTACK_AREA_CMD (msg[2],msg[3])
		TraceAI ("ATTACK_AREA_CMD")
	elseif	(msg[1] == PATROL_CMD) then
		OnPATROL_CMD (msg[2],msg[3])
		TraceAI ("PATROL_CMD")
	elseif	(msg[1] == HOLD_CMD) then
		OnHOLD_CMD ()
		TraceAI ("HOLD_CMD")
	elseif	(msg[1] == SKILL_OBJECT_CMD) then
		OnSKILL_OBJECT_CMD (msg[2],msg[3],msg[4],msg[5])
		TraceAI ("SKILL_OBJECT_CMD")
	elseif	(msg[1] == SKILL_AREA_CMD) then
		OnSKILL_AREA_CMD (msg[2],msg[3],msg[4],msg[5])
		TraceAI ("SKILL_AREA_CMD")
	elseif	(msg[1] == FOLLOW_CMD) then
		OnFOLLOW_CMD ()
		TraceAI ("FOLLOW_CMD")
	end
end




-------------- state process  --------------------

-------------------------------------------
-- Utility Functions
-------------------------------------------
function modulo(a, b)
	if a == nil or b == nil or b == 0 then return 0 end
	return a - math.floor(a / b) * b
end

-------------------------------------------
-- Combat Support / Buff / Healing Routine (Only during combat!)
-------------------------------------------
function CombatSupportSkills(myid)
	local tick = GetTick()
	local htype = GetV(V_HOMUNTYPE, myid)
	local sp = GetV(V_SP, myid)
	local hp = GetV(V_HP, myid)
	local maxHp = GetV(V_MAXHP, myid)
	local owner = GetV(V_OWNER, myid)
	local ownerHp = GetV(V_HP, owner)
	local ownerMaxHp = GetV(V_MAXHP, owner)
	local hmod = modulo(htype, 4)

	-- Check Lif skills (htype % 4 == 1)
	if (htype == LIF or htype == LIF_H or htype == LIF2 or htype == LIF_H2 or hmod == 1) then
		-- 1. Lif Healing Hands (HLIF_HEAL = 8001) in combat: only if seriously hurt (<70%)
		if (sp ~= nil and sp >= 15 and tick > LastLifHealTick) then
			-- Heal master if master HP < 70%
			if (ownerHp ~= nil and ownerMaxHp ~= nil and ownerMaxHp > 0 and (ownerHp * 100 / ownerMaxHp) < 70) then
				LastLifHealTick = tick + 8000 -- 8s cooldown
				SkillObject(myid, 5, 8001, owner)
				return true
			end
			-- Heal self if self HP < 65%
			if (hp ~= nil and maxHp ~= nil and maxHp > 0 and (hp * 100 / maxHp) < 65) then
				LastLifHealTick = tick + 8000 -- 8s cooldown
				SkillObject(myid, 5, 8001, myid)
				return true
			end
		end

		-- 2. Lif Urgent Escape (HLIF_AVOID = 8002) - Speed buff in combat
		if (sp ~= nil and sp >= 25 and tick > LastLifAvoidTick) then
			LastLifAvoidTick = tick + 35000 -- 35s cooldown
			SkillObject(myid, 5, 8002, myid)
			return true
		end

	-- Check Amistr skills (htype % 4 == 2)
	elseif (htype == AMISTR or htype == AMISTR_H or htype == AMISTR2 or htype == AMISTR_H2 or hmod == 2) then
		-- 1. Amistr Bulwark (HAMI_DEFENCE = 8006) - DEF buff in combat
		if (sp ~= nil and sp >= 20 and tick > LastAmiBulwarkTick) then
			LastAmiBulwarkTick = tick + 30000 -- 30s cooldown
			SkillObject(myid, 5, 8006, myid)
			return true
		end

		-- 2. Amistr Castling (HAMI_CASTLE = 8005) - Rescue master if under attack and master HP < 70%
		if (sp ~= nil and sp >= 10 and tick > LastCastlingTick) then
			local ownerEnemy = GetOwnerEnemy(myid)
			if (ownerEnemy ~= 0 and ownerHp ~= nil and ownerMaxHp ~= nil and ownerMaxHp > 0 and (ownerHp * 100 / ownerMaxHp) < 70) then
				LastCastlingTick = tick + 10000 -- 10s cooldown
				SkillObject(myid, 5, 8005, myid)
				return true
			end
		end

		-- 3. Amistr Blood Lust (HAMI_BLOODLUST = 8008) in combat
		if (sp ~= nil and sp >= 120 and tick > LastAmiBloodlustTick) then
			LastAmiBloodlustTick = tick + 120000 -- 120s cooldown
			SkillObject(myid, 3, 8008, myid)
			return true
		end

	-- Check Filir skills (htype % 4 == 3)
	elseif (htype == FILIR or htype == FILIR_H or htype == FILIR2 or htype == FILIR_H2 or hmod == 3) then
		-- 1. Accelerated Flight (HFLI_SPEED = 8011) - FLEE buff in combat
		if (sp ~= nil and sp >= 30 and tick > LastFilirSpeedTick) then
			LastFilirSpeedTick = tick + 60000 -- 60s cooldown
			SkillObject(myid, 5, 8011, myid)
			return true
		end

		-- 2. Flitting (HFLI_FLEET = 8010) - ASPD/ATK buff in combat
		if (sp ~= nil and sp >= 30 and tick > LastFilirFlitTick) then
			LastFilirFlitTick = tick + 60000 -- 60s cooldown
			SkillObject(myid, 5, 8010, myid)
			return true
		end
	end

	return false
end


function	OnIDLE_ST ()
	
	TraceAI ("OnIDLE_ST")

	local cmd = List.popleft(ResCmdList)
	if (cmd ~= nil) then		
		ProcessCommand (cmd)	-- 예약 명령어 처리 
		return 
	end

	local	object = GetOwnerEnemy (MyID)
	if (object ~= 0) then							-- MYOWNER_ATTACKED_IN
		MyState = CHASE_ST
		MyEnemy = object
		TraceAI ("IDLE_ST -> CHASE_ST : MYOWNER_ATTACKED_IN")
		return 
	end

	object = GetMyEnemy (MyID)
	if (object ~= 0) then							-- ATTACKED_IN
		MyState = CHASE_ST
		MyEnemy = object
		TraceAI ("IDLE_ST -> CHASE_ST : ATTACKED_IN")
		return
	end

	local distance = GetDistanceFromOwner(MyID)
	if ( distance > 3 or distance == -1) then		-- MYOWNER_OUTSIGNT_IN
		MyState = FOLLOW_ST
		TraceAI ("IDLE_ST -> FOLLOW_ST")
		return
	end

end



function	OnFOLLOW_ST ()

	TraceAI ("OnFOLLOW_ST")

	local cmd = List.popleft(ResCmdList)
	if (cmd ~= nil) then		
		ProcessCommand (cmd)
		return 
	end

	-- Aggressive: Check if owner is attacked
	local object = GetOwnerEnemy (MyID)
	if (object ~= 0) then
		MyState = CHASE_ST
		MyEnemy = object
		TraceAI ("FOLLOW_ST -> CHASE_ST : OWNER_ATTACKED")
		return
	end

	-- Aggressive: Check if any hostile monster is nearby
	object = GetMyEnemy (MyID)
	if (object ~= 0) then
		local ownerDist = GetDistanceFromOwner(MyID)
		if (ownerDist <= 12 and ownerDist ~= -1) then
			MyState = CHASE_ST
			MyEnemy = object
			TraceAI ("FOLLOW_ST -> CHASE_ST : AGGRESSIVE_ENEMY_FOUND")
			return
		end
	end

	if (GetDistanceFromOwner(MyID) <= 3) then		-- DESTINATION_ARRIVED_IN 
		MyState = IDLE_ST
		TraceAI ("FOLLOW_ST -> IDLE_ST")
		return
	elseif (GetV(V_MOTION,MyID) == MOTION_STAND) then
		MoveToOwner (MyID)
		TraceAI ("FOLLOW_ST -> FOLLOW_ST")
		return
	end

end



function	OnCHASE_ST ()

	TraceAI ("OnCHASE_ST")

	if (true == IsOutOfSight(MyID,MyEnemy)) then	-- ENEMY_OUTSIGHT_IN
		MyState = IDLE_ST
		MyEnemy = 0
		MyDestX, MyDestY = 0,0
		TraceAI ("CHASE_ST -> IDLE_ST : ENEMY_OUTSIGHT_IN")
		return
	end

	-- Leash check: do not wander off too far from owner
	local ownerDist = GetDistanceFromOwner(MyID)
	if (ownerDist > 14 or ownerDist == -1) then
		MyState = FOLLOW_ST
		MyEnemy = 0
		MyDestX, MyDestY = 0,0
		TraceAI ("CHASE_ST -> FOLLOW_ST : OWNER_LEASH_EXCEEDED")
		return
	end

	if (true == IsInAttackSight(MyID,MyEnemy)) then  -- ENEMY_INATTACKSIGHT_IN
		MyState = ATTACK_ST
		TraceAI ("CHASE_ST -> ATTACK_ST : ENEMY_INATTACKSIGHT_IN")
		return
	end

	local x, y = GetV (V_POSITION_APPLY_SKILLATTACKRANGE, MyEnemy, MySkill, MySkillLevel)
	if (MyDestX ~= x or MyDestY ~= y) then			-- DESTCHANGED_IN
		MyDestX, MyDestY = GetV (V_POSITION_APPLY_SKILLATTACKRANGE, MyEnemy, MySkill, MySkillLevel)
		Move (MyID,MyDestX,MyDestY)
		TraceAI ("CHASE_ST -> CHASE_ST : DESTCHANGED_IN")
		return
	end

end



function	OnATTACK_ST ()

	TraceAI ("OnATTACK_ST")
	
	if (true == IsOutOfSight(MyID,MyEnemy)) then	-- ENEMY_OUTSIGHT_IN
		MyState = IDLE_ST
		TraceAI ("ATTACK_ST -> IDLE_ST")
		return 
	end

	if (MOTION_DEAD == GetV(V_MOTION,MyEnemy)) then   -- ENEMY_DEAD_IN
		MyState = IDLE_ST
		TraceAI ("ATTACK_ST -> IDLE_ST")
		return
	end
		
	if (false == IsInAttackSight(MyID,MyEnemy)) then  -- ENEMY_OUTATTACKSIGHT_IN
		MyState = CHASE_ST
		MyDestX, MyDestY = GetV(V_POSITION_APPLY_SKILLATTACKRANGE, MyEnemy, MySkill, MySkillLevel)
		Move (MyID,MyDestX,MyDestY)
		TraceAI ("ATTACK_ST -> CHASE_ST  : ENEMY_OUTATTACKSIGHT_IN")
		return
	end

	-- Support & buff skills during combat (with strict cooldowns)
	if (CombatSupportSkills(MyID)) then
		return
	end
	
	if (MySkill == 0) then
		local htype = GetV(V_HOMUNTYPE, MyID)
		local sp = GetV(V_SP, MyID)
		local tick = GetTick()
		local castSkill = false
		-- Offensive attack skills: only cast every 3.5 seconds with proper cooldown!
		if (tick > LastOffensiveSkillTick) then
			if (htype == VANILMIRTH or htype == VANILMIRTH_H or htype == VANILMIRTH2 or htype == VANILMIRTH_H2) and (sp ~= nil and sp > 30) then
				LastOffensiveSkillTick = tick + 3500
				SkillObject(MyID, 5, 8013, MyEnemy)
				castSkill = true
			elseif (htype == FILIR or htype == FILIR_H or htype == FILIR2 or htype == FILIR_H2) and (sp ~= nil and sp > 20) then
				LastOffensiveSkillTick = tick + 3500
				SkillObject(MyID, 5, 8009, MyEnemy)
				castSkill = true
			end
		end

		if (not castSkill) then
			Attack (MyID,MyEnemy)
		end
	else
		if (1 == SkillObject(MyID,MySkillLevel,MySkill,MyEnemy)) then
			MyEnemy = 0
		end
		
		MySkill = 0
	end
	TraceAI ("ATTACK_ST -> ATTACK_ST  : ENERGY_RECHARGED_IN")
	return

end



function	OnMOVE_CMD_ST ()

	TraceAI ("OnMOVE_CMD_ST")

	local x, y = GetV (V_POSITION,MyID)
	if (x == MyDestX and y == MyDestY) then				-- DESTINATION_ARRIVED_IN
		MyState = IDLE_ST
	end
end



function OnSTOP_CMD_ST ()


end



function OnATTACK_OBJECT_CMD_ST ()

	
end



function OnATTACK_AREA_CMD_ST ()

	TraceAI ("OnATTACK_AREA_CMD_ST")

	local	object = GetOwnerEnemy (MyID)
	if (object == 0) then							
		object = GetMyEnemy (MyID) 
	end

	if (object ~= 0) then							-- MYOWNER_ATTACKED_IN or ATTACKED_IN
		MyState = CHASE_ST
		MyEnemy = object
		return
	end

	local x , y = GetV (V_POSITION,MyID)
	if (x == MyDestX and y == MyDestY) then			-- DESTARRIVED_IN
			MyState = IDLE_ST
	end

end



function OnPATROL_CMD_ST ()

	TraceAI ("OnPATROL_CMD_ST")

	local	object = GetOwnerEnemy (MyID)
	if (object == 0) then							
		object = GetMyEnemy (MyID) 
	end

	if (object ~= 0) then							-- MYOWNER_ATTACKED_IN or ATTACKED_IN
		MyState = CHASE_ST
		MyEnemy = object
		TraceAI ("PATROL_CMD_ST -> CHASE_ST : ATTACKED_IN")
		return
	end

	local x , y = GetV (V_POSITION,MyID)
	if (x == MyDestX and y == MyDestY) then			-- DESTARRIVED_IN
		MyDestX = MyPatrolX
		MyDestY = MyPatrolY
		MyPatrolX = x
		MyPatrolY = y
		Move (MyID,MyDestX,MyDestY)
	end

end



function OnHOLD_CMD_ST ()

	TraceAI ("OnHOLD_CMD_ST")
	
	if (MyEnemy ~= 0) then
		local d = GetDistance(MyEnemy,MyID)
		if (d ~= -1 and d <= GetV(V_ATTACKRANGE,MyID)) then
				Attack (MyID,MyEnemy)
		else
			MyEnemy = 0
		end
		return
	end


	local	object = GetOwnerEnemy (MyID)
	if (object == 0) then							
		object = GetMyEnemy (MyID)
		if (object == 0) then						
			return
		end
	end

	MyEnemy = object

end



function OnSKILL_OBJECT_CMD_ST ()
	
end




function OnSKILL_AREA_CMD_ST ()

	TraceAI ("OnSKILL_AREA_CMD_ST")

	local x , y = GetV (V_POSITION,MyID)
	if (GetDistance(x,y,MyDestX,MyDestY) <= GetV(V_SKILLATTACKRANGE_LEVEL, MyID, MySkill, MySkillLevel)) then	-- DESTARRIVED_IN
		SkillGround (MyID,MySkillLevel,MySkill,MyDestX,MyDestY)
		MyState = IDLE_ST
		MySkill = 0
	end

end



function OnFOLLOW_CMD_ST ()

	TraceAI ("OnFOLLOW_CMD_ST")

	local ownerX, ownerY, myX, myY
	ownerX, ownerY = GetV (V_POSITION,GetV(V_OWNER,MyID)) -- 주인
	myX, myY = GetV (V_POSITION,MyID)					  -- 나 
	
	local d = GetDistance (ownerX,ownerY,myX,myY)

	if ( d <= 3) then									  -- 3셀 이하 거리면 
		return 
	end

	local motion = GetV (V_MOTION,MyID)
	if (motion == MOTION_MOVE) then                       -- 이동중
		d = GetDistance (ownerX, ownerY, MyDestX, MyDestY)
		if ( d > 3) then                                  -- 목적지 변경 ?
			MoveToOwner (MyID)
			MyDestX = ownerX
			MyDestY = ownerY
			return
		end
	else                                                  -- 다른 동작 
		MoveToOwner (MyID)
		MyDestX = ownerX
		MyDestY = ownerY
		return
	end
	
end



-------------------------------------------
-- Monster Exclusion List (Wild Plants & Player Summons)
-------------------------------------------
IgnoredMonsters = {
	[1078] = true, -- Red Plant
	[1079] = true, -- Blue Plant
	[1080] = true, -- Green Plant
	[1081] = true, -- Yellow Plant
	[1082] = true, -- White Plant
	[1083] = true, -- Shining Plant
	[1084] = true, -- Red Mushroom
	[1085] = true, -- Black Mushroom
	[1555] = true, -- Parasite
	[1575] = true, -- Flora
	[1579] = true, -- Hydra
	[1589] = true, -- Mandragora
	[1590] = true, -- Geographer
	[1790] = true, -- Rafflesia
	[20572] = true, -- Wooden Golem
}

function	GetOwnerEnemy (myid)
	local result = 0
	local owner  = GetV (V_OWNER,myid)
	local actors = GetActors ()
	local enemys = {}
	local index = 1
	local target
	for i,v in ipairs(actors) do
		if (v ~= owner and v ~= myid) then
			target = GetV (V_TARGET,v)
			if (target == owner) then
				local mobType = GetV(V_HOMUNTYPE, v)
				local motion = GetV(V_MOTION, v)
				if (not IgnoredMonsters[mobType]) and (motion ~= MOTION_DEAD) then
					if (IsMonster(v) == 1) then
						enemys[index] = v
						index = index+1
					else
						local m = GetV(V_MOTION,v)
						if (m == MOTION_ATTACK or m == MOTION_ATTACK2) then
							enemys[index] = v
							index = index+1
						end
					end
				end
			end
		end
	end

	local min_dis = 100
	local dis
	for i,v in ipairs(enemys) do
		dis = GetDistance2 (myid,v)
		if (dis < min_dis) then
			result = v
			min_dis = dis
		end
	end
	
	return result
end



function	GetMyEnemy (myid)
	-- All homunculus classes aggressively seek monsters on sight
	return GetMyEnemyB (myid)
end




-------------------------------------------
-- Passive Enemy Detection (Retaliation Only)
-------------------------------------------
function	GetMyEnemyA (myid)
	local result = 0
	local owner  = GetV (V_OWNER,myid)
	local actors = GetActors ()
	local enemys = {}
	local index = 1
	local target
	for i,v in ipairs(actors) do
		if (v ~= owner and v ~= myid) then
			target = GetV (V_TARGET,v)
			if (target == myid) then
				local mobType = GetV(V_HOMUNTYPE, v)
				local motion = GetV(V_MOTION, v)
				if (not IgnoredMonsters[mobType]) and (motion ~= MOTION_DEAD) then
					enemys[index] = v
					index = index+1
				end
			end
		end
	end

	local min_dis = 100
	local dis
	for i,v in ipairs(enemys) do
		dis = GetDistance2 (myid,v)
		if (dis < min_dis) then
			result = v
			min_dis = dis
		end
	end

	return result
end





-------------------------------------------
-- Aggressive Enemy Detection (Monsters in Sight)
-------------------------------------------
function	GetMyEnemyB (myid)
	local result = 0
	local owner  = GetV (V_OWNER,myid)
	local actors = GetActors ()
	local enemys = {}
	local index = 1
	for i,v in ipairs(actors) do
		if (v ~= owner and v ~= myid) then
			if (1 == IsMonster(v))	then
				local mobType = GetV(V_HOMUNTYPE, v)
				local motion = GetV(V_MOTION, v)
				local distToOwner = GetDistance2(owner, v)
				local distToMe = GetDistance2(myid, v)
				-- Skip ignored/summoned monsters, dead entities, and monsters beyond leash range (14 cells of owner, 12 cells of homun)
				if (not IgnoredMonsters[mobType]) and (motion ~= MOTION_DEAD) and (distToOwner ~= -1 and distToOwner <= 14) and (distToMe ~= -1 and distToMe <= 12) then
					enemys[index] = v
					index = index+1
				end
			end
		end
	end

	local min_dis = 100
	local dis
	for i,v in ipairs(enemys) do
		dis = GetDistance2 (myid,v)
		if (dis < min_dis) then
			result = v
			min_dis = dis
		end
	end

	return result
end



function AI(myid)

	MyID = myid
	local msg	= GetMsg (myid)			-- command
	local rmsg	= GetResMsg (myid)		-- reserved command

	
	if msg[1] == NONE_CMD then
		if rmsg[1] ~= NONE_CMD then
			if List.size(ResCmdList) < 10 then
				List.pushright (ResCmdList,rmsg) -- 예약 명령 저장
			end
		end
	else
		List.clear (ResCmdList)	-- 새로운 명령이 입력되면 예약 명령들은 삭제한다.  
		ProcessCommand (msg)	-- 명령어 처리 
	end

		
	-- 상태 처리 
 	if (MyState == IDLE_ST) then
		OnIDLE_ST ()
	elseif (MyState == CHASE_ST) then					
		OnCHASE_ST ()
	elseif (MyState == ATTACK_ST) then
		OnATTACK_ST ()
	elseif (MyState == FOLLOW_ST) then
		OnFOLLOW_ST ()
	elseif (MyState == MOVE_CMD_ST) then
		OnMOVE_CMD_ST ()
	elseif (MyState == STOP_CMD_ST) then
		OnSTOP_CMD_ST ()
	elseif (MyState == ATTACK_OBJECT_CMD_ST) then
		OnATTACK_OBJECT_CMD_ST ()
	elseif (MyState == ATTACK_AREA_CMD_ST) then
		OnATTACK_AREA_CMD_ST ()
	elseif (MyState == PATROL_CMD_ST) then
		OnPATROL_CMD_ST ()
	elseif (MyState == HOLD_CMD_ST) then
		OnHOLD_CMD_ST ()
	elseif (MyState == SKILL_OBJECT_CMD_ST) then
		OnSKILL_OBJECT_CMD_ST ()
	elseif (MyState == SKILL_AREA_CMD_ST) then
		OnSKILL_AREA_CMD_ST ()
	elseif (MyState == FOLLOW_CMD_ST) then
		OnFOLLOW_CMD_ST ()
	end

end

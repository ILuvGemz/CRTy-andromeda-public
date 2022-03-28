local rvrs = 1;
local ret = 0;
local mixer = true;
local mic = true;
local badder = 0;
local nBeat = 0;

function define(name, n, pn)
	modMgr:define(name)
	modMgr:set(name, n, pn)
end

define("reverse0", 0)
define("reverse1", 0)
define("reverse2", 0)
define("reverse3", 0)

local beatLength = (3 * stepCrochet) /1000


local cameraList = {gameCam, HUDCam, notesCam, holdCam, receptorCam}

local hudcover = newSprite(-2048, -2048, false, true, "hudcover")
hudcover:makeGraphic(8192, 8192, getVar("underColors")[1], false)
hudcover.alpha = 0.001
--hudcover:setBlendMode("multiply")
hudcover.cameras = cameraList

function beatHit(curBeat)
	nBeat = curBeat
	if curBeat == 67 then
		hudcover.alpha = 1
		hudcover:tweenColor(getVar("underColors")[1],getVar("underColors")[2], beatLength, "circOut")
	elseif curBeat == 68 or curBeat == 131 then
		hudcover:tweenColor(getVar("underColors")[1],getVar("underColors")[3],beatLength, "circOut")
		hudcover:setBlendMode("multiply")
	elseif (curBeat >= 69 and curBeat < 98) or (curBeat >= 132 and curBeat < 161) then
		hudcover:tweenColor(getVar("underColors")[4],getVar("underColors")[3],beatLength, "circOut")
	elseif curBeat == 99 then
		hudcover:tweenColor(getVar("underColors")[3],getVar("underColors")[1],beatLength, "circOut")
		--hudcover:tween({alpha = 0.001}, beatLength, "circOut")
	elseif curBeat == 124 then
		hudcover:tweenColor(getVar("underColors")[1],getVar("underColors")[2], (beatLength*8), "linear")
	elseif curBeat == 164 then
		hudcover:tweenColor(getVar("underColors")[3],getVar("underColors")[2], (beatLength*3), "linear")
	end
end



local function clamp(n, l, h)
	if (n>h)then n=h end
	if (n<l)then n=l end
	return n
end

local function queueSet(step, modName, perc, pn)
	modMgr:queueSet(step*(2/3),modName,perc, pn)
end

local function queueEase(begin, en, modName, perc, ease, pn)
	modMgr:queueEase(begin*(2/3), en*(2/3), modName, perc, ease, pn)
end

local function queueBeatSet(step, modName, perc, pn)
	modMgr:queueSet(step*4,modName,perc, pn)
end

local function queueBeatEase(begin, en, modName, perc, ease, pn)
	modMgr:queueEase(begin*4, en*4, modName, perc, ease, pn)
end

local function set(modName, perc, pn) modMgr:set(modName, perc, pn) end

function newLoop(hajime, owari, mod, beats, offset, func)
	if (beats == nil) then beats = {4,12}; end
	for step=hajime,owari do
		for i=1,#beats do
			if ((step + offset)%mod == beats[i]) then func(step) rvrs = -rvrs end
		end
	end
end

function rendaBeat(hajime, owari, func)
	for step = hajime*4,owari*4 do
	local beat = step/4
		if (step%4==0) then func(step,beat) rvrs = -rvrs end
	end
end

queueBeatEase(15, 16, "bumpy", 30, "quadIn")
queueBeatEase(15, 16, "rotateX", math.rad(180), "quadInOut")

rendaBeat(16, 31, function(step,beat)
	queueBeatSet(beat, "noteCamPitch", 60*rvrs)
	queueBeatEase(beat, beat+0.7, "noteCamPitch", 0, "circOut")
end)

queueBeatEase(31, 32, "bumpy", 0, "quadIn")

queueBeatEase(35, 36, "rotateX", 0, "quadInOut")
queueBeatEase(35, 36, "drunk", 20, "quadInOut")

newLoop(144,256,16,{0,3,6,8,12}, 16, function(step)
	if (step+16)%16 == 0 or
	(step+16)%16 == 3 or
	(step+16)%16 == 6 or
	(step+16)%16 == 8 then
		badder = badder%4
		if badder == 0 then modMgr:queueEase(step, step+2, "drunk", 220*rvrs, "quadOut")
		elseif badder == 1 then modMgr:queueEase(step, step+2, "mini", clamp(50*rvrs, 0, 100), "quadOut")
		elseif badder == 2 then modMgr:queueEase(step, step+2, "boost", 120*rvrs, "quadOut")
		elseif badder == 3 then modMgr:queueEase(step, step+2, "wave", 250*rvrs, "quadOut")
		end
	end
	
	if (step+16)%16==12 then
	rvrs = -rvrs
	badder = badder + 1
	modMgr:queueEase(step, step+2, "drunk", 0, "quadOut")
	modMgr:queueEase(step, step+2, "mini", 0, "quadOut")
	modMgr:queueEase(step, step+2, "boost", 0, "quadOut")
	modMgr:queueEase(step, step+2, "wave", 0, "quadOut")
	end
end)

newLoop(216,384,24,{15,16,17,18,20,21,23},0, function(step)
	ret = (ret +1)%7
	if mixer and ret ~= 0 then queueSet(step,"localrotateY", math.rad(clamp(180-ret*45,0,360)))
	elseif not mixer and ret ~= 0 then queueSet(step, "centered", clamp(120-ret*30, 0, 120))
	end
	if ret >= 4 then queueEase(step, step+0.7, "tipsy", rvrs*120, "linear") 
	elseif ret == 0 then queueEase(step, step+0.7, "tipsy", 0, "linear")
	end
	if ret == 6 then mixer = not mixer end
end)

newLoop(36, 64,4,{2},0, function(beat)
	if mic then
		queueBeatEase(beat, beat+0.5, "localrotateY", math.rad(180), "quadOut")
	elseif not mic then
		queueBeatEase(beat, beat+0.5, "centered", 120, "quadOut")
	end
	mic = not mic
end)
queueBeatEase(64,66, "wave", 0, "linear")
queueBeatEase(52,63, "bumpy", 130, "linear")
queueBeatEase(63, 64, "bumpy", 0, "cubicOut")

for i=68,83 do
	local notefall = i%4
	queueBeatEase(i, i+2, "reverse"..notefall, 50, "quartIn")
	queueBeatEase(i+2, i+4, "reverse"..notefall, 0, "quartOut")
end

queueBeatEase(84, 85, "receptorScroll", 100, "linear", 1)
queueBeatEase(86, 87, "receptorScroll",-100, "linear", 0)
queueBeatEase(84, 85, "stealth", 75, "linear",1)
queueBeatEase(84, 87, "opponentSwap", 50, "quadInOut")

queueBeatEase(99, 100, "receptorScroll", 0, "quadInOut")
queueBeatEase(99, 100, "stealth", 0,"quadInOut",1)
queueBeatEase(99, 100, "opponentSwap", 0, "quadInOut")

queueBeatEase(131.4,132, "beat", 133, "linear")
queueBeatEase(131.4,132, "drunk", 69, "linear")






rendaBeat(100, 123, function(step,beat)
	queueBeatSet(beat, "noteCamPitch", 60*rvrs)
	queueBeatEase(beat, beat+0.7, "noteCamPitch", 0, "circOut")
end)

function update(elapsed)
	
	modMgr:set("alternate", (-50)*modMgr:get('reverse0',0) + 50*modMgr:get('reverse1',0) - 50*modMgr:get('reverse2',0) +50*modMgr:get('reverse3',0), 0)
	modMgr:set("cross", (-50)*modMgr:get('reverse0',0) + 50*modMgr:get('reverse1',0) + 50*modMgr:get('reverse2',0) - 50*modMgr:get('reverse3',0), 0)
	modMgr:set("split", (-50)*modMgr:get('reverse0',0) + (-50)*modMgr:get('reverse1',0) + 50*modMgr:get('reverse2',0) + 50*modMgr:get('reverse3',0), 0)
	modMgr:set("reverse", 100*modMgr:get('reverse0',0), 0)
	
	modMgr:set("alternate", (-50)*modMgr:get('reverse0',1) + 50*modMgr:get('reverse1',1) - 50*modMgr:get('reverse2',1) +50*modMgr:get('reverse3',1), 1)
	modMgr:set("cross", (-50)*modMgr:get('reverse0',1) + 50*modMgr:get('reverse1',1) + 50*modMgr:get('reverse2',1) - 50*modMgr:get('reverse3',1), 1)
	modMgr:set("split", (-50)*modMgr:get('reverse0',1) + (-50)*modMgr:get('reverse1',1) + 50*modMgr:get('reverse2',1) + 50*modMgr:get('reverse3',1), 1)
	modMgr:set("reverse", 100*modMgr:get('reverse0',1), 1)
end

function goodNoteHit(data, stime, pos, sus)
	if(nBeat >= 132 and nBeat < 148 and not sus) then
		modMgr:set("reverse"..data, 17.5, 0)
		modMgr:queueEase(curStep, curStep + 1.33, "reverse"..data, 0, "linear",0)
	end
end

function dadNoteHit(data, stime, pos, anim, sus)
	if(nBeat >= 132 and nBeat < 148 and not sus) then
		modMgr:set("reverse"..data, 17.5, 1)
		modMgr:queueEase(curStep, curStep + 1.33, "reverse"..data, 0, "linear",1)
	end
end

rendaBeat(132, 159, function(step,beat)
	queueBeatSet(beat, "noteCamPitch", 60*rvrs)
	queueBeatEase(beat, beat+0.7, "noteCamPitch", 0, "circOut")
end)

queueBeatEase(148, 149, "receptorScroll", 100, "linear", 1)
queueBeatEase(148, 149, "receptorScroll",-100, "linear", 0)
queueBeatEase(148, 149, "stealth", 75, "linear",1)
queueBeatEase(148, 151, "opponentSwap", 100, "sineInOut")
queueBeatEase(151, 154, "opponentSwap", 0, "sineInOut")
queueBeatEase(154, 157, "opponentSwap", 100, "sineInOut")
queueBeatEase(157, 160, "opponentSwap", 0, "sineInOut")

queueBeatEase(160, 162, "receptorScroll", 0, "quadInOut")
queueBeatEase(160, 162, "stealth", 0,"quadInOut",1)
queueBeatEase(160, 162, "opponentSwap", 0, "quadInOut")
queueBeatEase(160, 162, "beat", 0, "quadInOut")
queueBeatEase(160, 162, "drunk", 0, "quadInOut")
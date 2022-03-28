local function define(name, num)
modMgr:define(name)
modMgr:set(name, num)
end

setVar("camZooming",false)

local rvrs = 1
local reap = 0
local rpm = 0
local spinTime = 0
local colors = {colorFromString("0x66ff0000"),colorFromString("0x660000ff"), colorFromString("0x6600ff00")}
local revOptie = getOption("downScroll")

local receptors = {leftPlrNote,downPlrNote,upPlrNote,rightPlrNote,leftDadNote,downDadNote,upDadNote,rightDadNote}

local canSpin = false;

newSprite(0,0,false,true,"discoLights")
discoLights:makeGraphic(width,height,colorFromString("0xffffffff"),false)

newCamera(0,0,'extraRecCam1')
newCamera(0,0,'extraRecCam2')
newCamera(0,0,'extraRecCam3')
newCamera(0,0,'extraRecCam4')
newCamera(0,0,'extraRecCam5')
newCamera(0,0,'extraRecCam6')

newCamera(0,0,'extraNoteCam1')
newCamera(0,0,'extraNoteCam2')
newCamera(0,0,'extraNoteCam3')
newCamera(0,0,'extraNoteCam4')
newCamera(0,0,'extraNoteCam5')
newCamera(0,0,'extraNoteCam6')

newCamera(0,0,'extraSusCam1')
newCamera(0,0,'extraSusCam2')
newCamera(0,0,'extraSusCam3')
newCamera(0,0,'extraSusCam4')
newCamera(0,0,'extraSusCam5')
newCamera(0,0,'extraSusCam6')

newCamera(0,0,'extraCam')
newCamera(0,0,'pauseSub') --don't forget or else the pause will go weird!!
discoLights.cameras = {extraCam}

local newNoteCams = {extraNoteCam1,extraNoteCam2,extraNoteCam3,extraNoteCam4,extraNoteCam5,extraNoteCam6};
local newRecCams  = {extraRecCam1,extraRecCam2,extraRecCam3,extraRecCam4,extraRecCam5,extraRecCam6}
local newSusCams  = {extraSusCam1,extraSusCam2,extraSusCam3,extraSusCam4,extraSusCam5,extraSusCam6}


renderedNotes.cameras = {notesCam,extraNoteCam1,extraNoteCam2,extraNoteCam3,extraNoteCam4,extraNoteCam5, extraNoteCam6}
for i=1,#receptors do
receptors[i].cameras = {receptorCam,extraRecCam1,extraRecCam2,extraRecCam3,extraRecCam4,extraRecCam5, extraRecCam6}
end

sustainNotes.cameras = {holdCam,extraSusCam1,extraSusCam2,extraSusCam3,extraSusCam4,extraSusCam5,extraSusCam6}

define("camGroupXOffset", 0)
define("camGroupYOffset", 0)
define("camGroupAngleOffset", 0)

define("cameraX", 0)
define("cameraY", 0)
define("cameraAngle", 0)
define("cameraAlpha", 100)
define("noteRpm", math.pi*100)
define("discoAlpha", 0.01)

function update(elapsed)

	rpm = modMgr:get("noteRpm", 0)
	if canSpin then 
		--if not revOptie then
		spinTime = spinTime + elapsed
		--else spinTime = spinTime - elapsed end
	else spinTime = 0
	end
	
	discoLights.alpha = modMgr:get("discoAlpha",0)
	
	if curStep >= 572 then setOption("raymarcher",false); end
	
	if curStep >= 574 then
		for i=1,#newSusCams do
		newSusCams[i].alpha = 0.6
		newRecCams[i].alpha = 1
		newNoteCams[i].alpha = 1
		end
	else
	for i=1,#newSusCams do
	newSusCams[i].alpha = 0.0001
	newRecCams[i].alpha = 0.0001
	newNoteCams[i].alpha = 0.0001
	end
	end
	
	for i=1,#newRecCams do
	local q = (-1)^i
	local x = modMgr:get("camGroupXOffset",0)*100
	local y = modMgr:get("camGroupYOffset",0)*100
	
	local d = modMgr:get("camGroupAngleOffset", 0)*100
	
	local oX = modMgr:get("camGroupXOffset",0)
	
	receptorCam.x = -x + modMgr:get("cameraX", 0)*100
	receptorCam.y = -y + modMgr:get("cameraY", 0)*100
	receptorCam.angle = modMgr:get("cameraAngle", 0)*100
	holdCam.x = receptorCam.x
	holdCam.y = receptorCam.y
	notesCam.x = receptorCam.x
	notesCam.y = receptorCam.y
	
	
	newRecCams[i].x = receptorCam.x + x*i - ((x*i)/2)
	newNoteCams[i].x = notesCam.x + x*i - ((x*i)/2)
	newSusCams[i].x = holdCam.x + x*i - ((x*i)/2)
	newRecCams[i].angle =receptorCam.angle*i*q + d
	newNoteCams[i].angle=newRecCams[i].angle
	newSusCams[i].angle =newRecCams[i].angle
	newRecCams[i].y = receptorCam.y + y*i - ((y*i)/2)
	newNoteCams[i].y = notesCam.y + y*i* - ((y*i)/2)
	newSusCams[i].y = holdCam.y + y*i - ((y*i)/2)
	end
	
	if curBeat < 112 or curBeat >= 272 then canSpin = true
	elseif curBeat >= 112 and curBeat < 176 then canSpin = false for i=0,3 do modMgr:set("note"..i.."Angle", 0) end
	elseif curBeat >= 176 and curBeat < 260 then
	receptorCam.alpha = 0
	notesCam.alpha = 0
	holdCam.alpha = 0
	--for i=1,4 do modMgr:set("confusion"..(i-1), -newRecCams[i].angle-modMgr:get("cameraAngle", 0)*100) end
	end
	
	if curBeat >= 260 then
		for i=1,#newRecCams do
		newRecCams[i].alpha = modMgr:get("cameraAlpha",0)
		newSusCams[i].alpha = modMgr:get("cameraAlpha",0)
		newNoteCams[i].alpha = modMgr:get("cameraAlpha",0)
		receptorCam.alpha = 1-modMgr:get("cameraAlpha",0)
		notesCam.alpha = 1-modMgr:get("cameraAlpha",0)
		holdCam.alpha = 1-modMgr:get("cameraAlpha",0)
		end
	end
	
	if canSpin then dizzy(rpm) end

end

function stepHit(step)
	--if step == 576 then
	--	discoLights.alpha = 1
	--	discoLights:tween({alpha = 0.4}, stepCrochet/1000, "circOut")
	--end
	if step > 576 and step < 1088 then trickyDisco() end
	if step == 1088 then discoLights:tweenColor(discoLights:getProperty("color"), -1, 0.001, "linear") end
	--if step == 1056 then discoLights:tween({alpha = 0},(32*stepCrochet/1000), "linear") end
end

function trickyDisco()
	local r = {}
	local c = discoLights:getProperty("color")
	local nm= math.random(1,2)
	
	for i=1,#colors do
		if colors[i] ~= c then table.insert(r, colors[i]) end
	end
	discoLights:tweenColor(c,r[nm],stepCrochet/1000, "linear")
end

function newLoop(hajime, owari, mod, beats, offset, func)
	if (beats == nil) then beats = {4,12}; end
	for step=hajime,owari do
		for i=1,#beats do
			if ((step + offset)%mod == beats[i]) then func(step) rvrs = -rvrs end
		end
	end
end

function dizzy(speed)
	for i=0,3 do modMgr:set("note"..i.."Angle", (360*spinTime*speed)%360) end
end

local function queueBeatSet(step, modName, perc, pn)
	modMgr:queueSet(step*4,modName,perc, pn)
end

local function queueBeatEase(begin, en, modName, perc, ease, pn)
	modMgr:queueEase(begin*4, en*4, modName, perc, ease, pn)
end




function fill(step, func)
	for i=step,step+7 do
		if i%8==0 or
		i%8==1 or
		i%8==2 or
		i%8==4 or
		i%8==6 then
		rvrs = -rvrs
		func(i) end
	end
end

function reset(step,dur,ease,limit,pn)
	if limit=="dizReceptor" or limit=="none"then
		for r=0,3 do
			modMgr:queueEase(step, step+dur, "confusion"..r, 0, ease, pn)
		end
	end
	if limit=="noteOrder" or limit=="none" then
		modMgr:queueEase(step, step+dur, "flip", 0, ease, pn)
		modMgr:queueEase(step, step+dur, "invert", 0, ease, pn)
	end
end

function hat(step, endStep, func)
	for i=step,endStep-1 do
		if i%4~=1 and i%16 ~= 0 then func(i) end
	end
end

function halfBeat(beat, endBeat, func)
	for i=beat*4, endBeat*4 do
		local b = i/4
		if b%4==2 then func(i) end
	end
end

modMgr:set("drunk", 100)
modMgr:set("tipsy", -57)

fill(56, function(i)
	modMgr:queueEase(i, i+0.5, "drunk", 175*rvrs, "linear")
end)

modMgr:queueEase(64, 70, "drunk", 30, "linear")
modMgr:queueEase(64, 70, "tipsy", -30,"linear")

fill(184, function(i)
	modMgr:queueEase(i, i+0.5, "tipsy", 120*rvrs, "linear")
end)

modMgr:queueEase(192, 200, "tipsy", -30,"linear")

hat(64,127, function(i)
	local n = math.floor(reap/2)%4
	modMgr:queueEase(i,i+1.5,"confusion"..n, 90*math.random(1, 3), "quadOut", 1)
	reap = reap+1
end)

hat(128,191, function(i)
	local n = math.floor(reap/2)%4
	modMgr:queueEase(i,i+1.5,"confusion"..n, 90*math.random(1, 3), "quadOut", 0)
	reap = reap+1
end)

reset(128, 3, "quadOut", "none", 1)
reset(128, 3, "quadOut", "none", 0)
reset(192, 3, "quadOut", "none", 1)
reset(192, 3, "quadOut", "none", 0)


halfBeat(16, 47, function(i)
	local flippy = math.random(0, 1)
	modMgr:queueSet(i-0.1, "beat", 300*rvrs)
	modMgr:queueSet(i+3, "beat", 0)
	if flippy == 0 and rvrs == -1 then
	modMgr:queueEase(i, i+4, "invert", 0, "quadOut")
	modMgr:queueEase(i, i+4, "flip", 100, "quadOut")
	elseif flippy == 1 and rvrs == -1 then
	modMgr:queueEase(i, i+4, "invert", 100, "quadOut")
	modMgr:queueEase(i, i+4, "flip", 0, "quadOut")
	end
	if rvrs == 1 then
	modMgr:queueEase(i, i+4, "invert", 0, "quadOut")
	modMgr:queueEase(i, i+4, "flip", 0, "quadOut")
	end
	rvrs = -rvrs
end)
halfBeat(48, 110, function(i)
	local flippy = math.random(0, 2)
	if flippy == 0 then
	modMgr:queueEase(i, i+4, "wave", 100, "quadOut")
	modMgr:queueEase(i, i+4, "boost", 0, "quadOut")
	modMgr:queueEase(i, i+4, "brake", 0, "quadOut")
	elseif flippy == 1 then
	modMgr:queueEase(i, i+4, "boost", 100, "quadOut")
	modMgr:queueEase(i, i+4, "wave", 0, "quadOut")
	modMgr:queueEase(i, i+4, "brake", 0, "quadOut")
	elseif flippy == 2 then
	modMgr:queueEase(i, i+4, "brake", -100, "quadOut")
	modMgr:queueEase(i, i+4, "boost", 0, "quadOut")
	modMgr:queueEase(i, i+4, "wave", 0, "quadOut")
	end
end)
queueBeatEase(111, 112, "drunk", 0, "linear")
queueBeatEase(111, 112, "wave", 0, "quadOut")
queueBeatEase(111, 112, "boost", 0, "quadOut")
queueBeatEase(111, 112, "brake", 0, "quadOut")
queueBeatEase(111, 112, "hidden", 100, "quadOut")
queueBeatEase(111, 112, "sudden", 100, "quadOut")

fill(126*4, function(i)
	modMgr:queueEase(i, i+0.5, "tipsy", 120*rvrs, "linear")
end)

for i=0,15 do
	modMgr:queueEase(512+i*2, 513.5+i*2, "drunk", 150*rvrs, "quadOut")
	rvrs = -rvrs
end
for i=0,15 do
	modMgr:queueEase(544+i, 544.75+i, "drunk", 150*rvrs, "quadOut")
	rvrs = -rvrs
end

modMgr:queueEase(560, 564, "drunk", 0, "quadOut")

queueBeatEase(128,129, "tipsy", 0, "linear")

queueBeatEase(128,136, "hidden", 0, "linear")
queueBeatEase(128,136, "sudden", 0, "linear")
queueBeatEase(128,136, "stealth",50, "linear")
queueBeatEase(136,140, "stealth", 0, "linear")
queueBeatSet(112,"noteRpm", 0)

fill(142*4, function(i)
	if i%8==0 then
	modMgr:queueEase(i,i+1,"centered",100, "linear")
	modMgr:queueEase(i,i+1, "invert", 0, "quadOut")
	elseif i%8==1 then
	modMgr:queueEase(i,i+1,"opponentSwap",50,"linear")
	elseif i%8==2 then
	modMgr:queueEase(i,i+2,"centered",0,"linear", 1)
	elseif i%8==4 then
	modMgr:queueEase(i,i+2,"centered",400,"linear",0)
	elseif i%8==6 then
	modMgr:queueEase(i,i+2,"camGroupXOffset", 900, "quadOut")
	rvrs = -1;
	end
end)
queueBeatEase(143,144,"beat",120,"quadInOut")

queueBeatSet(144,"discoAlpha", 100)
queueBeatEase(144,145, "discoAlpha", 40,"linear")

queueBeatEase(145,148,"localrotate0X",math.rad(180), "quadInOut",1)
queueBeatEase(145,148,"localrotate2X",math.rad(180), "quadInOut",1)
newLoop(148*4,152*4,16,{0,1,2,6,7,8,12,13,14},0,function(i)
	if rvrs == -1 then modMgr:queueEase(i,i+1,"invert", 100, "cubeOut")
	elseif rvrs == 1 then modMgr:queueEase(i,i+1,"invert", 0, "cubeOut")
	end
	
	if i%16==14 then rvrs = -rvrs end
end)



queueBeatEase(153,156,"localrotate0X",0, "quadInOut",1)
queueBeatEase(153,156,"localrotate2X",0, "quadInOut",1)

newLoop(156*4,160*4, 16, {0,1,3,4,6,7,8,12},0,function(i)
	if i%16==0 then
	modMgr:queueEase(i,i+1,"flip", 100, "cubeOut")
	elseif i%16 == 1 then
	modMgr:queueEase(i,i+1,"invert", -100, "cubeOut")
	elseif i%16 == 3 then
	modMgr:queueEase(i,i+1,"invert", 0, "cubeOut")
	elseif i%16 == 4 then
	modMgr:queueEase(i,i+1,"flip", 0, "cubeOut")
	elseif i%16 == 6 then
	modMgr:queueEase(i,i+1,"flip", 100, "cubeOut")
	elseif i%16 == 7 then
	modMgr:queueEase(i,i+1,"invert", -100, "cubeOut")
	elseif i%16 == 8 then
	modMgr:queueEase(i,i+4,"invert", 0, "linear")
	elseif i%16 == 12 then
	modMgr:queueEase(i,i+4,"flip", 0, "linear")
	end
	rvrs = 1
end)

queueBeatEase(161,164,"localrotate0X",math.rad(180), "quadInOut",0)
queueBeatEase(161,164,"localrotate2X",math.rad(180), "quadInOut",0)

newLoop(164*4,168*4,16,{0,1,2,6,7,8,14,15},0,function(i)
	if rvrs == -1 then modMgr:queueEase(i,i+1,"invert", 100, "cubeOut")
	elseif rvrs == 1 then modMgr:queueEase(i,i+1,"invert", 0, "cubeOut")
	end
	
	if i%16==14 then rvrs = -rvrs end
end)

queueBeatEase(169,172,"localrotate0X",0, "quadInOut",0)
queueBeatEase(169,172,"localrotate2X",0, "quadInOut",0)

newLoop(172*4,174*4, 16, {0,1,3,4,6,7},0,function(i)
	if i%16==0 then
	modMgr:queueEase(i,i+1,"flip", 100, "cubeOut")
	elseif i%16 == 1 then
	modMgr:queueEase(i,i+1,"invert", -100, "cubeOut")
	elseif i%16 == 3 then
	modMgr:queueEase(i,i+1,"invert", 0, "cubeOut")
	elseif i%16 == 4 then
	modMgr:queueEase(i,i+1,"flip", 0, "cubeOut")
	elseif i%16 == 6 then
	modMgr:queueEase(i,i+1,"flip", 100, "cubeOut")
	elseif i%16 == 7 then
	modMgr:queueEase(i,i+1,"flip", 0, "cubeOut")
	rvrs = 1
	end
end)

for i=0,7 do
	local h = i+1
	if i>3 then h = 7-i end
	queueBeatEase(144+i*4, 148+i*4, "cameraX", -100*((-1)^i)*h, "sineInOut")
end

queueBeatEase(158,160,"centered",0,"sineInOut", 0)
queueBeatEase(158,160,"centered",400,"sineInOut", 1)
if not revOptie then
	queueBeatEase(174,176,"centered",100,"sineInOut",0)
	queueBeatEase(174,176,"centered",40,"sineInOut",1)
	queueBeatEase(206,208,"centered",180,"sineIn", 1)
	--queueBeatEase(174,176,"centered",80,"sineInOut",0)
	--queueBeatEase(174,176,"centered",25,"sineInOut",1)
	--queueBeatEase(206,208,"centered",150,"sineIn", 1)
else
	queueBeatEase(174,176,"centered",100,"sineInOut",0)
	queueBeatEase(174,176,"centered",170,"sineInOut",1)
	queueBeatEase(206,208,"centered",180,"sineIn", 1)
end
queueBeatEase(174,176,"beat",0,"sineInOut")
queueBeatEase(174,176,"stealth",50,"sineInOut", 1)
queueBeatEase(174,176,"localrotateZ",math.rad(30),"sineInOut", 1)
queueBeatEase(174,176,"flip",50,"sineInOut")
queueBeatEase(174,176,"cameraAngle",60,"sineInOut")
queueBeatEase(174,176,"camGroupXOffset", 0,"sineInOut")
queueBeatEase(176,182,"camGroupAngleOffset", 60,"sineInOut")
queueBeatEase(182,188,"camGroupAngleOffset",-60,"sineInOut")
queueBeatEase(188,194,"camGroupAngleOffset",120,"sineInOut")
queueBeatEase(194,200,"camGroupAngleOffset",-240,"sineInOut")
queueBeatEase(200,206,"camGroupAngleOffset",360,"sineInOut")
queueBeatEase(206,208,"flip",22.5,"sineIn", 1)
queueBeatEase(206,208,"localrotateZ",0,"sineIn", 1)
queueBeatEase(206,208,"camGroupAngleOffset",180,"sineIn")
queueBeatEase(208,216,"camGroupAngleOffset",-720,"linear")
queueBeatEase(216,218,"camGroupAngleOffset",-900,"sineOut")
queueBeatEase(218,220,"camGroupAngleOffset",-660,"sineIn")
queueBeatEase(220,228,"camGroupAngleOffset",540,"linear")
queueBeatEase(228,230,"camGroupAngleOffset",780,"sineOut")
queueBeatEase(230,232,"camGroupAngleOffset",540,"sineIn")
queueBeatEase(232,240,"camGroupAngleOffset",-660,"linear")
queueBeatEase(240,242,"camGroupAngleOffset",-900,"sineOut")
queueBeatEase(242,244,"camGroupAngleOffset",-660,"sineIn")
queueBeatEase(244,252,"camGroupAngleOffset",540,"linear")
queueBeatEase(252,254,"camGroupAngleOffset",780,"sineOut")
queueBeatEase(254,256,"camGroupAngleOffset",540,"sineIn")
queueBeatEase(256,264,"camGroupAngleOffset",-660,"linear")
queueBeatEase(264,266,"camGroupAngleOffset",-900,"sineOut")
queueBeatEase(266,272,"camGroupAngleOffset",0,"sineInOut")
queueBeatEase(266,272,"cameraAlpha",0,"linear")
queueBeatEase(266,272,"cameraAngle",0,"sineInOut")
queueBeatEase(266,272,"dark",100,"linear",1)
queueBeatEase(260,272,"stealth",100,"linear",1)
queueBeatEase(264,272,"discoAlpha",0,"linear")
queueBeatEase(272,304,"centered",0,"linear")
queueBeatEase(272,304,"flip",0,"linear")
queueBeatEase(272,304,"opponentSwap",0,"linear")
queueBeatEase(272,336,"drift",100,"linear")
queueBeatEase(272,336,"tipsy",-57,"linear")
queueBeatEase(272,272.1,"noteRpm",100*math.pi,"linear")
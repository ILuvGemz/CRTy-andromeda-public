local rvrs = 1

function rendaBeat(hajime, owari, func)
	for step = hajime*4,owari*4 do
	local beat = step/4
		if (step%4==0) then func(step,beat) end
	end
end

function newLoop(hajime, owari, mod, beats, offset, func)
	if (beats == nil) then beats = {4,12}; end
	for step=hajime,owari do
		for i=1,#beats do
			if ((step + offset)%mod == beats[i]) then func(step) rvrs = -rvrs end
		end
	end
end

function define(name, n, pn)
	modMgr:define(name)
	modMgr:set(name, n, pn)
end

define("reverse0", 0)
define("reverse1", 0)
define("reverse2", 0)
define("reverse3", 0)

function revEase(begin, en, val, ease, pn)
	for i=0,3 do
	modMgr:queueEase(begin, en, "reverse"..i, val/2, ease, pn)
	end
end

function revSet(val, pn)
	for i=0,3 do
	modMgr:set("reverse"..i, val/2, pn)
	end
end


local bt = 1;
local finalTime = {0, 0, 0, 0, 0, 0, 0, 0};
local caroTime = 0;
local reverses = {{false,false,false,false},{false,false,false,false}}
local chroOne = true;
local noteChange = 0;

modMgr:set("drunk", 200);
modMgr:queueEase(0, 127, "drunk", -100, "linear");
modMgr:queueEase(128, 239, "drunk", 0, "linear")
modMgr:queueEase(128, 191, "tipsy",50, "linear");
modMgr:queueSet(128, "beat", 100);
modMgr:queueEase(192, 240, "tipsy", 0, "linear")
modMgr:queueSet(239, "beat", 0)

rendaBeat(32, 59, function(step,beat)
	modMgr:queueSet(step, "tornado", 90*bt)
	modMgr:queueEase(step, step+3, "tornado", 0, "cubeOut")
	bt = -bt;
end)

for i=240,272 do
	local burn = ((240 - i)/32)*(-1)^i;
	modMgr:queueSet(i, "drunk", -200*burn)
	modMgr:queueEase(i, i+0.9,"drunk", 0, "linear")
end

function goodNoteHit(data, stime, pos, sus)
	if(curStep >= 272 and curStep < 396 and not sus) then
		reverses[1][data] = not reverses[1][data]
		if reverses[1][data] then
		modMgr:queueEase(curStep, curStep + 6, "reverse"..data, 50, "quadOut",0)
		elseif not reverses[1][data] then
		modMgr:queueEase(curStep, curStep + 6, "reverse"..data,  0, "quadOut",0)
		end
	end
end

function dadNoteHit(data, stime, pos, anim, sus)
	if(curStep >= 272 and curStep < 396 and not sus) then
		reverses[2][data] = not reverses[2][data]
		if reverses[2][data] then
		modMgr:queueEase(curStep, curStep + 6, "reverse"..data, 50, "quadOut",1)
		elseif not reverses[2][data] then
		modMgr:queueEase(curStep, curStep + 6, "reverse"..data,  0, "quadOut",1)
		end
	end
end

newLoop(368, 400, 32, {0,4,6,8,12,14,16,18,20,22,24,25,26,27,28,29,30,31},16, function(i)
	modMgr:queueEase(i,i+1, "drunk", 200*rvrs, "quadOut")
end)

modMgr:queueEase(400, 408, "flip", -50, "quadIn")
modMgr:queueEase(400, 408,"opponentSwap",40,"quadOut")
modMgr:queueEase(400, 408,"drunk",0,"quadOut")
modMgr:queueEase(400, 404,"stealth",50,"quadOut",1)
revEase(400, 408, 0, "quadOut",1)
revEase(400, 408, 100, "quadOut",0)

modMgr:queueSet(416, "beat", 100,0)
modMgr:queueSet(416, "beat",-100,1)

newLoop(416, 528, 32, {4,12,20,28}, 0, function(step)
	if chorOne then
		if step%32==4 then modMgr:queueEase(step,step+4,"opponentSwap",60,"quadOut")
		elseif step%32==12 then revEase(step,step+4, 100, "quadOut", 0)
		revEase(step,step+4, 0, "quadOut", 1)
		elseif step%32==20 then modMgr:queueEase(step,step+4,"stealth",50,"quadOut",1)
		modMgr:queueEase(step,step+4,"stealth",0,"quadOut",0)
		elseif step%32==28 then modMgr:queueEase(step,step+4,"opponentSwap",40,"quadOut")
		chorOne = not chorOne
		end
	elseif not chorOne then
		if step%32==4 then modMgr:queueEase(step,step+4,"opponentSwap",60,"quadOut")
		elseif step%32==12 then revEase(step,step+4, 100, "quadOut", 1)
		revEase(step,step+4, 0, "quadOut", 0)
		elseif step%32==20 then modMgr:queueEase(step,step+4,"stealth",50,"quadOut",0)
		modMgr:queueEase(step,step+4,"stealth",0,"quadOut",1)
		elseif step%32==28 then modMgr:queueEase(step,step+4,"opponentSwap",40,"quadOut")
		chorOne = not chorOne
		end
	end
end)

modMgr:queueEase(528, 536, "stealth", 0, "linear")
modMgr:queueEase(528, 536, "opponentSwap", 0, "linear")
modMgr:queueEase(528, 536, "flip", 0, "linear")
modMgr:queueEase(528, 536, "beat", 100, "linear")
revEase(528, 536, 0, "linear")

for i=0,3 do
	local t = i
	if i == 2 then t = 1
	elseif i == 1 then t = 2
	end
	modMgr:queueEase(592+i*2, 598+i*2, "localrotate"..t.."X", math.rad(180), "quadOut",1)
	modMgr:queueEase(600+i*2, 606+i*2, "localrotate"..t.."X", math.rad(360), "quadOut",1)
	modMgr:queueEase(720+i*2, 726+i*2, "localrotate"..t.."X", math.rad(180), "quadOut",0)
	modMgr:queueEase(728+i*2, 734+i*2, "localrotate"..t.."X", math.rad(360), "quadOut",0)
end

for i=0,3 do
	modMgr:queueEase(656+i*2, 662+i*2, "localrotate"..i.."Z", -math.rad(180), "quadOut",1)
	modMgr:queueEase(664+i*2, 670+i*2, "localrotate"..i.."Z", -math.rad(360), "quadOut",1)
	modMgr:queueEase(784+i*2, 790+i*2, "localrotate"..i.."Z", -math.rad(180), "quadOut",0)
	modMgr:queueEase(792+i*2, 798+i*2, "localrotate"..i.."Z", -math.rad(360), "quadOut",0)
end

newLoop(544,800, 16, {12}, 0, function(i)
	noteChange = (noteChange+1)%8
	local pn = 1
	if i > 672 then pn = 0 end
	if noteChange==1 then
		modMgr:queueEase(i,i+6,"flip",100,"sineOut",pn)
		modMgr:queueEase(i,i+6,"invert",0,"sineOut",pn)
	elseif noteChange==2 then
	modMgr:queueEase(i,i+6,"invert",100,"sineOut",pn)
	modMgr:queueEase(i,i+6,"flip",0,"sineOut",pn)
	elseif noteChange==3 then
	modMgr:queueEase(i,i+6,"flip",25,"sineOut",pn)
	modMgr:queueEase(i,i+6,"invert",-75,"sineOut",pn)
	elseif noteChange==5 then
	modMgr:queueEase(i,i+6,"flip",100,"sineOut",pn)
	modMgr:queueEase(i,i+6,"invert",-100,"sineOut",pn)
	elseif noteChange==6 then
	modMgr:queueEase(i,i+6,"flip",75,"sineOut",pn)
	modMgr:queueEase(i,i+6,"invert",75,"sineOut",pn)
	elseif noteChange==7 then
	modMgr:queueEase(i,i+6,"flip",0,"sineOut",pn)
	modMgr:queueEase(i,i+6,"invert",0,"sineOut",pn)
	end
end)


modMgr:queueEase(1024,1040,"centered",100,"sineInOut")
modMgr:queueEase(832,896,"flip",50,"linear")
modMgr:queueEase(832,896,"beat",0,"linear")
modMgr:queueEase(832,896,"centered",18,"linear")
modMgr:queueEase(832,896,"opponentSwap",50,"linear")
modMgr:queueEase(832,896,"stealth",50,"linear",1)

function update(elapsed)
	for i = 0,7 do
		local modi = i%4
		if curDecStep > (896 + i*2) then
			finalTime[i+1] = finalTime[i+1] + elapsed
			modMgr:set("transform"..modi.."X", math.sin((finalTime[i+1]/(crochet*4/1000)) * math.pi *2)*400, 1-math.floor(i/4))
			modMgr:set("transform"..modi.."Z", -math.cos((finalTime[i+1]/(crochet*4/1000)) * math.pi *2 )*0.2, 1-math.floor(i/4))
			if curDecStep > 1040 then
			caroTime = caroTime + elapsed
			modMgr:set("transformY", math.sin(caroTime/(crochet*4/1000)*(math.pi/6))*170, 1)
			revSet( math.max(0,math.sin(caroTime/(crochet*4/1000)*(math.pi/6)))*100, 1)
			modMgr:set("transformY",-math.sin(caroTime/(crochet*4/1000)*(math.pi/6))*170, 0)
			revSet(math.max(0,-math.sin(caroTime/(crochet*4/1000)*(math.pi/6)))*100, 0)
			end
		end
	end
	
	modMgr:set("alternate", (-50)*modMgr:get('reverse0',0) + 50*modMgr:get('reverse1',0) - 50*modMgr:get('reverse2',0) +50*modMgr:get('reverse3',0), 0)
	modMgr:set("cross", (-50)*modMgr:get('reverse0',0) + 50*modMgr:get('reverse1',0) + 50*modMgr:get('reverse2',0) - 50*modMgr:get('reverse3',0), 0)
	modMgr:set("split", (-50)*modMgr:get('reverse0',0) + (-50)*modMgr:get('reverse1',0) + 50*modMgr:get('reverse2',0) + 50*modMgr:get('reverse3',0), 0)
	modMgr:set("reverse", 100*modMgr:get('reverse0',0), 0)
	
	modMgr:set("alternate", (-50)*modMgr:get('reverse0',1) + 50*modMgr:get('reverse1',1) - 50*modMgr:get('reverse2',1) +50*modMgr:get('reverse3',1), 1)
	modMgr:set("cross", (-50)*modMgr:get('reverse0',1) + 50*modMgr:get('reverse1',1) + 50*modMgr:get('reverse2',1) - 50*modMgr:get('reverse3',1), 1)
	modMgr:set("split", (-50)*modMgr:get('reverse0',1) + (-50)*modMgr:get('reverse1',1) + 50*modMgr:get('reverse2',1) + 50*modMgr:get('reverse3',1), 1)
	modMgr:set("reverse", 100*modMgr:get('reverse0',1), 1)
end
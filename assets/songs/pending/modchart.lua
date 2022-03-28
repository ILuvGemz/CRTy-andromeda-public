local revVar = 1;
local marker = true;
local spOne = 0;
local spTwo = 0;

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
			if ((step + offset)%mod == beats[i]) then func(step) end
		end
	end
end

modMgr:queueEase(0,3.3,"opponentSwap",100,"quadOut");
modMgr:queueEase(4,7.3,"opponentSwap",0,"quadOut");

for i=0,8 do
	modMgr:queueEase(8+i,8+0.7+i, "opponentSwap", 100-(i*100/8), "quadOut");
	modMgr:queueEase(8+i,8+0.7+i, "flip", 100-(i*100/8), "quadOut");
	modMgr:queueEase(8+i,8+0.7+i, "reverse", 100-(i*100/8), "quadOut");
end

modMgr:queueEase(8, 16,"stealth", 50, "linear");
modMgr:queueEase(14,16,"drunk",169,"sineIn")
modMgr:queueEase(16,60,"drunk",0,"linear")
modMgr:queueEase(20, 32, "stealth",0,"sineIn")
modMgr:queueEase(73,76,"mini",-100,"quadIn")
modMgr:queueEase(76, 79,"mini", 0, "quadOut")
modMgr:queueSet(75.5,"beat",600)
modMgr:queueSet(80, "beat",0)
rendaBeat(20,31,function(step,beat)
	modMgr:queueSet(step, "tipsy", 124)
	modMgr:queueEase(step, step+3,"tipsy", 0, "circOut")
	modMgr:queueSet(step, "localrotateZ", math.rad(36)*revVar)
	modMgr:queueEase(step, step+3,"localrotateZ", 0, "circOut")
	modMgr:queueSet(step, "confusion", 10*revVar)
	modMgr:queueEase(step, step+3,"confusion", 0, "circOut")
	revVar = -revVar
end)

modMgr:queueEase(137,140,"mini",-100,"quadIn")
modMgr:queueEase(140,143,"mini", 0, "quadOut")
modMgr:queueSet(139.5,"beat",-600)
modMgr:queueSet(144, "beat",0)

newLoop(144,208,32,{4,12,18,22,28},16,function(step)
	modMgr:queueSet(step, "tipsy", 124)
	modMgr:queueEase(step, step+3,"tipsy", 0, "circOut")
	modMgr:queueSet(step, "localrotateZ", math.rad(36)*revVar)
	modMgr:queueEase(step, step+3,"localrotateZ", 0, "circOut")
	modMgr:queueSet(step, "confusion", 10*revVar)
	modMgr:queueEase(step, step+3,"confusion", 0, "circOut")
	revVar = -revVar
end)

modMgr:queueSet(144,"beat",80)

newLoop(208,272,16,{0,2,3,4,6,10,12},16,function(step)
	if marker then 
		if ((step+16)%16 ~= 12) then modMgr:queueEase(step, step+1,"tipsy", 70*revVar, "linear")
		modMgr:queueEase(step, step+1,"tornado", 50, "linear") end
		modMgr:queueEase(step, step+1,"drunk", 0, "linear")
	elseif not marker then
		if ((step+16)%16 ~= 12) then modMgr:queueEase(step, step+1,"drunk", 70*revVar, "linear")
		modMgr:queueEase(step, step+1,"tornado",-50, "linear") end
		modMgr:queueEase(step, step+1,"tipsy", 0, "linear")
	end
	if ((step+16)%16 == 12) then
		modMgr:queueEase(step-3,step,"mini",-100,"quadIn")
		modMgr:queueEase(step,step+3,"mini", 0, "quadOut")
		modMgr:queueSet(step-0.5,"beat",600*revVar)
		modMgr:queueSet(step+4, "beat",0)
		marker = not marker
	end
	revVar = -revVar
end)

modMgr:queueEase(288, 288+3,"drunk", 0, "sineOut")
modMgr:queueEase(288, 288+3,"tipsy", 0, "sineOut")
modMgr:queueEase(288, 288+3,"tornado", 0, "sineOut")

modMgr:queueEase(68*4-2, 68*4, "beat", 0, "linear")
modMgr:queueSet(76*4,"beat",100)

modMgr:queueEase(288,291.3,"opponentSwap",100,"quadOut");
modMgr:queueEase(292,295.3,"opponentSwap",0,"quadOut");

for i=0,8 do
	modMgr:queueEase(296+i,296+0.7+i, "opponentSwap", i*100/8, "quadOut");
	modMgr:queueEase(296+i,296+0.7+i, "flip", 50-math.abs(50-i*100/8), "quadOut");
	modMgr:queueEase(296+i,296+0.7+i, "reverse", i*100/8, "quadOut");
end

modMgr:queueEase(324,324+3.3,"opponentSwap",0,"quadOut");
modMgr:queueEase(332,332+3.3,"opponentSwap",100,"quadOut");

modMgr:queueEase(356,356+3.3,"reverse",0,"quadOut");
modMgr:queueEase(364,364+3.3,"reverse",100,"quadOut");

modMgr:queueEase(388,388+3.3,"cross",100,"quadOut");
modMgr:queueEase(396,396+3.3,"cross",0,"quadOut");
modMgr:queueEase(416,416+3.3,"reverse",0,"quadOut");

modMgr:queueEase(416-2, 416, "beat", 0, "linear")
modMgr:queueEase(426, 428, "opponentSwap", 0, "linear")
modMgr:queueEase(428, 430, "flip", 100, "linear")
modMgr:queueSet(430,"beat",100)

modMgr:queueEase(452,452+3.3,"alternate",100,"quadOut");
modMgr:queueEase(460,460+3.3,"alternate",0,"quadOut");

modMgr:queueEase(484,484+3.3,"flip",0,"quadOut");
modMgr:queueEase(484,484+3.3,"invert",100,"quadOut");
modMgr:queueEase(492,492+3.3,"invert",0,"quadOut");
modMgr:queueEase(492,492+3.3,"flip",100,"quadOut");

modMgr:queueEase(516,516+3.3,"cross",100,"quadOut");
modMgr:queueEase(524,524+3.3,"cross",0,"quadOut");
modMgr:queueEase(528,544,"flip",0,"quadInOut")

modMgr:queueEase(556,560,"beat",0,"quartOut")

modMgr:queueEase(552, 560, "stealth", 50, "linear")
modMgr:queueEase(560, 592, "stealth", 99.8, "linear")
modMgr:queueEase(560, 576, "drunk", 100, "linear")
modMgr:queueEase(592,656, "stealth", 0, "linear")
modMgr:queueEase(592,656,"drunk",0,"linear")
modMgr:queueEase(592,656,"tipsy",0,"linear")

modMgr:queueSet(656, "brake", 300)
modMgr:queueEase(656,657,"brake",0,"quadOut")
modMgr:queueSet(658, "brake", 300)
modMgr:queueEase(658,659,"brake",0,"quadOut")
modMgr:queueEase(662,664,"invert",100,"quadOut")
modMgr:queueEase(666,668,"invert",0,"quadOut")
modMgr:queueEase(670,672,"reverse",100,"quadOut")
modMgr:queueEase(672,673,"split",-50,"quadOut")
modMgr:queueEase(672,673,"cross", 50,"quadOut")
modMgr:queueEase(672,673,"alternate",-50,"quadOut")
modMgr:queueEase(674,675,"split",-100,"quadOut")
modMgr:queueEase(674,675,"cross", 0,"quadOut")
modMgr:queueEase(674,675,"alternate",0,"quadOut")
modMgr:queueEase(676,677,"split",-50,"quadOut")
modMgr:queueEase(676,677,"cross",-50,"quadOut")
modMgr:queueEase(676,677,"alternate",-50,"quadOut")
modMgr:queueEase(678,679,"reverse",0,"quadOut")
modMgr:queueEase(678,679,"split",0,"quadOut")
modMgr:queueEase(678,679,"cross",0,"quadOut")
modMgr:queueEase(678,679,"alternate",0,"quadOut")


modMgr:queueSet(688,"beat", 110)

newLoop(688,752,32,{4,12,18,22,28},16,function(step)
	modMgr:queueSet(step, "tipsy", 124)
	modMgr:queueEase(step, step+3,"tipsy", 0, "circOut")
	modMgr:queueSet(step, "localrotateZ", math.rad(36)*revVar,0)
	modMgr:queueEase(step, step+3,"localrotateZ", 0, "circOut",0)
	modMgr:queueSet(step, "localrotateZ",-math.rad(36)*revVar,1)
	modMgr:queueEase(step, step+3,"localrotateZ", 0, "circOut",1)
	modMgr:queueSet(step, "confusion", 10*revVar,0)
	modMgr:queueEase(step, step+3,"confusion", 0, "circOut",0)
	modMgr:queueSet(step, "confusion",-10*revVar,1)
	modMgr:queueEase(step, step+3,"confusion", 0, "circOut",1)
	revVar = -revVar
end)

newLoop(752,800,16,{0,2,3,4,6,10,12},16,function(step)
	if marker then 
		if ((step+16)%16 ~= 12) then modMgr:queueEase(step, step+1,"tipsy", 70*revVar, "linear")
		modMgr:queueEase(step, step+1,"tornado", 50, "linear") end
	elseif not marker then
		if ((step+16)%16 ~= 12) then modMgr:queueEase(step, step+1,"drunk", 70*revVar, "linear")
		modMgr:queueEase(step, step+1,"tornado",-50, "linear") end
	end
	if ((step+16)%16 == 12) then
		modMgr:queueEase(step, step+2,"drunk", 0, "linear")
		modMgr:queueEase(step, step+2,"tipsy", 0, "linear")
		modMgr:queueEase(step-3,step,"mini",-100,"quadIn")
		modMgr:queueEase(step,step+3,"mini", 0, "quadOut")
		if (spOne == 0) then
			modMgr:queueEase(step, step+4, "reverse", 100, "quadOut")
		elseif (spOne == 1) then
			modMgr:queueEase(step, step+4, "opponentSwap", 100, "quadOut")
		elseif (spOne == 2) then
			modMgr:queueEase(step, step+4, "reverse", 0, "quadOut")
		end
		marker = not marker
		spOne = spOne + 1
	end
	revVar = -revVar
end)

modMgr:queueEase(800, 800+3,"drunk", 0, "sineOut")
modMgr:queueEase(800, 800+3,"tipsy", 0, "sineOut")
modMgr:queueEase(800, 800+3,"tornado", 0, "sineOut")

modMgr:queueEase(809,812,"mini",-100,"quadIn")
modMgr:queueEase(812,815,"mini", 0, "quadOut")
modMgr:queueSet(811.5,"beat",800)
modMgr:queueSet(815.9, "beat",0)
modMgr:queueSet(816, "beat",120)
modMgr:queueEase(812, 812+4, "opponentSwap", 0, "quadOut")

newLoop(816,880,32,{4,12,18,22,28},16,function(step)
	modMgr:queueSet(step, "tipsy", 124)
	modMgr:queueEase(step, step+3,"tipsy", 0, "circOut")
	modMgr:queueSet(step, "localrotateZ", math.rad(36)*revVar,0)
	modMgr:queueEase(step, step+3,"localrotateZ", 0, "circOut",0)
	modMgr:queueSet(step, "localrotateZ",-math.rad(36)*revVar,1)
	modMgr:queueEase(step, step+3,"localrotateZ", 0, "circOut",1)
	modMgr:queueSet(step, "confusion", 10*revVar,0)
	modMgr:queueEase(step, step+3,"confusion", 0, "circOut",0)
	modMgr:queueSet(step, "confusion",-10*revVar,1)
	modMgr:queueEase(step, step+3,"confusion", 0, "circOut",1)
	revVar = -revVar
end)

newLoop(880,944,16,{0,2,3,4,6,10,12},16,function(step)
	if marker then 
		if ((step+16)%16 ~= 12) then modMgr:queueEase(step, step+1,"tipsy", 70*revVar, "linear")
		modMgr:queueEase(step, step+1,"tornado", 50, "linear") end
	elseif not marker then
		if ((step+16)%16 ~= 12) then modMgr:queueEase(step, step+1,"drunk", 70*revVar, "linear")
		modMgr:queueEase(step, step+1,"tornado",-50, "linear") end
	end
	if ((step+16)%16 == 12) then
		modMgr:queueEase(step, step+2,"drunk", 0, "linear")
		modMgr:queueEase(step, step+2,"tipsy", 0, "linear")
		modMgr:queueEase(step-3,step,"mini",-100,"quadIn")
		modMgr:queueEase(step,step+3,"mini", 0, "quadOut")
		if (spTwo == 0) then
			modMgr:queueEase(step, step+4, "split", 100, "quadOut")
		elseif (spTwo == 1) then
			modMgr:queueEase(step, step+4, "cross", 100, "quadOut")
		elseif (spTwo == 2) then
			modMgr:queueEase(step, step+4, "reverse", 100, "quadOut")
		elseif (spTwo == 3) then
			modMgr:queueEase(step, step+4, "split", 0, "quadOut")
			modMgr:queueEase(step, step+4, "cross", 0, "quadOut")
			modMgr:queueEase(step, step+4, "opponentSwap", 50, "quadOut")
		end
		marker = not marker
		spTwo = spTwo + 1
	end
	revVar = -revVar
end)

modMgr:queueEase(940, 940+4, "reverse", 0, "quadOut")

modMgr:queueEase(940,944, "beat",0, "linear")

modMgr:queueEase(944, 944+3,"drunk", 0, "sineOut")
modMgr:queueEase(944, 944+3,"tipsy", 0, "sineOut")
modMgr:queueEase(944, 944+3,"tornado", 0, "sineOut")

modMgr:queueEase(948,992,"tornado", 500, "linear", 1)
modMgr:queueEase(948,992,"tornado",-500, "linear", 0)
modMgr:queueEase(948,992,"drunk", 369, "linear", 0)
modMgr:queueEase(948,992,"drunk",-369, "linear", 1)
modMgr:queueEase(976,992,"bumpy", 200, "linear")
modMgr:queueEase(976,992,"stealth", 50, "cubicInOut")

modMgr:queueEase(976,979.3,"opponentSwap",100,"quadOut");
modMgr:queueEase(980,983.3,"opponentSwap",0,"quadOut");

for i=0,8 do
	modMgr:queueEase(984+i,984+0.7+i, "opponentSwap", 100-(i*100/8), "quadOut");
	modMgr:queueEase(984+i,984+0.7+i, "flip", 100-(i*100/8), "quadOut");
	modMgr:queueEase(984+i,984+0.7+i, "reverse", 100-(i*100/8), "quadOut");
end

modMgr:queueEase(992, 994, "dark", 100, "quadOut")
modMgr:queueEase(992, 994, "transformX",-800, "quadOut", 0)
modMgr:queueEase(992, 994, "transformX", 800, "quadOut", 1)
-- File: ClassicAutoQuest.lua
-- Name: ClassicAutoQuest
-- Author: BobNudd
-- Description: A minimalist auto quest acceptor/hand-in.
-- Version: 1.5.1

local qProgress = CreateFrame("Frame")
qProgress:RegisterEvent("QUEST_PROGRESS")
qProgress:SetScript("OnEvent", function()
	if (IsShiftKeyDown()) then
		return;
	end
	 if (IsQuestCompletable()) then
		CompleteQuest();
	 end
end)


local qLogUpdate = CreateFrame("Frame")
qLogUpdate:RegisterEvent("QUEST_GREETING")
qLogUpdate:SetScript("OnEvent", function()
	if (IsShiftKeyDown()) then
		return;
	end
	for index= 1, GetNumActiveQuests() do
		local quest, isComplete = GetActiveTitle(index)
		if isComplete then
			SelectActiveQuest(index)
		end
	end
	for index= 1, GetNumAvailableQuests() do
		SelectAvailableQuest(index)
	end
end)


local qDetail = CreateFrame("Frame")
qDetail:RegisterEvent("QUEST_DETAIL")
qDetail:SetScript("OnEvent", function()
	if (IsShiftKeyDown()) then
		return;
	end
	local num = GetNumQuestChoices();
	AcceptQuest();
	if (num <= 0) then
		return
	end
	for x = 1, num do
		__QuestReward(x);
	end
end)


 function __QuestReward(index)
	local link = GetQuestItemLink("choice", index);
 	if (not link) then
		 _qItemLookup("QuestReward",1 ,function(self) return __QuestReward() end)
	else
		print("|cFF00FF00 C-AQ: Quest reward : ", link);
	end
 end



local qGossip = CreateFrame("Frame")
qGossip:RegisterEvent("GOSSIP_SHOW")
qGossip:SetScript("OnEvent", function()
	if (IsShiftKeyDown()) then
		return;
	end
	if (GetNumGossipAvailableQuests() > 0) then
		local arg = { GetGossipAvailableQuests() }
		local i = 1
		while(arg[i]) do
			SelectGossipAvailableQuest(i);
			i = i + 1;
		end
	end
	if (GetNumGossipActiveQuests() > 0) then
		local cnt = GetNumGossipActiveQuests();
		for i = 1, cnt do
			SelectGossipActiveQuest(i); 
			_QuestChoices();
			i = i + 1;
		end
	end
end)


local qComplete = CreateFrame("Frame")
qComplete:RegisterEvent("QUEST_COMPLETE")
qComplete:SetScript("OnEvent", function()
	if (IsShiftKeyDown()) then
		return;
	end
	_QuestChoices();
end)


function _QuestChoices()
	if (GetQuestMoneyToGet() > 0) then
		print("AQH: Quest requires monies to complete");
	end
	if (GetNumQuestChoices() == 0) then
		QuestFrameCompleteButton:Click();
		QuestFrameCompleteQuestButton:Click();
	end
	if (GetNumQuestChoices() == 1) then
		QuestInfoFrame.itemChoice = 1; 
		GetQuestReward(QuestInfoFrame.itemChoice);
		QuestFrameCompleteButton:Click();
	end
end



function _qItemLookup(TimerName,Time,funct,...)
	local framename = "TimeFrame"..TimerName
	if _G[framename] and (_G[framename]:GetScript("OnUpdate") ~= nil) then return end

	local frame = CreateFrame("Frame", framename)
	local totalElapsed = 0.0
	local tickcount = 0
	local vars = {...}
	
	local function LibKjasiTimer_onUpdate(self, elapsed)
		totalElapsed = totalElapsed + elapsed
		if (totalElapsed < 1) then return end
		totalElapsed = totalElapsed - floor(totalElapsed)
		tickcount = tickcount + 1

		if (tickcount == Time) then
			local result = funct(vars)
			frame:SetScript("OnUpdate", nil)
			return result
		end
	end
	frame:SetScript("OnUpdate", LibKjasiTimer_onUpdate)
	frame:Show()
end
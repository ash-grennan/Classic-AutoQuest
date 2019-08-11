-- File: ClassicAutoQuest.lua
-- Name: ClassicAutoQuest
-- Author: BobNudd
-- Description: A minimalist auto quest acceptor/hand-in.
-- Version: 1.3.0




local qProgress = CreateFrame("Frame")
qProgress:RegisterEvent("QUEST_PROGRESS")
qProgress:SetScript("OnEvent", function()
	 if (IsQuestCompletable()) then
		CompleteQuest();
	 end
end)


local qLogUpdate = CreateFrame("Frame")
qLogUpdate:RegisterEvent("QUEST_GREETING")
qLogUpdate:SetScript("OnEvent", function()
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
	 AcceptQuest();
end)


local qGossip = CreateFrame("Frame")
qGossip:RegisterEvent("GOSSIP_SHOW")
qGossip:SetScript("OnEvent", function()
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
-- File: ClassicAutoQuest.lua
-- Name: ClassicAutoQuest
-- Author: BobNudd
-- Description: A minimalist auto quest acceptor/hand-in.
-- Version: 1.1.0



local detail = CreateFrame("Frame")
detail:RegisterEvent("QUEST_DETAIL")
detail:SetScript("OnEvent", function()
	 AcceptQuest();
end)


local gossip = CreateFrame("Frame")
gossip:RegisterEvent("GOSSIP_SHOW")
gossip:SetScript("OnEvent", function()
	if GetNumGossipAvailableQuests() > 0 then
		local arg = { GetGossipAvailableQuests() }
		local i = 1
		while(arg[i]) do
			SelectGossipAvailableQuest(i);
			i = i + 1;
		end
	end
end)


local complete = CreateFrame("Frame")
complete:RegisterEvent("QUEST_COMPLETE")
complete:SetScript("OnEvent", function()
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
end)


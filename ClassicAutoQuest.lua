-- File: ClassicAutoQuest.lua
-- Name: ClassicAutoQuest
-- Author: BobNudd
-- Description: A minimalist auto quest acceptor/hand-in.
-- Version: 1.0.0



local faster = CreateFrame("Frame")
faster:RegisterEvent("QUEST_DETAIL")
faster:SetScript("OnEvent", function()
	 AcceptQuest();
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
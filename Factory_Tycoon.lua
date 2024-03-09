-----------//  LOGIC  \\-----------

local Playerhead = game.Players.LocalPlayer.Character.Head

local gamename = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local PathfindingService = game:GetService("PathfindingService")

local tycoon = nil

local teleportCooldown = 1
local lastTeleportTime = 0


for _,v in pairs(game:GetService("Workspace").Tycoons:GetDescendants()) do
   if v.ClassName == "ObjectValue" and v.Value == game.Players.LocalPlayer then
      tycoon = v.Parent
      print(tycoon)
   end
end
-----------//  GUI  \\-----------

local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local Window = ArrayField:CreateWindow({
    Name = gamename, -- The ScriptName
    LoadingTitle = gamename, -- The loading title for the name. Keep it gamename
    LoadingSubtitle = "by Doran",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "Dorans ScriptHub", -- Create a custom folder for your hub/game
       FileName = gamename
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = false, -- Set this to true to use our key system
    KeySettings = {
       Title = "Doran's ScriptHub",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key", -- It is recommended to use something unique as other scripts using ArrayField may overwrite your key file
       SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like ArrayField to get the key from
       Actions = {
             [1] = {
                 Text = 'Click here to copy the key link <--',
                 OnPress = function()
                     print('Pressed')
                 end,
                 }
             },
       Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
    }
 })

 local Main = Window:CreateTab("Main Features", 4483362458) -- Title, Image


 local Toggle = Main:CreateToggle({
   Name = "Auto Collect",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      getgenv().AutoCollect = Value
      while getgenv().AutoCollect == false do
         wait()
         tycoon.Build.Collect.Part.CFrame = CFrame.new(tycoon.Build.Collect.Union.Position)
         tycoon.Build.Collect.Part.Transparency = 0
      end
      while getgenv().AutoCollect == true do
         wait()
         tycoon.Build.Collect.Part.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
         tycoon.Build.Collect.Part.CanCollide = false
         tycoon.Build.Collect.Part.Transparency = 1
      end
   end,
})



local Toggle = Main:CreateToggle({
   Name = "Auto Build",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      getgenv().autoBuild = Value
      local pfs = game:GetService('PathfindingService')
      local NPC = game.Players.LocalPlayer.Character
      
      local function moveToWaypoint(waypoint)
         local path = pfs:CreatePath()
         path:ComputeAsync(NPC.HumanoidRootPart.Position, waypoint.Position)
      
         for _, point in pairs(path:GetWaypoints()) do
            if getgenv().autoBuild then  -- Check if autoBuild is on
               NPC.Humanoid:MoveTo(point.Position)
               NPC.Humanoid.MoveToFinished:Wait()
            end
         end
      end
      
      if getgenv().autoBuild then  -- Check if autoBuild is on
         local waypoints = {}
         
         -- Get all children under game:GetService("Workspace").Tycoons.Red.Buttons
         local buttonContainer = tycoon.Buttons
         for index, waypoint in pairs(buttonContainer:GetChildren()) do
            table.insert(waypoints, {index = index, waypoint = waypoint})
         end
         
         -- Sort waypoints based on index
         table.sort(waypoints, function(a, b) return a.index < b.index end)
         
         -- Move to each sorted waypoint
         for _, sortedWaypoint in ipairs(waypoints) do
            moveToWaypoint(sortedWaypoint.waypoint)
         end
      end
   end,
})





local function clearOres()
   wait()
   for i,v in pairs(tycoon.Ores:GetChildren()) do
      v.Transparency = 1
   end
end



local Toggle = Main:CreateToggle({
   Name = "Remove Ores",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      getgenv().AutoCollect = Value
      while getgenv().AutoCollect == true do
         wait()
      clearOres()
      end
   end,
})


--[[

if game.CreatorType == Enum.CreatorType.User then
game.Players.LocalPlayer.UserId = game.CreatorId
end
if game.CreatorType == Enum.CreatorType.Group then
game.Players.LocalPlayer.UserId = game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId).Owner.Id
end

]]

--[[
PlayerOptions
   Walkspeed
   Teleport to player
]]--[[
Main
   Auto Buy Buttons
   Auto Rebirth
]]

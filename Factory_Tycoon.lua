
--[[



 _   .-')      ('-.     _ .-') _     ('-.        .-. .-')                     _ .-') _               _  .-')     ('-.         .-') _  
( '.( OO )_   ( OO ).-.( (  OO) )  _(  OO)       \  ( OO )                   ( (  OO) )             ( \( -O )   ( OO ).-.    ( OO ) ) 
 ,--.   ,--.) / . --. / \     .'_ (,------.       ;-----.\  ,--.   ,--.       \     .'_  .-'),-----. ,------.   / . --. /,--./ ,--,'  
 |   `.'   |  | \-.  \  ,`'--..._) |  .---'       | .-.  |   \  `.'  /        ,`'--..._)( OO'  .-.  '|   /`. '  | \-.  \ |   \ |  |\  
 |         |.-'-'  |  | |  |  \  ' |  |           | '-' /_).-')     /         |  |  \  '/   |  | |  ||  /  | |.-'-'  |  ||    \|  | ) 
 |  |'.'|  | \| |_.'  | |  |   ' |(|  '--.        | .-. `.(OO  \   /          |  |   ' |\_) |  |\|  ||  |_.' | \| |_.'  ||  .     |/  
 |  |   |  |  |  .-.  | |  |   / : |  .--'        | |  \  ||   /  /\_         |  |   / :  \ |  | |  ||  .  '.'  |  .-.  ||  |\    |   
 |  |   |  |  |  | |  | |  '--'  / |  `---.       | '--'  /`-./  /.__)        |  '--'  /   `'  '-'  '|  |\  \   |  | |  ||  | \   |   
 `--'   `--'  `--' `--' `-------'  `------'       `------'   `--'             `-------'      `-----' `--' '--'  `--' `--'`--'  `--'   

]]








-----------//  LOGIC  \\-----------
local gamename = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local PathfindingService = game:GetService("PathfindingService")

local tycoon = nil

for _,v in pairs(game:GetService("Workspace").Tycoons:GetDescendants()) do
   if v.ClassName == "ObjectValue" and v.Value == game.Players.LocalPlayer then
      tycoon = v.Parent
      print(tycoon)
   end
end


-----------//  GUI  \\-----------

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
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
   local Info  = Window:CreateTab("Information", 4483362458)
   local Label = Info:CreateLabel("Auto build uses an new type of function, Pathfinding. I have never used this before and this is the first script to have it")
   local Label = Info:CreateLabel("Auto Collect is Fairly simple. Auto collects for you. Teleports the collector to you, if you disable it teleports back")
   local Label = Info:CreateLabel("Remove Ore Cant fully delete them locally cuz for some reason you wont get money no more")
  -- local Paragraph = Info:CreateParagraph({Title = "Auto Build", Content = "Auto build uses an new type of function, Pathfinding. I have never used this before and this is the first script to have it"})
  -- local Paragraph = Info:CreateParagraph({Title = "Auto Collect", Content = "Fairly simple. Auto collects for you. Teleports the collector to you, if you disable it teleports back"})
   --local Paragraph = Info:CreateParagraph({Title = "Remove Ores", Content = "Cant fully delete them locally cuz for some reason you wont get money no more"})
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
      local pathMarkers = {}  -- Table to store path marker parts

      local function createPathMarkers(waypoints)
         for _, point in pairs(waypoints) do
            local sphere = Instance.new("Part")
            sphere.Shape = Enum.PartType.Ball
            sphere.Material = Enum.Material.Neon
            sphere.Transparency = 0.6
            sphere.Color = Color3.fromRGB(255, 0, 0)
            sphere.Size = Vector3.new(1, 1, 1)
            sphere.Position = point.Position
            sphere.Anchored = true
            sphere.CanCollide = false
            sphere.Parent = game.Workspace  -- Adjust the parent as needed

            table.insert(pathMarkers, sphere)
         end
      end

      local function removePathMarkers()
         for _, marker in pairs(pathMarkers) do
            marker:Destroy()
         end
         pathMarkers = {}  -- Clear the path markers table
      end

      local function moveToWaypoint(waypoint, requiredMoney)
         local path = pfs:CreatePath()
         path:ComputeAsync(NPC.HumanoidRootPart.Position, waypoint.Position)
         local waypoints = path:GetWaypoints()

         createPathMarkers(waypoints)  -- Create path markers

         for _, point in pairs(waypoints) do
            if getgenv().autoBuild then  -- Check if autoBuild is on
               NPC.Humanoid:MoveTo(point.Position)
               NPC.Humanoid.MoveToFinished:Wait()
            end
         end

         removePathMarkers()  -- Remove path markers when done

         -- Check if the player has enough money for the button
         local priceValue = waypoint:FindFirstChild("Price")
         if priceValue and priceValue:IsA("IntValue") then
            local playerMoney = game.Players.LocalPlayer.leaderstats.Money.Value
            if playerMoney < priceValue.Value then
               -- Not enough money, inform the collectMoney function
               collectMoney(priceValue.Value - playerMoney)
            end
         end
      end

      local function jumpUpDown()
         local isJumping = false

         while getgenv().autoBuild and not NPC:FindFirstChild("Humanoid").Jump do
            if isJumping then
               NPC.Humanoid:Move(Vector3.new(0, -5, 0))
            else
               NPC.Humanoid:Move(Vector3.new(0, 5, 0))
            end
            isJumping = not isJumping
            wait(0.1)
         end
      end

      local function collectMoney(amt)
         repeat
            wait(5)
            -- Check if the player has enough money, if not, jump up and down
            if game.Players.LocalPlayer.leaderstats.Money.Value < amt then
               jumpUpDown()
            end
         until game.Players.LocalPlayer.leaderstats.Money.Value >= amt
      end

      if getgenv().autoBuild then
         local waypoints = {}

         -- Get all children under game:GetService("Workspace").Tycoons.Red.Buttons
         local buttonContainer = tycoon.Buttons
         for _, model in pairs(buttonContainer:GetChildren()) do
            if model:IsA("Model") then
               local isButtonVisible = model:FindFirstChild("IsButtonVisible")
               if isButtonVisible and isButtonVisible:IsA("BoolValue") and isButtonVisible.Value then
                  local boughtValue = model:FindFirstChild("Bought")
                  if boughtValue and boughtValue:IsA("BoolValue") and not boughtValue.Value then
                     for _, part in pairs(model:GetDescendants()) do
                        if part.ClassName == "Model" and part.Name == "Button" then
                           for _, walkToPart in pairs(part:GetChildren()) do
                              if walkToPart.Name == "Part" then
                                 table.insert(waypoints, walkToPart)
                              end
                           end
                        end
                     end
                  end
               end
            end
         end

         -- Move to each waypoint and wait until the build is completed
         for _, waypoint in ipairs(waypoints) do
            moveToWaypoint(waypoint, 1000)  -- Pass a default value for required money
            repeat wait() until (NPC.HumanoidRootPart.Position - waypoint.Position).Magnitude < 3 -- Adjust the threshold distance as needed
            print("Moving to the next waypoint.")
            wait(2)  -- Adjust the wait time before moving to the next waypoint
         end
      end
   end,
})





-- Assuming Main is already defined

local function disableConveyors()
   for i = 1, 7 do
      wait()
      local conveyorName = "Conveyor" .. i
      local conveyorModel = tycoon.Buttons[conveyorName].Model

      -- Find each part named "Conveyor" within the model
      local conveyorPart1 = conveyorModel:FindFirstChild("Conveyor")
      local conveyorPart2 = conveyorModel:FindFirstChild("Conveyor")

      if conveyorPart1 and conveyorPart2 then
         print("Disabling", conveyorName)

         -- Disable or hide the parts as needed
        -- conveyorPart1.Transparency = 1
        -- conveyorPart2.Transparency = 1
         
         -- Alternatively, you can make the parts CanCollide false
          conveyorPart1.CanCollide = false
          conveyorPart2.CanCollide = false
         
         -- You may also adjust other properties based on your game's requirements
      else
         print("Conveyor parts not found:", conveyorName)
      end
   end
end

local Toggle = Main:CreateButton({
   Name = "Disable Conveyors",
   CurrentValue = false,
   Flag = "Button1",
   Callback = function()
      disableConveyors()
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






-- loadstring(game:HttpGet(('https://raw.githubusercontent.com/Doran342545345/Dorans-Test-SCripts/main/Factory_Tycoon.lua'),true))()

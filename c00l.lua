-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the UI Window
local Window = Rayfield:CreateWindow({
   Name = "Unanchor and Fly Parts Script",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "by Grok",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "UnanchorFly"
   }
})

-- Create a Tab
local Tab = Window:CreateTab("Main", nil)

-- Function to unanchor all parts
local function UnanchorAllParts()
   for _, descendant in ipairs(workspace:GetDescendants()) do
      if descendant:IsA("BasePart") and descendant.Anchored then
         descendant.Anchored = false
      end
   end
   Rayfield:Notify({
      Title = "Success",
      Content = "All parts have been unanchored.",
      Duration = 5,
      Image = nil
   })
end

-- Table to store unanchored parts for flying
local unanchoredParts = {}

-- Function to collect unanchored parts
local function CollectUnanchoredParts()
   unanchoredParts = {}
   for _, descendant in ipairs(workspace:GetDescendants()) do
      if descendant:IsA("BasePart") and not descendant.Anchored then
         table.insert(unanchoredParts, descendant)
      end
   end
   return #unanchoredParts
end

-- Function to make parts fly around the player
local function MakePartsFlyAroundPlayer()
   local player = game.Players.LocalPlayer
   local character = player.Character
   if not character or not character:FindFirstChild("HumanoidRootPart") then
      Rayfield:Notify({
         Title = "Error",
         Content = "Player character not found.",
         Duration = 5,
         Image = nil
      })
      return
   end
   
   local rootPart = character.HumanoidRootPart
   local numParts = CollectUnanchoredParts()
   
   if numParts == 0 then
      Rayfield:Notify({
         Title = "No Parts",
         Content = "No unanchored parts found.",
         Duration = 5,
         Image = nil
      })
      return
   end
   
   Rayfield:Notify({
      Title = "Flying Started",
      Content = numParts .. " parts are now flying around you.",
      Duration = 5,
      Image = nil
   })
   
   -- Spawn a thread to handle flying
   spawn(function()
      while true do
         for _, part in ipairs(unanchoredParts) do
            if part and part.Parent then
               -- Counter gravity with BodyForce if not already present
               if not part:FindFirstChild("AntiGravity") then
                  local bodyForce = Instance.new("BodyForce")
                  bodyForce.Name = "AntiGravity"
                  bodyForce.Force = Vector3.new(0, part:GetMass() * workspace.Gravity, 0)
                  bodyForce.Parent = part
               end
               
               -- Calculate direction towards player with random orbit offset
               local offset = Vector3.new(math.random(-10, 10), math.random(5, 15), math.random(-10, 10))
               local targetPosition = rootPart.Position + offset
               local direction = (targetPosition - part.Position).unit
               
               -- Apply velocity to move towards the target
               if not part:FindFirstChild("FlyVelocity") then
                  local bodyVelocity = Instance.new("BodyVelocity")
                  bodyVelocity.Name = "FlyVelocity"
                  bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                  bodyVelocity.Parent = part
               end
               part.FlyVelocity.Velocity = direction * 50  -- Adjust speed here
            end
         end
         wait(0.1)  -- Update every 0.1 seconds
      end
   end)
end

-- Create Button for Unanchoring
Tab:CreateButton({
   Name = "Unanchor All Parts",
   Callback = UnanchorAllParts
})

-- Create Button for Flying
Tab:CreateButton({
   Name = "Make Unanchored Parts Fly Around Me",
   Callback = MakePartsFlyAroundPlayer
})

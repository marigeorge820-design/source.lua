-- [[ MARI SCRIPT V4.7 | STABLE 2026 ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Mari Script V4.7", "BloodTheme")

local Main = Window:NewTab("Main Cheats")
local Visuals = Window:NewTab("Visuals")
local Section = Main:NewSection("Cheats")
local EspSection = Visuals:NewSection("ESP")

local Stealing = false
local Desyncing = false
local ClickTPEnabled = false
local Mouse = game.Players.LocalPlayer:GetMouse()

-- INDICATORS
local IndicatorGui = Instance.new("ScreenGui", game.CoreGui)
local function CreateLabel(text, pos, color, align)
    local lbl = Instance.new("TextLabel", IndicatorGui)
    lbl.Size = UDim2.new(0, 250, 0, 50)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.Font = Enum.Font.LuckiestGuy
    lbl.TextSize = 26
    lbl.TextXAlignment = align
    lbl.Visible = false
    return lbl
end

local StealLabel = CreateLabel("AUTO STEAL: ACTIVE", UDim2.new(0, 20, 0, 20), Color3.fromRGB(0, 255, 127), Enum.TextXAlignment.Left)
local DesyncLabel = CreateLabel("DESYNC: ACTIVE", UDim2.new(1, -270, 0, 20), Color3.fromRGB(0, 191, 255), Enum.TextXAlignment.Right)

-- AUTO STEAL
Section:NewToggle("Auto Steal (Range 25)", "Steal nearby items", function(state)
    Stealing = state
    StealLabel.Visible = state
    task.spawn(function()
        while Stealing do
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(workspace:GetDescendants()) do
                    if (v:IsA("ClickDetector") or v:IsA("ProximityPrompt")) then
                        if (char.HumanoidRootPart.Position - v.Parent.Position).Magnitude < 25 then
                            if v:IsA("ClickDetector") then fireclickdetector(v) else fireproximityprompt(v) end
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end)
end)

-- DESYNC
Section:NewToggle("Desync (Ghost Mode)", "Protects your hitbox", function(state)
    Desyncing = state
    DesyncLabel.Visible = state
    game:GetService("RunService").Heartbeat:Connect(function()
        if Desyncing then
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            local oldV = hrp.Velocity
            hrp.Velocity = Vector3.new(1, 1, 1) * (2^16)
            game:GetService("RunService").RenderStepped:Wait()
            hrp.Velocity = oldV
        end
    end)
end)

-- CLICK TP
Section:NewToggle("Ctrl+Click TP", "Teleport to mouse", function(state)
    ClickTPEnabled = state
end)

Mouse.Button1Down:Connect(function()
    if ClickTPEnabled and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0, 3, 0))
    end
end)

-- ESP
EspSection:NewButton("Highlight Rares", "Show Strawberry Elephant", function()
    for _, item in pairs(workspace:GetDescendants()) do
        if item.Name:find("Strawberry") or item.Name:find("Elephant") then
            local hl = Instance.new("Highlight", item)
            hl.FillColor = Color3.fromRGB(255, 0, 100)
        end
    end
end)

Library:Notify("Mari Script V4.7 Ready!")

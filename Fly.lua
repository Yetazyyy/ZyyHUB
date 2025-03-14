-- Variables
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local flyButton = script.Parent -- The button that toggles flying
local flying = false
local bodyGyro, bodyVelocity
local speed = 50 -- Adjust the speed of flying
local flyingHeight = 10 -- Height while flying

-- Create watermark label with name "ZyyHUB"
local watermark = Instance.new("TextLabel")
watermark.Text = "ZyyHUB"
watermark.Size = UDim2.new(0, 200, 0, 50)
watermark.Position = UDim2.new(0, 10, 0, 10)
watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
watermark.BackgroundTransparency = 1
watermark.TextSize = 24
watermark.Font = Enum.Font.GothamBold
watermark.Parent = player.PlayerGui:WaitForChild("ScreenGui")

-- Function to toggle fly mode
local function toggleFly()
    if flying then
        -- Stop flying
        flying = false
        if bodyGyro then
            bodyGyro:Destroy()
            bodyVelocity:Destroy()
        end
    else
        -- Start flying
        flying = true
        bodyGyro = Instance.new("BodyGyro")
        bodyVelocity = Instance.new("BodyVelocity")
        
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)  -- Maximum torque to maintain orientation
        bodyGyro.CFrame = character.HumanoidRootPart.CFrame
        bodyGyro.Parent = character.HumanoidRootPart

        bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000) -- Maximum force to apply velocity
        bodyVelocity.Velocity = Vector3.new(0, speed, 0)  -- Add initial upwards force
        bodyVelocity.Parent = character.HumanoidRootPart
        
        -- Maintain flying while the button is toggled
        game:GetService("RunService").Heartbeat:Connect(function()
            if flying then
                bodyVelocity.Velocity = Vector3.new(mouse.Hit.p.X - character.HumanoidRootPart.Position.X,
                                                     0,
                                                     mouse.Hit.p.Z - character.HumanoidRootPart.Position.Z)
                -- Keep the player at the flying height
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, flyingHeight, 0)
            end
        end)
    end
end

-- Button click event
flyButton.MouseButton1Click:Connect(function()
    toggleFly()
    -- Change button text based on fly status
    if flying then
        flyButton.Text = "Fly: ON"
    else
        flyButton.Text = "Fly: OFF"
    end
end)

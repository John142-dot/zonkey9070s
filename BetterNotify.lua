-- some things done and made by @zonkey9070 on yt
-- superthanks for lunarui on scriptblox.com for original (btbhax)
-- BetterNotify UiLibrary
local NotificationLibrary = {}

local TEXT_COLOR = Color3.new(1, 1, 1)
local BACKGROUND_COLOR_START = Color3.fromRGB(30, 30, 60)
local BACKGROUND_COLOR_END = Color3.fromRGB(60, 60, 90)
local GUI_SIZE = UDim2.new(0, 300, 0, 100)

function NotificationLibrary:ShowNotification(message, soundUrl, imageUrl, customDuration, callbackUrl)
    local sound = Instance.new("Sound")
    sound.SoundId = soundUrl
    sound.Volume = 1
    sound.Parent = game:GetService("SoundService")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotificationGui"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Size = GUI_SIZE
    frame.Position = UDim2.new(0.5, -150, 0.8, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0.1, 0)
    uiCorner.Parent = frame

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, BACKGROUND_COLOR_START),
        ColorSequenceKeypoint.new(1, BACKGROUND_COLOR_END)
    }
    gradient.Parent = frame

    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Name = "NotificationImage"
    imageLabel.Size = UDim2.new(0, 50, 0, 50)
    imageLabel.Position = UDim2.new(0, 10, 0, 25)
    imageLabel.Image = imageUrl
    imageLabel.BackgroundTransparency = 1
    imageLabel.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "NotificationText"
    textLabel.Size = UDim2.new(1, -60, 1, 0)
    textLabel.Position = UDim2.new(0, 60, 0, 0)
    textLabel.TextSize = 18
    textLabel.TextColor3 = TEXT_COLOR
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextWrapped = true
    textLabel.Text = message
    textLabel.Parent = frame

    local dragging = false
    local dragInput
    local startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset + delta.X, frame.Position.Y.Scale, frame.Position.Y.Offset + delta.Y)
            startPos = input.Position
        end
    end)

    screenGui.Parent = game:GetService("CoreGui")

    frame:TweenPosition(UDim2.new(0.5, -150, 0.5, -50), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)

    sound:Play()

    wait(customDuration or 5)

    for i = 0, 1, 0.1 do
        frame.BackgroundTransparency = i
        textLabel.TextTransparency = i
        imageLabel.ImageTransparency = i
        wait(0.1)
    end

    screenGui:Destroy()
    sound:Destroy()

    if callbackUrl then
        local HttpService = game:GetService("HttpService")
        local success, response = pcall(function()
            return HttpService:GetAsync(callbackUrl)
        end)

        if success then
            print("Successfully executed URL:", response)
        else
            warn("Failed to execute URL:", response)
        end
    end
end

return NotificationLibrary

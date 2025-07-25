-- Vuelo para móvil con botón táctil, velocidad ajustable, arrastrable y rotación 360°
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local fly = false
local speed = 50
local bv, bg

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui", game.CoreGui or plr:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

-- Crear botón principal
local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0, 120, 0, 50)
btn.Position = UDim2.new(0.5, -60, 0.8, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Text = "✈️ Volar"
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.ZIndex = 9999
btn.Active = true
btn.Draggable = true

-- Botón de +
local plusBtn = Instance.new("TextButton", screenGui)
plusBtn.Size = UDim2.new(0, 50, 0, 50)
plusBtn.Position = UDim2.new(0.5, 65, 0.8, 0)
plusBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
plusBtn.Text = "+"
plusBtn.TextScaled = true
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextColor3 = Color3.new(1, 1, 1)
plusBtn.ZIndex = 9999

-- Botón de -
local minusBtn = Instance.new("TextButton", screenGui)
minusBtn.Size = UDim2.new(0, 50, 0, 50)
minusBtn.Position = UDim2.new(0.5, -115, 0.8, 0)
minusBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
minusBtn.Text = "-"
minusBtn.TextScaled = true
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextColor3 = Color3.new(1, 1, 1)
minusBtn.ZIndex = 9999

function startFlying()
    bv = Instance.new("BodyVelocity", hrp)
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    bg = Instance.new("BodyGyro", hrp)
    bg.CFrame = hrp.CFrame
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.P = 1e4

    fly = true
    btn.Text = "🛑 Detener"

    RS.RenderStepped:Connect(function()
        if not fly then return end
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += cam.CFrame.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            dir -= cam.CFrame.UpVector
        end

        if dir.Magnitude > 0 then
            bv.Velocity = dir.Unit * speed
        else
            bv.Velocity = Vector3.zero
        end

        -- Aquí aplicamos rotación 360º mirando siempre hacia la cámara
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
    end)
end

function stopFlying()
    fly = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    btn.Text = "✈️ Volar"
end

-- Botón principal de vuelo
btn.MouseButton1Click:Connect(function()
    if fly then
        stopFlying()
    else
        startFlying()
    end
end)

-- Botón de aumentar velocidad
plusBtn.MouseButton1Click:Connect(function()
    speed = speed + 10
    btn.Text = "✈️ Vel: " .. tostring(speed)
end)

-- Botón de disminuir velocidad
minusBtn.MouseButton1Click:Connect(function()
    speed = math.max(10, speed - 10)
    btn.Text = "✈️ Vel: " .. tostring(speed)
end)

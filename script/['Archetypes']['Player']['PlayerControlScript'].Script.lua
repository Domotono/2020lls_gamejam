-- 获取本地玩家
local player = localPlayer
local Camera = localPlayer.Local.Independent.GameCamera

--声明变量
local isDead = false
local forwardDir = Vector3.Forward
local rightDir = Vector3.Right
local finalDir = Vector3.Zero
local horizontal = 0
local vertical = 0
--local energy = player.Local.ControlGUI.energytank.energyvalue.Value
--local tanksize = player.Local.ControlGUI.energytank.energy


-- 摄像机看向自己
world.CurrentCamera = player.Local.Independent.GameCamera
local camera = world.CurrentCamera
local mode = Camera.CameraMode
camera.LookAt = player

-- 手机端交互UI
local gui = player.Local.ControlGUI
local joystick = gui.Joystick
local touchScreen = gui.TouchFigure
local jumpButton = gui.JumpButton

-- PC端交互按键
local FORWARD_KEY = Enum.KeyCode.W
local BACK_KEY = Enum.KeyCode.S
local LEFT_KEY = Enum.KeyCode.A
local RIGHT_KEY = Enum.KeyCode.D
local JUMP_KEY = Enum.KeyCode.Space
local Crouch_KEY = Enum.KeyCode.LeftControl--下蹲按键
local Small_KEY = Enum.KeyCode.X	--变小按键

-- 键盘的输入值
local moveForwardAxis = 0
local moveBackAxis = 0
local moveLeftAxis = 0
local moveRightAxis = 0

-- 移动方向是否遵循摄像机方向
function IsFreeMode()
	return (mode == Enum.CameraMode.Social and camera.Distance >= 0) or mode == Enum.CameraMode.Orbital 
		or mode == Enum.CameraMode.Custom
end

--获取按键盘时的移动方向最终取值
function GetKeyValue()
	moveForwardAxis = Input.GetPressKeyData(FORWARD_KEY) > 0 and 1 or 0
	moveBackAxis = Input.GetPressKeyData(BACK_KEY) > 0 and -1 or 0
	moveLeftAxis = Input.GetPressKeyData(LEFT_KEY) > 0 and 1 or 0
	moveRightAxis = Input.GetPressKeyData(RIGHT_KEY) > 0 and -1 or 0
	if player.State == Enum.CharacterState.Died then
		moveForwardAxis, moveBackAxis, moveLeftAxis, moveRightAxis = 0, 0, 0, 0
	end
end

-- 获取移动方向
function GetMoveDir()
	forwardDir = IsFreeMode() and camera.Forward or player.Forward 
	forwardDir.y = 0
	rightDir = Vector3(0, 1, 0):Cross(forwardDir)
	horizontal = joystick.Horizontal
	vertical = joystick.Vertical
	if horizontal ~= 0 or vertical ~= 0 then
		finalDir = rightDir * horizontal + forwardDir * vertical
	else
		GetKeyValue()
		finalDir = forwardDir * (moveForwardAxis + moveBackAxis) - rightDir * (moveLeftAxis + moveRightAxis)
	end
end

-- 移动逻辑
function PlayerMove(dir)
	dir.y = 0
	if player.State == Enum.CharacterState.Died then
		dir = Vector3.Zero
	end
	if dir.Magnitude > 0 then
		if IsFreeMode() then
			player:FaceToDir(dir, 4 * math.pi)
		end
		player:MoveTowards(Vector2(dir.x, dir.z).Normalized)
	else
		player:MoveTowards(Vector2.Zero)
	end
end

-- 跳跃逻辑
function PlayerJump()
	if (player.IsOnGround or player.State == Enum.CharacterState.Seated) and not isDead then
		player:Jump()
		return
	end	
end
jumpButton.OnDown:Connect(PlayerJump)
Input.OnKeyDown:Connect(function()
	if Input.GetPressKeyData(JUMP_KEY) == 1 then
		PlayerJump()
	end
end)

-- 死亡逻辑
function PlayerDie()
	isDead = true
	wait(player.RespawnTime)
	player:Reset()
	isDead = false
end
player.OnDead:Connect(PlayerDie)

-- 生命值检测
function HealthCheck(oldHealth, newHealth)
	if newHealth <= 0 then
		player:Die()
	end
end
player.OnHealthChange:Connect(HealthCheck)

-- 每个渲染帧处理操控逻辑
function MainControl()
	camera = world.CurrentCamera
	mode = camera.CameraMode
	GetMoveDir()
	PlayerMove(finalDir)
end
world.OnRenderStepped:Connect(MainControl)

-- 检测触屏的手指数
local touchNumber = 0
function countTouch(container)
	touchNumber = #container
end
touchScreen.OnTouched:Connect(countTouch)

-- 滑屏转向
function cameraMove(pos, dis, deltapos, speed)
	if touchNumber == 1 then
		if IsFreeMode() then
			camera:CameraMove(mode == Enum.CameraMode.Orbital and Vector2(deltapos.x, 0) or deltapos)
		else 
			player:RotateAround(player.Position, Vector3.Up, deltapos.x)
			camera:CameraMove(Vector2(0, deltapos.y))
		end
	end
end
touchScreen.OnPanStay:Connect(cameraMove)

-- 双指缩放摄像机距离
function cameraZoom(pos1, pos2, dis, speed)
	if mode == Enum.CameraMode.Social then
		camera.Distance = camera.Distance - dis / 50
	end
end
touchScreen.OnPinchStay:Connect(cameraZoom)
-- 下蹲
function PlayerCrouch()
	if localPlayer:IsCrouch() then
	     localPlayer:EndCrouch()
		 localPlayer.WalkSpeed = 6
	else
	    localPlayer:StartCrouch()
		localPlayer.WalkSpeed = 3
	return
	end
end
--crouchButton.OnDown:Connect(PlayerCrouch)
Input.OnKeyDown:Connect(function()
	if Input.GetPressKeyData(Crouch_KEY) == 1 then
		PlayerCrouch()
	end
end)

--变小逻辑
function besamll()
  localPlayer.CharacterWidth = 0.1
  localPlayer.CharacterHeight = 0.15
  localPlayer.Avatar.HeadSize = 0.15
  localPlayer.Avatar.Width = 1.2
  localPlayer.Avatar.Height = 0.1
  localPlayer.WalkSpeed = 1.4
  localPlayer.JumpUpVelocity = 8
  Camera.Offset=Vector3(0,0.15,0)
  Camera.Distance = 1
  localPlayer.NameGUI:SetActive(false)
end
function recover()
  localPlayer.CharacterWidth = 1
  localPlayer.CharacterHeight = 1.7
  localPlayer.Avatar.HeadSize = 1
  localPlayer.Avatar.Width = 1
  localPlayer.Avatar.Height = 1
  localPlayer.WalkSpeed = 6
  localPlayer.JumpUpVelocity = 9.8
  Camera.Offset=Vector3(0,1.5,0)
  Camera.Distance = 3
  localPlayer.NameGUI:SetActive(true)
end
Input.OnKeyDown:Connect(function()
	if Input.GetPressKeyData(Small_KEY) == 1 and not isDead  
	then
		if world.AbilityValue4.Value >= 40
		then 
		
			world.AbilityValue4.Value = world.AbilityValue4.Value - 40
			--print(energy)
			--tanksize.Size = Vector2(energy*4,80)
			besamll()	--变小
			wait(15)
			recover()	--恢复原状
			
		else
			print("4能量不足！！！")  --主要是为了打印这个
		end
	end
end)
-- 外挂满能量
Input.OnKeyDown:Connect(function()
     if Input.GetPressKeyData(Enum.KeyCode.M) == 1 and not isDead
	then
        world.AbilityValue1.Value = 1000
		print("获得能量一1000点")	
		world.AbilityValue2.Value = 1000
		print("获得能量二1000点")	
		world.AbilityValue3.Value = 1000
		print("获得能量三1000点")	
		world.AbilityValue4.Value = 1000
	    print("获得能量四1000点")	
	end
end)
--复制的能量相关逻辑
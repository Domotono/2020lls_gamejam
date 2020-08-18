local moveBoard = script.Parent
local Front = moveBoard.Parent.Front
local back = moveBoard.Parent.back
-- 得到速度
local speed = 0.05
local vector = Vector3(-1, 0 ,0)

function Collision(Obj)
	--print("!")
	-- 如果正方向，到达边界，则往反方向走
	-- 如果反方向，到达边界，则也往反方向走
	if Obj.Name == 'Front' then
		--print("-")
		vector = Vector3.Zero
		wait(0)
		vector = (back.Position - Obj.Position).UnsafeNormalized
	elseif Obj.Name == 'back' then
		--print("+")
		vector = Vector3.Zero
		wait(0)
		vector = (Front.Position - Obj.Position).UnsafeNormalized
	end
end
moveBoard.OnCollisionBegin:Connect(Collision)
world.OnRenderStepped:Connect(function()moveBoard.Position = moveBoard.Position + vector * speed end)

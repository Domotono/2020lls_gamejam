local NPC = script.Parent
--------------------------------------参数
local height = 1.2
local length = 8
local stayTime = 5
local canSee  = false
local mul = 1.3
--------------------------------------射线检测
local ray= Ray(NPC.Position + Vector3.Up*height, NPC.Forward)
local End = ray:GetPoint(length)
local oriVec = End -( NPC.Position + Vector3.Up*height )
local P = NPC.Position
local R = NPC.Rotation
local inSight = false ---是否被抓到的flag
local isOnColl = false ---是否碰撞
local m = 1
local w = NPC.WalkSpeed
function Update()
	if NPC.NPCState.Value == 0 then
		return
	end
	NPC:MoveTowards(Vector2.Zero)
	End = ray:GetPoint(length*m)
	NPC.WalkSpeed = w*m
	oriVec = End -( NPC.Position + Vector3.Up*height )
	--构造射线
	
	ray= Ray(NPC.Position + Vector3.Up*height, NPC.Forward)
	
	res = {Physics:Raycast(NPC.Position + Vector3.Up*height , getEndPosition(0) , canSee),
	 Physics:Raycast(NPC.Position + Vector3.Up*height , getEndPosition(-10) , canSee),
	 Physics:Raycast(NPC.Position + Vector3.Up*height , getEndPosition(-20) , canSee),
	 Physics:Raycast(NPC.Position + Vector3.Up*height , getEndPosition(-25) , canSee),
	 Physics:Raycast(NPC.Position + Vector3.Up*height , getEndPosition(10) , canSee),
	 Physics:Raycast(NPC.Position + Vector3.Up*height , getEndPosition(20) , canSee),
	 Physics:Raycast(NPC.Position + Vector3.Up*height , getEndPosition(25) , canSee)}
	  --[[
	 for _,v in pairs(res) do
		if ( v:HasHit() and v:GetHitObj() == localPlayer ) 
		then
			NPC.InSight.Value = true
			--print("嗨，老兄弟，你被观察到了（翻译腔）")
			NPC.NPCState.Value = 2
			NPC.GoPoint.Value = v:GetHitPos()
			m = 1.3
			break
		else
			NPC.InSight.Value = false
			m = 1
		end 
		
	 end
	 
	 
	 for _,v in pairs(res) do
		if ( v:HasHit()  and NPC.InSight.Value = false 
			and v:GetHitObj()~= localPlayer and v:GetHitObj().IsStatic == true) 
		then
			if IsSusp(v:GetHitObj()) == true then
			then 
				print("发现悬浮物体")
				NPC.NPCState.Value = 2
				NPC.GoPoint.Value = v:GetHitPos()
			break
			end
		else
			NPC.InSight.Value = false
		end 
		
	 end]]
	 
	
	--人的条件判断
	if ( res[1]:HasHit() and res[1]:GetHitObj() == localPlayer ) 
	then
		NPC.InSight.Value = true
		--print("嗨，老兄弟，你被观察到了（翻译腔）")
		NPC.NPCState.Value = 2
		NPC.GoPoint.Value = res[1]:GetHitPos()
		m = 1.3
		
	elseif( res[2]:HasHit() and res[2]:GetHitObj() == localPlayer ) 
	then
		NPC.InSight.Value = true
		--print("嗨，老兄弟，你被观察到了（翻译腔）")
		NPC.NPCState.Value = 2
		NPC.GoPoint.Value = res[2]:GetHitPos()
		m = 1.3
		
	elseif( res[3]:HasHit() and res[3]:GetHitObj() == localPlayer ) 
	then
		NPC.InSight.Value = true
		--print("嗨，老兄弟，你被观察到了（翻译腔）")
		NPC.NPCState.Value = 2
		NPC.GoPoint.Value = res[3]:GetHitPos()
		m = 1.3
		
	elseif( res[4]:HasHit() and res[4]:GetHitObj() == localPlayer ) 
	then
		NPC.InSight.Value = true
		--print("嗨，老兄弟，你被观察到了（翻译腔）")
		NPC.NPCState.Value = 2
		NPC.GoPoint.Value = res[4]:GetHitPos()
		m = 1.3
	elseif( res[5]:HasHit() and res[5]:GetHitObj() == localPlayer ) 
	then
		NPC.InSight.Value = true
		--print("嗨，老兄弟，你被观察到了（翻译腔）")
		NPC.NPCState.Value = 2
		NPC.GoPoint.Value = res[5]:GetHitPos()
		m = 1.3
		
	elseif( res[6]:HasHit() and res[6]:GetHitObj() == localPlayer ) 
	then
		NPC.InSight.Value = true
		--print("嗨，老兄弟，你被观察到了（翻译腔）")
		NPC.NPCState.Value = 2
		NPC.GoPoint.Value = res[6]:GetHitPos()
		m = 1.3
		
	elseif( res[7]:HasHit() and res[7]:GetHitObj() == localPlayer ) 
	then
		NPC.InSight.Value = true
		--print("嗨，老兄弟，你被观察到了（翻译腔）")
		NPC.NPCState.Value = 2
		NPC.GoPoint.Value = res[7]:GetHitPos()
		m = 1.3
	else
		NPC.InSight.Value = false
		m = 1
	end
	
end

world.OnRenderStepped:Connect(Update)

script.OnDestroyed:Connect(function()
	world.OnRenderStepped:Disconnect(Update)
end)


function getEndPosition(angle)
	
	--angle = script.Parent.Angle.Value
	---print(angle)
	--vec = oriVec[i]
	--print(vec)
	--向量绕Y轴旋转
	if angle ~= 0 then
		newVec = oriVec:Rotate(Vector3(0,1,0),angle)
	else
		newVec = oriVec
	end
	
	
	--newVec = oriVec[i]:Rotate(Vector3(0,1,0),angle)

	End = newVec +  NPC.Position + Vector3.Up*height
	
	return End
	
end
function IsSusp(Obj)
	local i = Obj.Positon
	wait(1)
	local j = Obj.Positon
	
	if Obj ~= localPlayer and Obj.IsStatic == true and (i-j).Magnitude >0.1
	then
		return true
	else
		return false
	end
	
	
end



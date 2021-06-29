--[[
	CameraControler
	By InstantStudio
]]--
local CameraControler = {}
local CameraEvents = {
	FinishedLoop = script.CameraFinishedLoop,
	Changed = script.CameraChanged,
	Disable = script.Disable
}
local TweenService = game:GetService("TweenService")
local CurrentCamera = workspace.CurrentCamera

--@CameraControler:CreateLoop
--#Creates a loop Object
--&CFrameLocation(A Location Created by CameraControler:CreateCFrameLocation)
--%Returns: CameraControlerLoopList
function CameraControler:CreateLoop(CFrameLocation)
	local CameraControlerLoopList = {}
	for i, v in pairs(CFrameLocation) do
		local Table = {
			['Location'] = v['Location'],
			['Number'] = v['Number'],
			['TweenStyle'] = v['TweenStyle']
		}
		table.insert(CameraControlerLoopList, v[1], Table)
	end
	return CameraControlerLoopList
end

--@CameraControler:CreateCFrameLocation
--#Creates a CFrameLocation Object
--&CFrameValue(CFrame), Number(Id in list *Optional), TweenStyle(TweenInfo *Optional)
--%Returns: CFrameLocation
function CameraControler:CreateCFrameLocation(CFrameValue, Number, TweenStyle)
	local Issues = {false, 'Cannot Create CFrameLocation'}
	if CFrameValue ~= CFrame then
		Issues[1] = true
		Issues[2] = Issues[2] .. '; CFrameValue is not a CFrame'
	end
	if type(Number) ~= 'number' then
		Issues[2] = Issues[2] .. '; CFrameValue is not a CFrame'
	end
	if TweenStyle ~= TweenInfo then
		Issues[2] = Issues[2] .. '; CFrameValue is not a CFrame'
		TweenStyle = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
	end
	if Issues[1] == false then
		return {
			['Number'] = Number,
			['Location'] = CFrameValue,
			['TweenStyle'] = TweenStyle
		}
	else
		return error(Issues[2])
	end
end

--@CameraControler.SetCameraLocation
--#Sets the camerea location using a CFrameLocation
--&CFrameLocation(Created from CameraControler:CreateCFrameLocation)
--%Returns: RBXScriptSignal
function CameraControler.SetCameraLocation(CFrameLocation)
	if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
		spawn(function()
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			CurrentCamera.CFrame = CFrameLocation['Location']
			while wait() do
				local shouldBreak = false
				if shouldBreak == true then break end
				CameraEvents.Disable.Event:Connect(function()
					CurrentCamera.CameraType = Enum.CameraType.Custom
					shouldBreak = true
				end)
			end
		end)
		return CameraEvents.Disable
	else
		return warn('Camera In Use')
	end
end

--@CameraControler.SetCameraLoop
--#Begins a camera loop using a CameraControlerLoopList
--&CameraControlerLoopList(A Value from CameraControler:CreateLoop)
--%Returns: RBXScriptSignal
function CameraControler.SetCameraLoop(CameraControlerLoopList)
	if CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
		spawn(function()
			local shouldBreak = false
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			CurrentCamera.CFrame = CameraControlerLoopList[#CameraControlerLoopList]['Location']
			CameraEvents.Disable.Event:Connect(function()
				CurrentCamera.CameraType = Enum.CameraType.Custom
				shouldBreak = true
			end)
			while wait() do
				if shouldBreak == true then break end
				
				for i, v in pairs(CameraControlerLoopList) do
					local Location = v['Location']
					local Number = v['Number']
					local TweenStyle = v['TweenStyle']
					local Goal = {
						CFrame = Location
					}
					local Tween = TweenService:Create(CurrentCamera, TweenStyle, Goal)
					Tween:Play()
					Tween:Wait()
				end
			end
		end)
		return CameraEvents.Disable
	else
		return warn('Camera In Use')
	end
end
return CameraControler

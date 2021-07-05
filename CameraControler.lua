--[[
		CameraControler
		Version 1.1
		
		Github: instantstudio/cameracontroler
]]--
local CameraControler = {}
local CameraEvents = {
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
			['Number'] = i,
			['TweenStyle'] = v['TweenStyle']
		}
		table.insert(CameraControlerLoopList, Table.Number, Table)
	end
	return CameraControlerLoopList
end

--@CameraControler:CreateCFrameLocation
--#Creates a CFrameLocation Object
--&CFrameValue(CFrame), Number(Id in list *Optional), TweenStyle(TweenInfo *Optional)
--%Returns: CFrameLocation
function CameraControler:CreateCFrameLocation(CFrameValue, TweenStyle)
	local Issues = {false, 'Cannot Create CFrameLocation'}
	if TweenStyle ~= TweenInfo then
		Issues[2] = Issues[2] .. '; TweenStyle is not inputed using default'
		TweenStyle = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
	end
	if Issues[1] == false then
		return {
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

				for i, v in pairs(CameraControlerLoopList) do
					local Location = v['Location']
					local Number = v['Number']
					local TweenStyle = v['TweenStyle']
					local Goal = {
						CFrame = Location
					}
					local Tween = TweenService:Create(CurrentCamera, TweenStyle, Goal)
					if shouldBreak == true then Tween:Cancel() break end
					Tween:Play()
					Tween.Completed:Wait()
				end
			end
		end)
		return CameraEvents.Disable
	else
		return warn('Camera In Use')
	end
end
return CameraControler

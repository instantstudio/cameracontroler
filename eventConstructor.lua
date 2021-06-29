--[[
  eventConstructor.lua
  This is a command bar system copy the code below to create the events needed for the camera controler to work.
]]--

local CameraControlerModuleLocation = game
a=Instance.new("BindableEvent",CameraControlerModuleLocation)e.Name='Disable'
b=Instance.new("BindableEvent",CameraControlerModuleLocation)b.Name='CameraFinishedLoop'
c=Instance.new("BindableEvent",CameraControlerModuleLocation)c.Name='CameraChanged'

local UCManager = require("SDK.UCManager")
local TestManager = require("SDK.TestManager")
local DevManager = require("SDK.DevManager")

-- 根据相应的渠道号实例相应的Manager
local ChannelDic = {
   ["DEV"] = DevManager,
   ["TEST"] = TestManager,
   ["UC"] = UCManager
}

ChannelDic = setmetatable(ChannelDic, {
							 __index = function(t, key)
								local f = rawget(ChannelDic, key)
								return f or DevManager
							 end
})

SDKManager = {
   __channel = "DEV"
}

function SDKManager:InitByChannel(channel)
   
   SDKManager = setmetatable(ChannelDic[channel], {__index = self})
   self.__channel = channel
   print("Current channel is " ..channel)
end

function SDKManager:getOpenId()
   return "defualt url"
end

function SDKManager:getCurrentVersion()
   return "0.1"
end

function SDKManager:getCurrentPackageName()
   return "current package name"
end

function SDKManager:getCurrentChannel()
   return self.__channel
end

function SDKManager:getLoginUrl()
   return "default url"
end


-- 处理对应渠道的特殊需求
function SDKManager:handleSpecialFunc(channel, funcSucess, funcFail)
   if (channel ~= self.__channel) then
	  if (type(funcFail) ~= "function") then return nil  end
	  return funcFail()
   end
   if (type(funcSucess) ~= "function") then return nil end
   return funcSucess()
end

SDKManager:InitByChannel("UC")
print(SDKManager:getLoginUrl())
SDKManager:handleSpecialFunc("DEV", 
   function()
      print("handle dev func")
   end, 
   function() 
      print("handle other channel func")
   end)
return SDKManager

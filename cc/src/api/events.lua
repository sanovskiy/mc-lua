local events = {};

function registerEventHandler(eventName, handler)
  if type(handler) ~= "function" then
    error("handler must be function")
  end
  if events[eventName] == nil then
  	events[eventName] = {}
  end
  table.insert(events[eventName],handler)
end

function triggerEvent(eventName,params)
  if events[eventName] ~= nil then
  	for _,handler in pairs(events[eventName]) do
  		handler(params)
  	end
  end
end

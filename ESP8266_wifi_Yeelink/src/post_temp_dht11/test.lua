tmr.alarm(0, 20000, 1, function()
    local PIN = 4
    local DHT= require("dht_lib")
    DHT.init(PIN)
    local t = DHT.getTemp()
    local h = DHT.getHumidity()
    if t == nil or h == nil then
      print("Error reading from DHT11")
    else
      print("Temperature: ".. t .."°C")
      print("Humidity: ".. h .."%RH")
    end
    DHT = nil
    package.loaded["dht_lib"]=nil
end)

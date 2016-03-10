local count = 1
local Server_ip
tmr.alarm(3, 60000, 1, function()
    print( count .. "times")
    local PIN = 4
    local t= require("ds18b20")
    t.setup(PIN)
    local temp = string.format("%0.1f",t.read())
    sendTemp(temp)
    PIN= nil
    t = nil
    temp = nil
    ds18b20 = nil
    package.loaded["ds18b20"]=nil
    tmr.wdclr()
    count = count+1
end)

function sendTemp(t)
    if t == nil then
      print("Get Temp False")
    else    
      conn=net.createConnection(net.TCP, 0)
      conn:dns("api.yeelink.net",function(conn,ip) Server_ip = ip end)
      conn:connect(80, Server_ip)  
      postData = "{\"value\":\"" .. t .. "\"}"  
      conn:send("POST /v1.0/device/".. device_id .."/sensor/".. sensor_id_temp .."/datapoints HTTP/1.1\r\n")
      conn:send("Host: api.yeelink.net\r\n")
      conn:send("Content-Length: " .. string.len(postData) .. "\r\n")
      conn:send("Content-Type: application/x-www-form-urlencoded\r\n")
      conn:send("U-ApiKey: ".. api_key .. "\r\n")
      conn:send("Cache-Control: no-cache\r\n\r\n")
      conn:send(postData .. "\r\n")    
      conn:on("receive", function(conn, payload) 
        if debug then
          print("\r\n"..payload.."\r\n") 
        else
          print("Temp_Date Sent"..t)
        end
      postData = nil
      conn = nil
      end)
    end
end

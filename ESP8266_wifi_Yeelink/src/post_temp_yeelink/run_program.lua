local count = 1
local Server_ip
tmr.alarm(3, 60000, 1, function()
    print( count .. "times")
    local PIN = 4
    local DHT= require("dht_lib")
    DHT.init(PIN)
    local t = DHT.getTemp()
    local h = DHT.getHumidity()
    sendTemp(t)  
    sendRH(h)  
    DHT = nil
    package.loaded["dht_lib"]=nil
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
      end)
    end
end

function sendRH(h)
    if h == nil then
      print("Get RH False")
    else    
      conn=net.createConnection(net.TCP, 0)
      conn:dns("api.yeelink.net",function(conn,ip) Server_ip = ip end)
      conn:connect(80, Server_ip)  
      postData = "{\"value\":\"" .. h .. "\"}"  
      conn:send("POST /v1.0/device/".. device_id .."/sensor/".. sersor_id_RH .."/datapoints HTTP/1.1\r\n")
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
          print("RH_Date Sent"..h)
        end
      end)
    end
end

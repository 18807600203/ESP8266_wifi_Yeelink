local count = 1
local Server_ip
tmr.alarm(3, 60000, 1, function()
    if(wifi.sta.getip() ~= nil) then
      print( count .. "times")
      getData()
      count = count+1
    else 
      return
    end
end)

function getData()

    conn=net.createConnection(net.TCP, 0)
    conn:dns("api.yeelink.net",function(conn,ip) Server_ip = ip end)
    conn:connect(80, Server_ip)    
    conn:send("GET /v1.0/device/".. device_id .."/sensor/".. sensor_id .."/datapoints HTTP/1.1\r\n") 
    conn:send("Host: api.yeelink.net\r\n") 
    conn:send("Accept: */*\r\n") 
    conn:send("Content-Type: text/html; charset=UTF-8\r\n")
    conn:send("Cache-Control: no-cache\r\n\r\n")
    conn:send("Content-Length: 0\r\n")
    conn:send("Connection: keep-alive\r\n")
    conn:send("\r\n")
    conn:on("receive", function(conn, payload) 
      local i,j,k,data,web_btn_value
      i = payload:find("{")
      k,j = payload:find("}")
      k = nil
      if i== nil or j==nil then
          return -1
      end
      data = cjson.decode(payload:sub(i,j))
      web_btn_value = data.value
      if web_btn_value == 1 then
          gpio.write(3, gpio.HIGH)
      else
          gpio.write(3, gpio.LOW)
      end
      if debug then
        print("\r\n"..payload.."\r\n") 
      else
        print("Get Data Successd" .. web_btn_value)
      end
    end)
end

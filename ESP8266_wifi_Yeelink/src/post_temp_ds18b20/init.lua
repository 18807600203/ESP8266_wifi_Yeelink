--[[
   LED PIN = 1
   System restore PIN = 2
   Relay ctr PIN = 3 
--]]
 
  ssid = "ESP8266"
  psw  = "12345678"
  device_id = "344067"
  sensor_id_temp = "383205"
  api_key = "37f8a3d7507ecef73b3c13b8119d657c"
  led_pin = 1
  rset_pin = 2
  ctr_pin = 3
  gpio.mode(3, gpio.OUTPUT)
  gpio.write(3, gpio.LOW)  
  require("convet1") -- chang password to ansi code ftom website
  require("restkey") -- load restorekey function,when key press over 5 second and then releast it,mcu will resert and remove "config.lua"&"config.lc"
  require("ledctr") -- load led ctrol file
  ledctr(1000) -- set led blink per time

  if pcall(function ()
    dofile("config.lc")
  end) then
    ledctr(80)
    print("Connecting to WIFI...")
    wifi.setmode(wifi.STATION)
    wifi.sta.config(ssid,password)
    wifi.sta.connect()
    cnt = 0
    tmr.alarm(0, 1000, 1, function()
      if wifi.sta.getip() == nil and (cnt < 20) then
        print("IP unavaiable, waiting.")
        cnt = cnt + 1
      else
        if (cnt < 20) then
          tmr.stop(0)
          tmr.stop(1)
          gpio.mode(1, gpio.OUTPUT)
          gpio.write(1, gpio.HIGH)
          print("Connected, IP is "..wifi.sta.getip())
          dofile("run_program.lua")
        else
          print("Wifi setup time more than 20s,system will reset config,please browse 192.168.4.1 in your website after system reboot")
          file.remove("config.lc")
          file.remove("config.lua")
          node.restart()
        end
      end
    end)
  else
    print("Enter configuration mode")
    dofile("run_config.lua")
  end


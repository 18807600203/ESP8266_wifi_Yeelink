gpio.mode(rset_pin, gpio.INPUT)
gpio.write(rset_pin, gpio.LOW)
tmr.alarm(2, 1000, 1, function()
	if gpio.read(rset_pin) == 1  then
		tmr.delay(4000000)
		if gpio.read(rset_pin) == 1 then			
			tmr.stop(1)
			gpio.mode(led_pin, gpio.OUTPUT)
			gpio.write(led_pin, gpio.HIGH)
			tmr.stop(2)
			file.remove("config.lua")
			file.remove("config.lc")
			node.restart();			
		end
	end
end)

	function ledctr(t) --t is time .ed. 1000
		function led(b)
		  pwm.setduty(led_pin,b)
		end
		pwm.setup(led_pin,500,512) --pwn startup,IO:1
		pwm.start(led_pin)		
		lighton=0  --led blink
		tmr.alarm(1, t, 1, function()
			if lighton==0 then
				lighton=1
				--led(512, 512, 512)
				led(512)
			else
				lighton=0
				led(0)
			end
		end)
	end

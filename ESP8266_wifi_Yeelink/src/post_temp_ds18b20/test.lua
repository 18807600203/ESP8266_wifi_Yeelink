t = require("ds18b20")
t.setup(ctr_pin)
addrs = t.addrs()
print("Temperature: "..t.read().."'C")
t = nil
ds18b20 = nil
package.loaded["ds18b20"]=nil
function convet1(s)
  s = string.gsub(s, "+", " ")
  s = string.gsub(s, "%%(%x%x)", function (h)
   return string.char(tonumber(h, 16))
  end)
  return s
end

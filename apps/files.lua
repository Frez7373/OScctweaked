-- OScctweaked Files
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1,1)
print("OScctweaked Files")
print(string.rep("-", math.min(term.getSize())))

local list = fs.list("/")
for i, name in ipairs(list) do
  local prefix = fs.isDir("/" .. name) and "[DIR] " or "      "
  print(prefix .. name)
end

print("")
print("Press any key to return.")
os.pullEvent("key")

-- OScctweaked Settings
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1,1)
print("OScctweaked Settings")
print(string.rep("-", math.min(term.getSize())))
print("1. System information")
print("2. Reboot")
print("3. Shutdown")
print("0. Return")

while true do
  local e, key = os.pullEvent("key")
  if key == keys.zero then return
  elseif key == keys.one then
    term.setCursorPos(1,8)
    print("Computer ID: " .. os.getComputerID())
    print("Label: " .. (os.getComputerLabel() or "Not set"))
    print("CraftOS: " .. os.version())
    print("Press any key...")
    os.pullEvent("key")
    return
  elseif key == keys.two then os.reboot()
  elseif key == keys.three then os.shutdown()
  end
end

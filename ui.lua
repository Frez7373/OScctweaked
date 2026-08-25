local ui = {}

ui.colors = {
  bg = colors.black,
  panel = colors.gray,
  panel2 = colors.lightGray,
  accent = colors.blue,
  accent2 = colors.cyan,
  text = colors.white,
  darkText = colors.black,
  good = colors.lime,
  danger = colors.red
}

function ui.clear(bg)
  term.setBackgroundColor(bg or ui.colors.bg)
  term.setTextColor(ui.colors.text)
  term.clear()
  term.setCursorPos(1,1)
end

function ui.rect(x1,y1,x2,y2,bg,fg,ch)
  term.setBackgroundColor(bg or ui.colors.panel)
  term.setTextColor(fg or ui.colors.text)
  for y=y1,y2 do
    term.setCursorPos(x1,y)
    write(string.rep(ch or " ", math.max(0,x2-x1+1)))
  end
end

function ui.text(x,y,s,fg,bg)
  if bg then term.setBackgroundColor(bg) end
  if fg then term.setTextColor(fg) end
  term.setCursorPos(x,y)
  write(tostring(s))
end

function ui.center(y,s,fg,bg)
  local w = term.getSize()
  local x = math.max(1, math.floor((w-#s)/2)+1)
  ui.text(x,y,s,fg,bg)
end

function ui.header(title, back)
  local w,h = term.getSize()
  ui.rect(1,1,w,2,ui.colors.panel,ui.colors.text)
  ui.text(2,1,title,ui.colors.text,ui.colors.panel)
  if back then ui.button(w-9,1,w,2,"BACK",ui.colors.danger) end
  return w,h
end

function ui.button(x1,y1,x2,y2,label,bg,fg)
  bg = bg or ui.colors.accent
  fg = fg or ui.colors.text
  ui.rect(x1,y1,x2,y2,bg,fg)
  local w = x2-x1+1
  local h = y2-y1+1
  local tx = x1 + math.max(0, math.floor((w-#label)/2))
  local ty = y1 + math.floor((h-1)/2)
  ui.text(tx,ty,label,fg,bg)
end

function ui.hit(x,y,x1,y1,x2,y2)
  return x>=x1 and x<=x2 and y>=y1 and y<=y2
end

function ui.waitTouch()
  while true do
    local e,_,x,y = os.pullEvent()
    if e=="mouse_click" or e=="monitor_touch" then return x,y end
    if e=="key" and _==keys.q then return nil,nil end
  end
end

function ui.wrap(text,width)
  local out={}
  for line in (text.."\n"):gmatch("(.-)\n") do
    if line=="" then table.insert(out,"") else
      while #line>width do
        table.insert(out,line:sub(1,width))
        line=line:sub(width+1)
      end
      table.insert(out,line)
    end
  end
  return out
end

return ui

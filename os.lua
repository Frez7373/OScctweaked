local ui=dofile("core/ui.lua")
local registry=dofile("core/apps.lua")
local W,H=term.getSize()
local running=true; local startOpen=false; local selectedShortcut=nil; local lastShortcut=0; local search=""
local theme={name="blue",wall=colors.blue,task=colors.gray,accent=colors.cyan}
local windows={}; local notice=nil; local noticeUntil=0; local dragging=nil; local dragOX=0; local dragOY=0
local function say(t,s) notice=t; noticeUntil=os.clock()+(s or 3) end
local function desktopHeight() return math.max(6,H-2) end
local function visibleApps() local o={}; for _,a in ipairs(registry) do if search=="" or a.title:lower():find(search:lower(),1,true) then table.insert(o,a) end end; return o end
local function makeCtx() return {apps=registry,theme=theme.name,notify=function(t) say(t,3) end} end
local function buildContent(w) if w.content then w.content.setVisible(false) end; w.content=window.create(term.native,w.x,w.y+2,math.max(8,w.w),math.max(4,w.h-2),false); w.content.setVisible(w.visible and not w.minimized) end
local function drawDesktop()
 term.setBackgroundColor(theme.wall); term.setTextColor(colors.white); term.clear()
 local top=desktopHeight()-1
 if W>=50 and H>=20 then local cx=math.floor(W/2); local cy=math.floor(top/2); ui.fill(cx-9,cy-3,cx-1,cy-1,colors.lightBlue); ui.fill(cx+1,cy-3,cx+9,cy-1,colors.white); ui.fill(cx-9,cy+1,cx-1,cy+3,colors.white); ui.fill(cx+1,cy+1,cx+9,cy+3,colors.lightBlue) end
 local cols=4; local gapX=math.max(11,math.floor(W/5)); local gapY=5
 for i,a in ipairs(registry) do local n=i-1; local col=n%cols; local row=math.floor(n/cols); local x=2+col*gapX; local y=3+row*gapY; if y+3<top and x+8<=W then local sel=selectedShortcut==i; ui.outline(x,y,x+4,y+2,colors.white,sel and colors.blue or theme.wall); ui.center(x,x+4,y+1,a.icon,colors.white,sel and colors.blue or theme.wall); ui.text(x,y+3,a.title:sub(1,9),colors.white,theme.wall) end end
end
local function drawTaskbar()
 ui.fill(1,H-1,W,H,theme.task,colors.white); ui.button(1,H-1,8,H,"WIN",theme.accent); ui.fill(10,H-1,29,H,colors.lightGray,colors.black); ui.text(11,H,search=="" and "Search" or search,colors.gray,colors.lightGray)
 local x=31; for _,w in ipairs(windows) do if x+10<W-20 then ui.button(x,H-1,x+10,H,w.meta.icon.." "..w.meta.title:sub(1,8),w.minimized and colors.gray or colors.blue); x=x+12 end end
 ui.text(math.max(1,W-18),H-1,"Day "..math.floor(os.time()),colors.white,theme.task); ui.text(math.max(1,W-6),H,os.date("%H:%M"),colors.white,theme.task)
end
local function frame(w,active)
 local bg=active and theme.accent or colors.blue
 ui.fill(w.x,w.y,w.x+w.w-1,w.y+w.h-1,colors.white,colors.black); ui.fill(w.x,w.y,w.x+w.w-1,w.y,bg,colors.white); ui.text(w.x+1,w.y,w.meta.title:sub(1,math.max(1,w.w-12)),colors.white,bg)
 ui.button(w.x+w.w-10,w.y,w.x+w.w-7,w.y,"-",colors.gray); ui.button(w.x+w.w-6,w.y,w.x+w.w-3,w.y,"[]",colors.gray); ui.button(w.x+w.w-2,w.y,w.x+w.w-1,w.y,"X",colors.red)
end
local function drawStart()
 if not startOpen then return end
 local mw=math.min(44,W-2); local mh=math.min(H-4,20); local x=2; local y=H-mh-1
 ui.fill(x,y,x+mw,y+mh,colors.lightGray,colors.black); ui.fill(x,y,x+mw,y+2,theme.accent,colors.white); ui.text(x+2,y+1,"OScctweaked",colors.white,theme.accent)
 ui.fill(x+1,y+3,x+mw-1,y+4,colors.white,colors.black); ui.text(x+2,y+4,search=="" and "Search applications" or search,colors.gray,colors.white)
 local list=visibleApps(); local cw=math.max(12,math.floor((mw-3)/2)); for i,a in ipairs(list) do local n=i-1; local bx=x+1+(n%2)*cw; local by=y+6+math.floor(n/2)*2; if by+1<y+mh-2 then ui.button(bx,by,bx+cw-2,by+1,a.icon.." "..a.title,colors.gray) end end
 ui.button(x+1,y+mh-1,x+11,y+mh,"LOCK",colors.gray); ui.button(x+13,y+mh-1,x+27,y+mh,"SHUTDOWN",colors.red)
end
local function redraw()
 W,H=term.getSize(); drawDesktop(); drawTaskbar(); for _,w in ipairs(windows) do if w.visible and not w.minimized then frame(w,w==windows[#windows]) end end; drawStart()
 if notice and os.clock()<noticeUntil then local ww=math.min(34,W-4); local nx=W-ww-1; ui.fill(nx,2,W-2,4,colors.gray,colors.white); ui.text(nx+2,3,notice:sub(1,ww-4),colors.white,colors.gray) end
 for _,w in ipairs(windows) do if w.content then w.content.setVisible(false) end end
 if windows[#windows] and windows[#windows].visible and not windows[#windows].minimized then windows[#windows].content.setVisible(true) end
end
local function focus(w)
 for i,x in ipairs(windows) do if x==w then table.remove(windows,i); break end end; table.insert(windows,w); w.minimized=false; redraw()
 local old=term.current(); term.redirect(w.content); pcall(function() w.app.draw(w.content,w.ctx) end); term.redirect(old); redraw()
end
local function create(meta)
 local ok,mod=pcall(function() return loadfile(meta.file)() end); if not ok or type(mod)~="table" or type(mod.new)~="function" then say("Cannot load "..meta.title,4); return end
 local w=math.min(meta.w or 40,math.max(30,W-4)); local h=math.min(meta.h or 18,math.max(10,H-4)); local o=(#windows*2)%8; local x=math.max(2,math.floor((W-w)/2)+o); local y=math.max(2,math.floor((desktopHeight()-h)/2)+o); if x+w>W then x=2 end; if y+h>desktopHeight() then y=2 end
 local base=makeCtx(); local ok2,obj=pcall(function() return mod.new(base) end); if not ok2 or type(obj)~="table" then say("Application failed",4); return end
 local win={meta=meta,app=obj,ctx=obj.ctx or base,x=x,y=y,w=w,h=h,visible=true,minimized=false,maximized=false}; buildContent(win); table.insert(windows,win); focus(win)
end
local function closeWin(w) if w.content then w.content.setVisible(false) end; for i,x in ipairs(windows) do if x==w then table.remove(windows,i); break end end; redraw() end
local function maxWin(w)
 if not w.maximized then w.restore={x=w.x,y=w.y,w=w.w,h=w.h}; w.x=2; w.y=2; w.w=W-2; w.h=desktopHeight()-2; w.maximized=true else local r=w.restore; w.x=r.x; w.y=r.y; w.w=r.w; w.h=r.h; w.maximized=false end
 buildContent(w); redraw(); local old=term.current(); term.redirect(w.content); pcall(function() w.app.draw(w.content,w.ctx) end); term.redirect(old); redraw()
end
local function moveWin(w,nx,ny) w.x=math.max(1,math.min(nx,W-w.w+1)); w.y=math.max(2,math.min(ny,desktopHeight()-w.h+1)); buildContent(w); redraw(); local old=term.current(); term.redirect(w.content); pcall(function() w.app.draw(w.content,w.ctx) end); term.redirect(old); redraw() end
local function hitWin(x,y) for i=#windows,1,-1 do local w=windows[i]; if w.visible and not w.minimized and ui.hit(x,y,w.x,w.y,w.x+w.w-1,w.y+w.h-1) then return w end end end
local function shortcut(x,y) local cols=4; local gapX=math.max(11,math.floor(W/5)); local gapY=5; for i,a in ipairs(registry) do local n=i-1; local bx=2+(n%cols)*gapX; local by=3+math.floor(n/cols)*gapY; if ui.hit(x,y,bx,by,bx+8,by+3) then if selectedShortcut==i and os.clock()-lastShortcut<0.55 then selectedShortcut=nil; create(a) else selectedShortcut=i; lastShortcut=os.clock(); redraw() end; return true end end; return false end
local function click(x,y)
 if startOpen then local mw=math.min(44,W-2); local mh=math.min(H-4,20); local sx=2; local sy=H-mh-1; if ui.hit(x,y,sx+1,sy+3,sx+mw-1,sy+4) then return end; if ui.hit(x,y,sx+13,sy+mh-1,sx+27,sy+mh) then os.shutdown() end; local list=visibleApps(); local cw=math.max(12,math.floor((mw-3)/2)); if y>=sy+6 then local col=math.floor((x-(sx+1))/cw); local row=math.floor((y-(sy+6))/2); local i=row*2+col+1; if i>=1 and i<=#list then startOpen=false; create(list[i]); return end end; startOpen=false; redraw(); return end
 if ui.hit(x,y,1,H-1,8,H) or ui.hit(x,y,10,H-1,29,H) then startOpen=true; redraw(); return end
 local tx=31; for _,w in ipairs(windows) do if tx+10<W-20 and ui.hit(x,y,tx,H-1,tx+10,H) then focus(w); return end; tx=tx+12 end
 local w=hitWin(x,y); if w then focus(w); if ui.hit(x,y,w.x+w.w-2,w.y,w.x+w.w-1,w.y) then closeWin(w); return end; if ui.hit(x,y,w.x+w.w-10,w.y,w.x+w.w-7,w.y) then w.minimized=true; w.content.setVisible(false); redraw(); return end; if ui.hit(x,y,w.x+w.w-6,w.y,w.x+w.w-3,w.y) then maxWin(w); return end; if y==w.y then dragging=w; dragOX=x-w.x; dragOY=y-w.y; return end
  local lx=x-w.x+1; local ly=y-(w.y+2)+1; local old=term.current(); term.redirect(w.content); local ok,changed=pcall(function() return w.app.handle("click",lx,ly,w.ctx) end); if ok and changed then pcall(function() w.app.draw(w.content,w.ctx) end) end; term.redirect(old); redraw(); return end
 shortcut(x,y)
end
redraw(); os.startTimer(1)
while running do
 local ev,p1,p2,p3=os.pullEvent()
 if ev=="term_resize" then W,H=term.getSize(); redraw()
 elseif ev=="timer" then redraw(); os.startTimer(1)
 elseif ev=="mouse_click" then click(p2,p3)
 elseif ev=="monitor_touch" then click(p2,p3)
 elseif ev=="mouse_drag" and dragging and p1==1 then moveWin(dragging,p2-dragOX,p3-dragOY)
 elseif ev=="mouse_up" then dragging=nil
 elseif ev=="char" and startOpen then search=search..p1; redraw()
 elseif ev=="key" then if startOpen and p1==keys.backspace then search=search:sub(1,-2); redraw() elseif p1==keys.escape then startOpen=false; redraw() end
 elseif ev=="terminate" then running=false end
end

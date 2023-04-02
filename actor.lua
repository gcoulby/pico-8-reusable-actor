type = {top=0, side=1}
MAP_X = 0
MAP_Y = 0
function fmget(x,y,f) 
  return fget(mget(x+MAP_X,y+MAP_Y),f) 
end

actor = {}
function actor:new(x, y, w, h, dx, dy, max_dx, max_dy, max_jumps, acc, boost, grav, fric, cm, cw, slide, _type)
  local o = {}
  o.__index = self
  setmetatable(o, self)
  o.x=x
  o.y=y
  o.w=w
  o.h=h
  o.dx=dx
  o.dy=dy
  o.max_dx=max_dx
  o.max_dy=max_dy
  o.max_jumps=max_jumps
  o.jumps=0
  o.acc=acc
  o.boost=boost
  o.cm=cm
  o.cw=cw
  o.grav=grav
  o.fric=fric
  o.air=false
  o.slide=slide
  o.type=_type

  -- print
  o.print = function()
    print("dx= "..o.dx)
    print("dy= "..o.dy)
  end

  -- Collision Detection
  o.chk_cols = function()
    local ct=false
    local cb=false

    -- if colliding with map tiles
    if(o.cm) then   
      local x1=o.x/8
      local x2=(o.x+(o.w-1))/8
      local y1=o.y/8
      local y2=(o.y+(o.h-1))/8
      ct=fmget(x1,y1,0) or fmget(x1,y2,0) or fmget(x2,y2,0) or fmget(x2,y1,0)
    end
    -- if colliding with world bounds
    if(o.cw) then
      cb=(o.x<0 or o.x+o.w>128 or
               o.y<0 or o.y+o.h>128)
    end
    return ct or cb
  end

  o.chk_gnd = function()
    local x1=flr(o.x/8)
    local x2=flr((o.x+(o.w-1))/8)
    local y1=flr((o.y+o.h)/8)
    return fmget(x1,y1,0) or fmget(x2,y1,0)
  end
  
  o.chk_ceil = function()
    local x1=flr(o.x/8)
    local x2=flr((o.x+(o.w-1))/8)
    local y1=flr((o.y-1)/8)
    return fmget(x1,y1,0) or fmget(x2,y1,0)
  end

  o.chk_wall = function(d)
    local x1=flr((o.x-1)/8)
    local x2=flr((o.x+o.w)/8)
    local y1=flr(o.y/8)
    local y2=flr((o.y+(o.h-1))/8)
    return (d==0 and(fmget(x1,y1,0) or fmget(x1,y2,0))) or (d==1 and (fmget(x2,y2,0) or fmget(x2,y1,0)))
  end

  o.get_coord=function(lc, c)
    local glc=flr(lc/8)
    local gc=flr(c/8)
    local r=flr(c/8)*8
    if (glc>gc) r=flr(c/8)*8+8
    if (o.cw and c <= 0) r = 0
    if (o.cw and c >= 128) r = 128
    return r
  end

  o.moveX = function(acc)
    local lx=o.x -- last x
    o.dx+=acc
    o.dx=mid(-o.max_dx,o.dx,o.max_dx)
    o.x+=o.dx
    
    if(o.chk_cols()) then
      o.x = o.get_coord(lx, o.x)
    end
  end

  o.moveY = function(boost)
    local ly=o.y -- last y
    o.dy+=boost
    if (o.dy>0) then
      o.dy=mid(-o.max_dy,o.dy,o.max_dy)
    end
    o.y+=o.dy
    if(o.chk_cols()) then 
      o.y = o.get_coord(ly, o.y)
    end
  end

  o.jump = function()
    if o.max_jumps == -1 or o.jumps < o.max_jumps then
      o.dy=3
      
      o.moveY(-o.boost)
      o.air=true
      if (o.max_jumps ~= -1) o.jumps+=1
    end
  end
 
  o.apply_forces = function()
    if(o.slide and o.air and ((o.chk_wall(0) and btn(0)) or (o.chk_wall(1) and btn(1)))) then
      o.dy=0
      o.jumps=0
    end
    if(o.type==type.top) o.dy*=fric
    if(o.type==type.side) o.dy+=grav
    o.dx*=fric
    o.moveX(0)
    o.moveY(0)
  end

  -- Draw
  o.draw = function()
    -- rectfill(o.x, o.y, o.x+o.w, o.y+o.h, 7)
    -- spr(1,o.x,o.y)
    spr(3,o.x,o.y,1,2)
  end

  -- Update
  o.update = function()
    o.apply_forces()
    if (o.chk_gnd()) then
      o.air=false
      o.jumps=0
      o.dy=0
    elseif(o.air==false)then
      o.air=true
    end
    if (o.chk_ceil()) o.dy=0
    -- o.draw()
  end

  return o
end
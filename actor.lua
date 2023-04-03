type = {top=0, side=1}
MAP_X = 0
MAP_Y = 0
function fmget(x,y,f) 
  return fget(mget(x+MAP_X,y+MAP_Y),f) 
end

function create_spr_col(sprites, flipX, flipY)
  local o = {}
  o.__index = self
  setmetatable(o, self)
  o.flipX=flipX or false
  o.flipY=flipY or false
  o.sprites=sprites
  o.draw = function(x, y)   
    iSrt = 1
    iEnd = #o.sprites
    iInc = 1
    jSrt = 1
    jEnd = #o.sprites[1]
    jInc = 1
    if(o.flipY) then
      iSrt = #o.sprites
      iEnd = 1
      iInc = -1
    end
    if(o.flipX) then
      jSrt = #o.sprites[1]
      jEnd = 1
      jInc = -1
    end
    local k=0
    for i=iSrt,iEnd,iInc do
      local l=0
      for j=jSrt,jEnd,jInc do
        spr(o.sprites[i][j], x+(l)*8, y+(k)*8, 1, 1, o.flipX, o.flipY)
        l+=1
      end
      k+=1
    end
  end
  return o
end

function create_anim(_spr_cols, delay)
  local o = {}
  o.__index = self
  setmetatable(o, self)
  o.flipX=false
  o.flipY=false
  o.t=1
  o.i=1
  o.d=delay
  o.f=#_spr_cols
  o.spr_cols = {}
  for i=1,#_spr_cols do
    o.spr_cols[i] = create_spr_col(_spr_cols[i])
  end

  o.draw = function(x, y)
    o.spr_cols[o.i].flipX=o.flipX
    o.spr_cols[o.i].flipY=o.flipY
    o.spr_cols[o.i].draw(x, y)
  end
  o.update = function()
    o.t+=1
    if(o.t>=o.d) then
      o.t=0
      o.i+=1
      if(o.i>=o.f) o.i=1
    end
  end
  return o
end

actor = {}
function actor:new(x, y, w, h, flipX, flipY, dx, dy, max_dx, max_dy, max_jumps, acc, boost, grav, fric, cm, cw, slide, _type)
  local o = {}
  o.__index = self
  setmetatable(o, self)
  o.x=x
  o.y=y
  o.w=w
  o.h=h
  o.flipX=flipX or false
  o.flipY=flipY or false
  o.dx=dx
  o.dy=dy
  o.max_dx=max_dx
  o.max_dy=max_dy
  o.max_jumps=max_jumps
  o.acc=acc
  o.boost=boost
  o.cm=cm
  o.cw=cw
  o.grav=grav
  o.fric=fric
  o.slide=slide
  o.type=_type
  o.cur_anim="idle"
  o.air=false
  o.last_y=0
  o.jumps=0
  o.anims={
    ["idle"]=create_anim({{{0}}},1),
    ["run"]=create_anim({{{0}}},1),
    ["jump"]=create_anim({{{0}}},1),
    ["fall"]=create_anim({{{0}}},1),
    ["slide"]=create_anim({{{0}}},1),
  } 

  o.chk_cols = function()
    local ct=false
    local cb=false

    if(o.cm) then   
      local x1=o.x/8
      local x2=(o.x+(o.w-1))/8
      local y1=o.y/8
      local y2=(o.y+(o.h-1))/8
      ct=fmget(x1,y1,0) or fmget(x1,y2,0) or fmget(x2,y2,0) or fmget(x2,y1,0)
    end

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
    local lx=o.x
    o.dx+=acc
    o.dx=mid(-o.max_dx,o.dx,o.max_dx)
    o.x+=o.dx
    
    if(o.chk_cols()) then
      o.x = o.get_coord(lx, o.x)
    end
  end

  o.moveY = function(boost)
    local ly=o.y
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
    o.last_y=o.y
    if o.max_jumps == -1 or o.jumps < o.max_jumps then
      o.dy=3
      
      o.moveY(-o.boost)
      o.air=true
      if (o.max_jumps ~= -1) o.jumps+=1
    end
  end
 
  o.apply_forces = function()
    if(o.air and o.max_jumps~=0) then
      o.cur_anim="jump"
      if(o.last_y<=o.y) o.cur_anim="fall"
      o.last_y=o.y
    end
    if(o.slide and o.air and ((o.chk_wall(0) and btn(0)) or (o.chk_wall(1) and btn(1)))) then
      o.cur_anim="slide"
      o.dy=0
      o.jumps=0
    end
    if(o.type==type.top) o.dy*=fric
    if(o.type==type.side) o.dy+=grav
    o.dx*=fric
    o.moveX(0)
    o.moveY(0)
  end

  o.add_anim = function(name, spr_cols, d)
    o.anims[name]=create_anim(spr_cols, d)
  end

  o.draw = function()   
    o.anims[o.cur_anim].draw(o.x, o.y)
  end

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
    o.anims[o.cur_anim].flipX=o.flipX
    o.anims[o.cur_anim].flipY=o.flipY
    o.anims[o.cur_anim].update()
  end

  return o
end
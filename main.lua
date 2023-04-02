function _init()
    p = actor:new(
    --[[x]]59,
    --[[y]]59,
    --[[w]]8,
    --[[h]]16,
    --[[dx]]0,
    --[[dy]]0,
    --[[max_dx]]2,
    --[[max_dy]]3,
    --[[max_jumps]]2,
    --[[acc]]0.5,
    --[[boost]]6,
    --[[grav]]0.2,
    --[[fric]]0.6,
    --[[cm]]true,
    --[[cw]]true,
    --[[slide]]true,
    --[[_type]]type.side
    )
    MAP_X = 4
end

function _update60()
    local a = 0
    local b = 0
    if(btn(0)) then
        a = -p.acc
    end
    if(btn(1)) then
        a = p.acc
    end
    if(p.type==type.top and btn(2)) then
        b = -p.acc
    end
    if(p.type==type.top and btn(3)) then
        b = p.acc
    end
    if(btnp(5)) then
        p.jump()
    end
    p.moveX(a)
    p.moveY(b)
    p.update()
end

function _draw()
    cls()
    map(MAP_X, MAP_Y)
    
    p.print()
    p.draw() 
end
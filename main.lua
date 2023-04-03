in_menu = true
menu_pos = 0

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
end

function _update60()
    if(in_menu) then
        if(btnp(4)) then
            in_menu = false
            p.x=59
            p.y=59
            if(menu_pos==0) then
                p.type = type.side
                p.slide = true
                p.max_jumps=2
                p.boost = 6
                MAP_X = 0
            elseif(menu_pos==1) then
                p.type = type.top
                p.slide = false
                p.max_jumps=0
                p.boost = 6
                MAP_X = 16
            elseif(menu_pos==2) then
                p.type = type.side
                p.slide = false
                p.max_jumps=-1
                p.boost=5
                MAP_X = 32
            end
        end
        if(btnp(0) or btnp(2)) then
            menu_pos = menu_pos - 1
            if menu_pos < 0 then
                menu_pos = 2
            end
        end
        if(btnp(1) or btnp(3)) then
            menu_pos = menu_pos + 1
            if menu_pos > 2 then
                menu_pos = 0
            end
        end
    else
        if(btnp(4)) then
            in_menu = true
        end
        update_game()
    end
end

function _draw()
    cls()
    if(in_menu) then
        draw_menu()
    else
        draw_game()
    end
end

function draw_menu()
    cls()
    rectfill(0, menu_pos*8+15, 60, menu_pos*8+21, 5)
    print("multi-use actor demo", 0, 0, 7)
    print("--------------------", 0, 8, 7)
    print("1. platformer", 0, 16, 7)
    print("2. top-down", 0, 24, 7)
    print("3. flappy", 0, 32, 7)

    print("press z to start", 0, 48, 7)
    print("when in game press z to reset", 0, 56, 7)
end

function draw_game()
    map(MAP_X, MAP_Y)
    p.print()
    p.draw()
end

function update_game()
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
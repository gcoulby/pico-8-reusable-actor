in_menu = true
menu_pos = 0

function _init()
    p = actor:new(
    --[[x]]59,
    --[[y]]59,
    --[[w]]16,
    --[[h]]16,
    --[[flipX]]false,
    --[[flipY]]false,
    --[[dx]]0,
    --[[dy]]0,
    --[[max_dx]]2,
    --[[max_dy]]3,
    --[[max_jumps]]2,
    --[[acc]]0.7,
    --[[boost]]6,
    --[[grav]]0.2,
    --[[fric]]0.6,
    --[[cm]]true,
    --[[cw]]true,
    --[[slide]]true,
    --[[_type]]type.side
    ) 
    p.add_anim("idle", {
        {{64,65},{80,81}},
        {{66,67},{82,83}},
        {{68,69},{84,85}},
        {{70,71},{86,87}},
        {{72,73},{88,89}},
        {{74,75},{90,91}},
        {{76,77},{92,93}},
        {{78,79},{94,95}},
        {{96,97},{112,113}},
        {{98,99},{114,115}},
        {{100,101},{116,117}},
    }, 4)
    p.add_anim("run", {
        {{128,129},{144,145}},
        {{130,131},{146,147}},
        {{132,133},{148,149}},
        {{134,135},{150,151}},
        {{136,137},{152,153}},
        {{138,139},{154,155}},
        {{140,141},{156,157}},
        {{142,143},{158,159}},
        {{160,161},{176,177}},
        {{162,163},{178,179}},
        {{164,165},{180,181}},
    }, 4)   
    p.add_anim("jump", {
        {{44,45},{60,61}}
    }, 4)
    p.add_anim("fall", {
        {{46,47},{62,63}}
    }, 4) 
    p.add_anim("slide", {
        {{6,7},{22,23}},
        {{8,9},{24,25}},
        {{10,11},{26,27}},
        {{12,13},{28,29}},
        {{14,15},{30,31}}
    }, 4)
end

function _update()
    if(in_menu) then
        if(btnp(5)) then
            in_menu = false
            p.x=59
            p.y=59
            p.max_dy=3
            p.boost=6
            if(menu_pos==0) then
                p.type = type.side
                p.slide = true
                p.max_jumps=2
                MAP_X = 0
            elseif(menu_pos==1) then
                p.type = type.top
                p.slide = false
                p.max_jumps=0
                MAP_X = 16
            elseif(menu_pos==2) then
                p.type = type.side
                p.slide = false
                p.max_jumps=-1
                p.boost=6
                p.max_dy=0.5
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
        if(btnp(5)) then
            in_menu = true
        end
        update_game()
    end
    p.update()
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
    rectfill(0, menu_pos*8+15, 110, menu_pos*8+21, 5)
    print("multi-use actor demo", 0, 0, 7)
    print("--------------------", 0, 8, 7)
    print("1. platformer", 0, 16, 7)
    print("2. top-down", 0, 24, 7)
    print("3. flappy", 0, 32, 7)

    print("press ❎ to start", 0, 48, 7)
    print("when in game press ❎ to reset", 0, 56, 7)
end

function print_stats()
    print("dx= "..p.dx)
    print("dy= "..p.dy)
    print("anim= "..p.cur_anim)
end

function draw_game()
    map(MAP_X, MAP_Y)

    print_stats()
    p.draw()
end

function update_game()
    local a = 0
    local b = 0
    p.cur_anim = "idle"
    if(btn(0)) then
        p.flipX = true
        p.cur_anim = "run"
        a = -p.acc
    end
    if(btn(1)) then
        p.flipX = false
        p.cur_anim = "run"
        a = p.acc
    end
    if(p.type==type.top and btn(2)) then
        p.cur_anim = "run"
        b = -p.acc
    end
    if(p.type==type.top and btn(3)) then
        p.cur_anim = "run"
        b = p.acc
    end
    if(btnp(4)) then
        p.jump()
    end
    p.moveX(a)
    p.moveY(b)
    p.update()
end
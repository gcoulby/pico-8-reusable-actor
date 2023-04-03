# Pico-8 Actor Class

This is a simple class for creating actors in Pico-8. It's a work in progress, I'm open to suggestions and improvements.

Pico-8 is a fantasy console for making, sharing and playing tiny games and other computer programs. It is developed by Lexaloffle Games. You can find out more about Pico-8 here: https://www.lexaloffle.com/pico-8.php

## Cart Info

![https://github.com/gcoulby/pico-8-reusable-actor/raw/main/reusable-actor.p8.png](https://github.com/gcoulby/pico-8-reusable-actor/raw/main/reusable-actor.p8.png)

|            | Used | Available | Percentage |
| :--------- | :--- | :-------- | :--------- |
| Tokens     | 1244 | 8192      | 15%        |
| Chars      | 4833 | 65535     | 7%         |
| Compressed | 1576 | 15616     | 10%        |

(this is just for the actor class, not the demo)

While this currently uses 15% of the available tokens, I intend to reduce this once I have finished the class. I also think that the size of class is acceptable given the functionality it provides. Admittedly, since this class supports multiple game types, it is a bit larger than it needs to be and could be pruned once it is applied to your game. If you have any suggestions on how to reduce the size of the class, please let me know. I'm open to suggestions.

I welcome Pull Requests and Issues on GitHub:

> https://github.com/gcoulby/pico-8-reusable-actor

## Features

☑️ Simple, easy to use

☑️ Configurable

☑️ Supports collision

☑️ Supports collision with map offsets

☑️ Supports sprite collections (multiple sprites per actor/animation)

☑️ Supports movement

☑️ Supports gravity

☑️ Supports jumping

☑️ Supports animations

☑️ Supports multiple animations

☑️ Supports multiple sprites

☑️ Supports top-down movement

☑️ Supports platformer movement

☑️ Supports sliding down walls

☑️ Supports collision with map tiles

☑️ Supports collision with window

> Collisions with other actors are not built into this class as it will be different for each game and even each actor. The intention would be that you would do this in your game's code.

---

## Helper Functions

> Before exploring the functions and properties of the actor class, it is important to understand the helper functions that are used by the actor class. These functions are used by the actor class to perform various tasks. They are not intended to be called directly. They are documented here for completeness.

### Get Flag for Map Tile

`fmget(x, y, f)`

This function is used to get the value of a flag from a map tile. It is used by the `chk_cols()` method. It should not be called directly. This function's primary purpose is to check to reduce the tokens used when checking collisions.

### Create Sprite Collection

`create_spr_col(sprites, flipX, flipY)`

This function is used to create a sprite collection for drawing actors that are bigger than 8px\*8px. A sprite collection is a table of sprites that are drawn to the screen. It is used by the `draw()` method. It should not be called directly.

The `sprites` parameter is a table of sprites. The sprites should be in the order that they should be drawn to the screen for example if your sprite sheet contains a 16px\*16px sprite for the actor standing still using sprites `0`, `1`, `16`, and `17` then the `sprites` table should look like this:

```lua
sprites = {
  {0, 1},
  {16, 17}
}
```

The `flipX` parameter is a boolean value that is used to flip the sprite horizontally. The `flipY` parameter is a boolean value that is used to flip the sprite vertically.

The flipX and flipY parameters flip the both the individually drawn sprites and the sprite collection as a whole. For example, if you use the above `sprites` table as an example, and you set `flipX` to `true` then the sprite collection will look like this:

With `flipX` set to `false`:
| | |
|:-|:-|
|0|1|
|16|17|

With `flipX` set to `true`:
| | |
|:-|:-|
|1|0|
|17|16|

This allows the sprite collection to be flipped horizontally without having to change the order of the sprites in the `sprites` table.

### Create Animation

`create_anim(spr_cols, delay)`

This function is used to create an animation for an actor. An animation is a table of sprite collections that are drawn to the screen. It is used by the `draw()` method. It should not be called directly.

The `_spr_cols` parameter is a table of sprites and is passed into the function in the same format as the `create_spr_col()` function. However, the `_spr_cols` parameter is a table of sprite collections, where the each element in the table is a sprite collection. The example below shows the animation for the wall slide animation used in the platformer demo:

````lua

```lua
_spr_cols = {
    {{6,7},{22,23}},
    {{8,9},{24,25}},
    {{10,11},{26,27}},
    {{12,13},{28,29}},
    {{14,15},{30,31}}
}
````

Each row is a sprite collection that represents a frame of the animation. The first sprite collection in the table is the first frame of the animation, the second sprite collection is the second frame of the animation, and so on. The `delay` parameter is the delay between frames of the animation. It is used to control the speed of the animation.

> This function should not be called directly. It is used by the `add_anim()` method.

### MAP_X and MAP_Y

This actor class requires MAP_X and MAP_Y to be defined. These are the x and y offsets of the map.

---

## Usage

Now that we have explored the helper functions, let's explore the actor class.

To use the class, simply copy the contents of `actor.lua` into your cartridge or add `#include actor.lua` to your cartridge. Then, create a new actor by calling `actor:new()` and passing in the configurable parameters.

It is recommended to use comment blocks to show what each parameter does. This is what I use in this example:

```lua
p = actor:new(
--[[x]]59,
--[[y]]59,
--[[w]]8,
--[[h]]8,
--[[flipX]]false,
--[[flipY]]false,
--[[dx]]0,
--[[dy]]0,
--[[max_dx]]2,
--[[max_dy]]3,
--[[max_jumps]]1,
--[[acc]]0.5,
--[[boost]]6,
--[[grav]]0.2,
--[[fric]]0.6,
--[[cm]]true,
--[[cw]]true,
--[[slide]]false,
--[[game_type]]type.side
)
```

You should declare animations after creating the actor. This is done by calling `p.add_anim()` and passing in the animation name and the sprite indexes. See [Add Animations](#add-animations) and [Create Animation](#create-animation) for more details on how they work.

The name is used to identify the animation. The sprite indexes are used to identify the sprites used for the animation. The last parameter is the speed of the animation. The higher the number, the slower the animation.

There are five animations declared by default in the Actor class' constructor code: `idle`, `walk`, `jump`, `fall`, and `slide`. You can change these by calling `p.set_anim()` and passing in the animation name. See [Set Animation](#set-animation) for more details on how it works. These are declared in the constructor code as follows to protect against errors:

```lua
o.anims={
    ["idle"]=create_anim({{{0}}},1),
    ["run"]=create_anim({{{0}}},1),
    ["jump"]=create_anim({{{0}}},1),
    ["fall"]=create_anim({{{0}}},1),
    ["slide"]=create_anim({{{0}}},1)
}
```

You should declare overrides to these follows:

```lua
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
```

You can also add new animations by calling `p.add_anim()` and passing in the animation name and the sprite indexes.

---

## Parameters

### x, y, w, h

These are the starting x and y coordinates of the actor, as well as the width and height of the actor. The width and height are used for collision detection.

### flip_x, flip_y

These are used for flipping the actor. Set them to `true` to flip the actor on the X or Y axis.

### dx, dy

These are the x and y velocities of the actor. They are used for movement.

### max_dx, max_dy

These are the maximum x and y velocities of the actor. They are used for movement.

### max_jumps

This is the maximum number of jumps the actor can perform. It is used for platformer movement. Set it to 0 for no jumps. Set it to -1 for infinite jumps. Set it to 1 for single jumps. Set it to 2 for double jumps, etc.

### acc

This is the x-axis acceleration of the actor. It is used for movement.

### boost

This is the jump speed of the actor. It is used for movement.

### grav

This is the amount of gravity acting upon the actor. It is used for gravity.

### fric

This is amount of friction acting upon the actor. It is used for movement.

### cm, cw

These are used for collision detection. `cm` is used for collision with map tiles, and `cw` is used for collision with window.

### slide

This is used for collision detection. It is used for sliding down walls.

### type

This is used for movement. It can be set to `type.side` for platform movement, `type.top` for top-down movement.

## Methods

### Update

`update()`

This method is used to update the actor. It should be called in the `_update()` function or the `_update60()` function.

The `_update()` function is called 30 times per second, and the `_update60()` function is called 60 times per second. The current demo uses the `_update()` so that you can see the animations more clearly. However, you can use `_update60()` if you want. You just need to configure the movement parameters accordingly to make it feel right.

### Draw

`draw()`

This method is used to draw the actor. It should be called in the `_draw()` function.

### Move X

`moveX()`

This method is used to move the actor horizontally. It should be called in the `_update()` function or the `_update60()` function.

### Move Y

`moveY()`

This method is used to move the actor vertically. It should be called in the `_update()` function or the `_update60()` function.

### Jump

`jump()`

This method is used to make the actor jump. It should be called in the `_update()` function or the `_update60()` function.

### Apply Forces

`apply_forces()`

This method is used to apply gravity and friction to the actor. It also contains the code for sliding down walls. It should not be called directly.

### Check Collisions

`chk_cols()`

This method is used to check for collisions. It is used by the `moveX()` and `moveY()` methods. It should not be called directly. This method checks to see if the resulting movement will cause a collision. The `moveX()` and `moveY()` methods will then adjust the movement accordingly.

### Check Ground

`chk_gnd()`

This method is used to check if the actor is on the ground. It is used by the `moveY()` method. It should not be called directly. This method checks to see if the actor is on the ground.

### Check Ceiling

`chk_ceil()`

This method is used to check if the actor is on the ceiling. It is used by the `moveY()` method. It should not be called directly. This method checks to see if the actor is touching the ceiling.

### Check Wall

`chk_wall()`

This method is used to check if the actor is touching a wall. It is used by the `moveX()` method. It should not be called directly. This method checks to see if the actor is touching a wall. This method is also used by the `apply_forces()` method to check if the actor is sliding down a wall.

### Get Coordinate

`get_coord(lc, c)`

This method is used to get the coordinate of the actor in the event of a collision. It is used by the `moveX()` and `moveY()` method. It should not be called directly.

lc is the last coordinate of the actor. It is the coordinate of the actor before the movement.

c is the current coordinate of the actor. It is the coordinate of the actor after the movement.

This method returns the coordinate of the actor in the event of a collision.

### Add Animations

`add_anim(name, spr_cols, d)`

This method is used to add an animation to the actor. It should be called in the `_init()` function.

name is the name of the animation. It is used to identify the animation.

d is the delay between frames of the animation. It is used to control the speed of the animation.

spr_cols is a table of sprite collections. See the [Create Animation](#create-animation) section for more information.

---

## Demo

There is a demo included in the repository. It is a simple platformer with an actor and a map. You can configure the parameters from within pico-8 to see how they work.

## License

This project is licensed under the CC-BY-NCSA 4.0 license. See the LICENSE file for more information.

---

## References

To learn the component parts of this class, I used the following resources:

### Simple Collision

[1] https://www.lexaloffle.com/bbs/?tid=3116 by [Scathe](https://www.lexaloffle.com/bbs/?uid=12235)

### Gravity

[2] https://www.youtube.com/watch?v=wg2l0y6cvNY by [@Vinull](https://twitter.com/vinull)

### Map Collision

[3] https://www.youtube.com/watch?v=Gs0XFViFxFs by [@DocRobsDev](https://twitter.com/DocRobsDev)

### Animated Sprites

[4] https://pixelfrog-assets.itch.io/pixel-adventure-2 by [Pixel Frog](https://pixelfrog-assets.itch.io/)

# Pico-8 Actor Class

This is a simple class for creating actors in Pico-8. It's a work in progress, I'm open to suggestions and improvements.

Pico-8 is a fantasy console for making, sharing and playing tiny games and other computer programs. It is developed by Lexaloffle Games. You can find out more about Pico-8 here: https://www.lexaloffle.com/pico-8.php

## Cart Info

|            | Used | Available | Percentage |
| :--------- | :--- | :-------- | :--------- |
| Tokens     | 816  | 8192      | 10%        |
| Chars      | 3216 | 65535     | 5%         |
| Compressed | 1194 | 15616     | 8%         |

(this is just for the actor class, not the demo)

While this currently uses 11% of the available tokens, I intend to reduce this once I have finished the class. I also think that the size of class is acceptable given the functionality it provides. Admittedly, since this class supports multiple game types, it is a bit larger than it needs to be and could be pruned once it is applied to your game. If you have any suggestions on how to reduce the size of the class, please let me know. I'm open to suggestions.

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

⬛ Supports collision with sprites

⬛ Supports collision with actors

---

## Usage

To use the class, simply copy the contents of `actor.lua` into your cartridge or add `#include actor.lua` to your cartridge. Then, create a new actor by calling `actor:new()` and passing in the configurable parameters.

It is recommended to use comment blocks to show what each parameter does. This is what I use in this example:

```lua
p = actor:new(
--[[x]]59,
--[[y]]59,
--[[w]]8,
--[[h]]8,
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

This actor class requires MAP_X and MAP_Y to be defined. These are the x and y offsets of the map.

---

## Parameters

### x, y, w, h

These are the starting x and y coordinates of the actor, as well as the width and height of the actor. The width and height are used for collision detection.

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

### \_type

This is used for movement. It can be set to `type.side` for platform movement, `type.top` for top-down movement.

## Methods

### update()

This method is used to update the actor. It should be called in the `_update()` function or the `_update60()` function.

The `_update()` function is called 30 times per second, and the `_update60()` function is called 60 times per second. The current demo uses the `_update60()` function and I find it to be the best option. However, you can use `_update()` if you want, then you just need to configure the movement parameters accordingly to make it feel right.

### draw()

This method is used to draw the actor. It should be called in the `_draw()` function.

### moveX()

This method is used to move the actor horizontally. It should be called in the `_update()` function or the `_update60()` function.

### moveY()

This method is used to move the actor vertically. It should be called in the `_update()` function or the `_update60()` function.

### jump()

This method is used to make the actor jump. It should be called in the `_update()` function or the `_update60()` function.

### apply_forces()

This method is used to apply gravity and friction to the actor. It also contains the code for sliding down walls. It should not be called directly.

### chk_cols()

This method is used to check for collisions. It is used by the `moveX()` and `moveY()` methods. It should not be called directly. This method checks to see if the resulting movement will cause a collision. The `moveX()` and `moveY()` methods will then adjust the movement accordingly.

### chk_gnd()

This method is used to check if the actor is on the ground. It is used by the `moveY()` method. It should not be called directly. This method checks to see if the actor is on the ground.

### chk_ceil()

This method is used to check if the actor is on the ceiling. It is used by the `moveY()` method. It should not be called directly. This method checks to see if the actor is touching the ceiling.

### chk_wall()

This method is used to check if the actor is touching a wall. It is used by the `moveX()` method. It should not be called directly. This method checks to see if the actor is touching a wall. This method is also used by the `apply_forces()` method to check if the actor is sliding down a wall.

### get_coord(lc, c)

This method is used to get the coordinate of the actor in the event of a collision. It is used by the `moveX()` and `moveY()` method. It should not be called directly.

lc is the last coordinate of the actor. It is the coordinate of the actor before the movement.

c is the current coordinate of the actor. It is the coordinate of the actor after the movement.

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

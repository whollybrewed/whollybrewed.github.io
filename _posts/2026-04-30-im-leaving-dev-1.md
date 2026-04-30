---
draft: false
layout: post
title: "Devlog #1: I'm Leaving"
date: 2026-04-30
categories: game-development
---
This is the first devlog of my game: _I'm Leaving_. It is still a working title before
something better pops up. In short, this game is a crossover between retro minesweeper
game and 2D top-down shooter. As the title suggests, the player is trapped in a field of
landmines and adversaries. The objective is simple: leaving the scene alive.

The game is written in Lua using Löve, aka love2d, engine. I'm new to Lua and a very
novice game developer.

### 0.1.0-alpha.1
Adding basic Player[^1] object with WASD movement, jumping, and shadow. Camera follows the Player.
The World is just a grid; plain and boring.

[^1]: Henceforth, capitalized words indicate class objects.

![0.1.0-alpha.1-demo]({{ site.baseurl }}/assets/images/im-leaving/0.1.0-alpha.1-demo.gif)

### 0.2.0-alpha.1
Trail of footprints added. Player now has a visual record of the trodden grids. I added a small delay
for the appearance of the footprint after Player has entered a grid so that it feels more natural as if
the Player "leaves the tracks behind".

Corsshair is added too. It follows the mouse cursor. The grid aimed by the Crosshair will have
visual highlight.

![0.2.0-alpha.1-demo]({{ site.baseurl }}/assets/images/im-leaving/0.2.0-alpha.1-demo.gif)

### 0.3.0-alpha.1
Finally adding landmines to a minesweeper-theme game. Landmines are attribute of World.
For now the random function follows uniform distribution. The numbers which indicate nearby
mines are computed on-the-fly rather than being precalculated. This is because later on I want
to experiment with the abilities to destroy mines (by the Player) and to bury new mines
(by the adversaries).

When Player steps on a mined grid (marked by 'X'), they will be blown up. The fly-off mechanism is
the same as jumping, but slightly higher and in a random direction. So essentially being
blown up is an involuntary jump. To make things simple, voluntary and involuntary jumps are mutually
exclusive. Until now I haven't really use the physics engine offered by love2d, since I decided with
myself, that, unless I need all three Newton's laws of motion and beyond, a physics engine is probably
too overkill for me.

By the way starting from this update I flip the background to dark color, simply because sometime I
work on the game at night and that makes it better for the eyes.

![0.3.0-alpha.1-demo]({{ site.baseurl }}/assets/images/im-leaving/0.3.0-alpha.1-demo.gif)

### 0.4.0-alpha.3
Bullet is added in this update. For obvious reason Bullet is going to be a very finite resource. The
bullet trajectory physics is highly simplified. The bullets always travel in constant velocity,
unaffected by Player's motion, height, or the gravity. And the bullets will always reach the grid at
which the Crosshair aims when the mouse is clicked.

![0.4.0-alpha.3-demo]({{ site.baseurl }}/assets/images/im-leaving/0.4.0-alpha.3-demo.gif)

That's all the updates. Thanks for your curiosity!

---
draft: false
layout: post
title: "Devlog #3: I'm Leaving, Offense/Defense"
date: 2026-10-11
categories: game-development
---

From The Offspring's 1998 single
[*The Kids Aren't Alright*](https://youtu.be/7iNbnineUCI?si=DO4jFsMdz2_uJoZS):
<figure>
  <img src="{{ site.baseurl }}/assets/images/im-leaving/the_offspring.jpg"
       alt="The Offspring – The Kids Aren't Alright"/>
</figure>

> And Brandon OD'd and died (Woah-oh)  
> What the hell is going on?  
> Cruelest dream, reality

This time, we're going to talk about a different kind of OD, not Over-Dosed,
but **Offence/Defense**, a mechanic at the heart of most action games and, for
many players, the "cruelest dream, reality".


<details markdown="1">
<summary><strong>Articles in the series</strong></summary>

- [Devlog #1: I'm Leaving]({% post_url 2026-04-30-im-leaving-dev-1 %})
- [Devlog #2: I'm Leaving, Jump!]({% post_url 2026-06-07-im-leaving-dev-2 %})
- [Devlog #3: I'm Leaving, Offense/Defense]({% post_url 2026-10-11-im-leaving-dev-3 %})

</details>

---

### 0.6.0-alpha.2
#### Defense

As the second weapon type alongside the pistol, the shotgun fires three bullets
at once, each landing randomly within a 3×3 grid centered on the crosshair.
The bullets always land in front of the Player, so at close range, the spread is
reduced to a 3×2 grid, as the remaining 3×1 section is behind the Player.
This effectively increases the accuracy at close range.

<video
  style="width: 100%; max-width: 720px; height: auto;"
  controls
  autoplay
  muted
  loop
  playsinline
>
  <source src="{{ '/assets/videos/im-leaving/0.6.0-alpha.2-demo.mp4' | relative_url }}" type="video/mp4">
  Your browser does not support the video tag.
</video>

### 0.12.0-alpha.1
#### Offense

Between `v0.7.0` to `v0.11.0`, the changes are primarily related to menu, setting
page, animation, ...and so on, which we will use another time to discuss. For
now, we fast-forward to Enemy offense, a topic about pathfinding.

The pathfinding algorithm in this game is inspired by Professor David Churchill's
course [COMP 4303: AI for Video Games](https://davechurchill.ca/teaching/),
specifically the *Lecture 06 - Grid Algorithms*.

First, a Breadth-First Search (BFS) distance field is constructed to compute
the [Chebyshev distance](https://en.wikipedia.org/wiki/Chebyshev_distance)
from every grid cell to the player. After that, an overlay of *influence map*
is constructed, based on the equation:


$$
I(c) = M(c) + \min(N(c) \cdot E, E_{\max})
$$

Where:

- $c$: The grid cell being evaluated.
- $I(c)$: Total influence cost of cell $c$.
- $M(c)$: Mine penalty at cell $c$.
- $N(c)$: Number of enemies occupying cell $c$.
- $E$: Crowd cost per enemy.
- $E_{\max}$: Maximum crowd penalty.

I'm a believer of that enemy should be able to make mistakes just like the player,
and that's why a mine-buried cell is a penalty rather than being treated as a blocked
path. Stepping in to it is discouraged, but never impossible. As for the crowd penalty,
I want to emulate the tactic that the enemies spread out and surround the player,
as opposed to all converging on the optimized path.

In the demo clip below, the calculated overall score (BFS distance +
influence score) is displayed on each cell. The 1000+ orange scores are the
landmines.

<video
  style="width: 100%; max-width: 720px; height: auto;"
  controls
  autoplay
  muted
  loop
  playsinline
>
  <source src="{{ '/assets/videos/im-leaving/0.12.0-alpha.1-demo-1.mp4' | relative_url }}" type="video/mp4">
  Your browser does not support the video tag.
</video>

As a result, a vector field can be constructed in which each vector points toward
the neighboring cell with the lowest transition score.

<video
  style="width: 100%; max-width: 720px; height: auto;"
  controls
  autoplay
  muted
  loop
  playsinline
>
  <source src="{{ '/assets/videos/im-leaving/0.12.0-alpha.1-demo-2.mp4' | relative_url }}" type="video/mp4">
  Your browser does not support the video tag.
</video>

An advantage of using a vector field over individual pathfinding algorithms such
as A* or Dijkstra's is that the field is a shared global navigation state. This
makes it particularly suitable for a swarm of enemies, since the computational cost
scales well as the number of enemies increases.

That said, each enemy in the game still maintains its own local state for
backtracking prevention (so that they don't swing back and forth between two cells,
as if hesitating) and physical overlap resolution. However, these operations
are considerably cheaper than computing a separate path across the entire map.

And that concludes the updates for this time. Thanks for your curiosity!

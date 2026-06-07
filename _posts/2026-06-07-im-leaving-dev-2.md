---
draft: false
layout: post
title: "Devlog #2: I'm Leaving, Jump!"
date: 2026-06-07
categories: game-development
---
In this dev log, I'll walk through some of the visual aids that have been added
to improve the development experience, along with the new jumping actions
available to Player.

<details markdown="1">
<summary><strong>Articles in the series</strong></summary>

- [Devlog #1: I'm Leaving]({% post_url 2026-04-30-im-leaving-dev-1 %})
- [Devlog #2: I'm Leaving, Jump!]({% post_url 2026-06-07-im-leaving-dev-2 %})

</details>

---

### 0.5.0-alpha.2
#### The Explosions

In the previous versions landmines were simply marked as 'X' when being shot at
or stepped on. I quickly realized that it wasn’t very intuitive when showing the
demo to others. To better portray the idea to potential collaborators and
testers, I decided to add a graphic placeholder to indicate when a landmine
has been ignited.

![0.5.0-alpha.2-demo-1]({{ site.baseurl }}/assets/images/im-leaving/0.5.0-alpha.2-demo-1.gif)

#### The Jumps

Player now can do a double or a triple jump, intended as an unlockable skill/technique
in the full game. While these mechanics are common in action games, the idea which inspired
me specifically was the [Qinggong (輕功)](https://en.wikipedia.org/wiki/Qinggong), an
agile gravity-defying movement in Chinese martial arts, reintroduced to modern
pop culture by Jin Yong through his [wuxia series](https://en.wikipedia.org/wiki/Jin_Yong#Series)
during the 50s to 70s.


![0.5.0-alpha.2-demo-2]({{ site.baseurl }}/assets/images/im-leaving/0.5.0-alpha.2-demo-2.gif)

---

Another jumping technique I implemented is the “precise jump”. It is
designed to be used in combination with the triple jump. After performing a
triple jump, Player has a short time window near the peak to execute a
precise jump to some grid position within a defined range. Activation readiness is
indicated by the crosshair color changing from red to green.

![0.5.0-alpha.2-demo-3]({{ site.baseurl }}/assets/images/im-leaving/0.5.0-alpha.2-demo-3.gif)

The animation of the precise jump is of course just a visual placeholder at the
moment. The sequence, starting with a thrust charge (indicated by the player blinking),
followed by a linear acceleration toward the target grid, is heavily inspired by
the [warp drive](https://en.wikipedia.org/wiki/Warp_drive) from the Star Trek series.
In particular, the charging and thrust aesthetics aim to emulate the USS Enterprise
in _Star Trek: The Next Generation_.


![star-trek-tng-warp]({{ site.baseurl }}/assets/images/im-leaving/star-trek-tng-warp.gif)

That’s all the updates. Thanks for your curiosity!

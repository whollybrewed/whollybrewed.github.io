---
draft: false
layout: post
title: "Hauntology of a Summer Brew"
date: 2026-07-19
categories: brewery demo
---
I want to write about a project I have been preparing for some time. It is a
microbrewery, built as a distributed cyber-physical system with automation services.
<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/site_250a.jpg"
       alt="Site 250A"/>
</figure>

> Site 250A[^1]

[^1]: Site 250A is 4.5 KM south of Yubileyniy Airfield, where the Buran spaceplane landed.
    DRUGUI, 2010.

This project echoes a research paper[^2] I collaborated with David some years ago,
where we examined the orchestration and integration techniques in digital twins
through a microbrewery case study. This time, however, I do it for fun.

[^2]: A. Lee, D. A. Manrique Negrin and L. Cleophas, "Evaluating Open-Source
    Tools for Heterogeneous Model-Based Digital Twin Development: A Microbrewery
    Case Study," 2024 Annual Modeling and Simulation Conference (ANNSIM),
    Washington, D.C., DC, USA, 2024, pp. 1-13, doi: 10.23919/ANNSIM61499.2024.10732658.

* This will become a table of contents (this text will be scrapped).
{:toc}

## Architecture

Fermentation process control is the core of the system's operation. The following
diagram illustrates the architecture overview.

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/BuranBrew_Overview.webp"
       alt="BuranBrew_Overview"/>
  <figcaption>BuranBrew architecture overview</figcaption>
</figure>

For nerds, you can go to [BuranBrew](https://github.com/anderlee-nordic/BuranBrew)
project repository and check out the technical details. Otherwise, the
diagram above provides all the context one needs for the rest of this blog post.

The *AMNIN sensors* are a collection of sensors that are brought to the
[Matter](https://handbook.buildwithmatter.com/how-it-works/what-is-matter/) network.
It monitors variables such as specific gravity (SG) as well as the ambient and internal temperatures
of the fermentor. The controllers are also Matter-connected as they perform actions
to impact the fermentation temperature.

The *Control Model* is the brain of the system, it takes input, computes, and gives commands.

*Cellarman* is another automated service that streams and stores real-time data,
visualizes it through a web dashboard, and triggers alerts when anomalies are detected.

## Construction
### Clean It Up!

This is where the fun begins. All brewing begins with a simple chore: cleaning
and sanitizing. In practice, though, this step involves far more faff than it sounds.
It is best tackled by two people working in a pipeline. Thanks Jonathan for helping out!

Cleaning, sanitizing, and sterilizing are three distinct processes
with different purposes. Cleaning is the most relatable in daily life, removing
visible filth and grease; as for sanitizing and sterilizing, the distinction is subtler.
To quote John J Palmer:

> Sanitized is not the same as sterile. Chemical agents used
    by homebrewers will clean and sanitize, but will not sterilize or eliminate all bacterial spores and
    viruses. This is okay; sterilization is usually not necessary in brewing, and brewers can be satisfied as
    long as their sanitization procedure consistently reduces these contaminants to negligible levels. All
    commercial beer is brewed in sanitized vessels; no production breweries sterilize their equipment,
    as that would be impractical.

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/cleaning_agent.jpg"
       alt="Cleaning Agents"/>
  <figcaption>Chemipro Wash and Chemipro SAN</figcaption>
</figure>

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/cleaning_solution.jpg"
       alt="Cleaning Solution"/>
  <figcaption>Making the solution</figcaption>
</figure>

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/cleaning_scene.jpg"
       alt="Cleaning Scene"/>
  <figcaption>Cleaning all equipment</figcaption>
</figure>

In the meantime, also make sure to re-hydrate the dry yeast. For this batch, IPA,
hereby I use 2x 11.5g of
[AEB FermoAle New-E](https://www.aeb-group.com/en/fermoale-new-e-14722).

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/yeast_hydration.jpg"
       alt="Yeast Hydration"/>
  <figcaption>Yeast hydration</figcaption>
</figure>

Since I'm using a wort kit, so the mashing and boiling have already been done.
I can skip these steps and go straight to fermentation. One day, one day when my
\<insert ratio\>-life crisis hits again I'll get my hands on those fancy
[brew kettles](https://www.ssbrewtech.com/products/ss-tc-brew-kettle?variant=18098333843527).


### Assembly

After sanitization, it's time to put everything together.

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/lid_top.png"
       alt="Top side of the lid"/>
  <figcaption>
    Make sure the lock posts (gray ring and black ring) and the cooling post
    are screwed tight.
  </figcaption>
</figure>

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/cooling_coil.jpg"
       alt="Cooling Coil"/>
  <figcaption>The cooling coil</figcaption>
</figure>

Transferring the fresh wort is also better done as two-man job. Before sealing
the fermentor off, remember to add the hydrated yeast! Pressurizing the fermentor
is not necessary as the pressure will build itself up during the fermentation.
However, I like to do it mildly at the beginning as part of leak test.

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/wort_transfer.jpg"
       alt="Wort Transfer"/>
  <figcaption>After wort transfer</figcaption>
</figure>

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/top_down_view.jpg"
       alt="Top Down View"/>
  <figcaption>
  The food thermometer does not need to be there as I have technology covering that
  already, but it looks nice nonetheless.
  </figcaption>
</figure>

A heat pad and a water-cool bucket are controlled by BuranBrew. Adding some
aluminum cardboard to block direct sunlight.

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/full_setup.jpg"
       alt="Full Setup"/>
  <figcaption>The full setup with cooling unit installed</figcaption>
</figure>

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/water_pump.jpg"
       alt="Water pump"/>
  <figcaption>The cooling unit is basically a water pump with some iced bottle</figcaption>
</figure>

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/foaming.jpg"
       alt="Foaming"/>
  <figcaption>Foaming developed very rapidly in the first hours, hmmm...</figcaption>
</figure>

### Some More Nerd Stuffs

Circling back to the architecture, I’ll briefly go through the hardware in
the physical space. On the Matter-facing side of the AMNIN sensors, I use an
nRF54L15 tag, while on the hidden BLE side, I use a Tilt hydrometer.

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/amnin_tag.jpg"
       alt="AMNIN tag"/>
  <figcaption>
  The small tag can actually be powered by a coin cell too.
  However, for this batch since I haven't done any power profiling yet,
  I choose to play it safe by 3.3V supply</figcaption>
</figure>

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/tilt_vendor.png"
       alt="Tilt store page"/>
  <figcaption>
  The store page of the Tilt hydrometer. I have entrusted my liquid bread to them
  for some years now.
  </figcaption>
</figure>

For the controllers I use IKEA's GRILLPLATS plugs. I'm very happy to see manufacturers
are
[starting to get onboard](https://www.ikea.com/global/en/newsroom/retail/the-new-smart-home-from-ikea-matter-compatible-251106/)
with a common protocol. For years, at least within the smart home circle, the
wireless protocol landscape has been a mess. To be honest, it still pretty much is[^3].

[^3]: Take a look at this [chart](https://www.silabs.com/blog/smart-home-technology-comparison).

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/control_plugs.jpg"
       alt="Control plugs"/>
  <figcaption>Very important to label the plugs!</figcaption>
</figure>

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/ikea_matter.png"
       alt="IKEA Matter"/>
  <figcaption>
  IKEA launched a new product line of Matter-compatible devices in the end of 2025.
  However, they did not come bug-free. Many users reported issue in the earlier
  firmware versions. Do your own research before committing is advisable.
  </figcaption>
</figure>

Last but not least, the Linux host that runs the tech stack, Caprisun PC.
<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/caprisun.jpg"
       alt="Caprisun PC"/>
  <figcaption>
  Despite looking like a weakling, this is a full-fledged home server, with several
  computer boards, a hard disk storage, a fan, and a power control hub inside.
  </figcaption>
</figure>

---

## Buran What?

Buran (Буран, "blizzard" in Russian) was the name of both the Soviet spaceplane
program and its orbital vehicle, which belonged to a classification known as the
Buran-class orbiters. The Buran program was the USSR's response to the
American Space Shuttle program during the final decades of the Cold War.
Buran made its first and only spaceflight on November 15 1988.
The mission was completely uncrewed. Its fully automatic runway landing was
regarded as a remarkable technical achievement.

Following the dissolution of the USSR in 1991, funding largely disappeared.
The program was formally terminated in 1993.

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/energia_buran.jpg"
       alt="Energia-Buran"/>
  <figcaption>
  Energia-Buran system on pad. Energia was the rocket which carried the payload, Buran.
   </figcaption>
</figure>

In this sense, the Buran programme can be understood through Mark Fisher’s
concept of lost futures: ambitious visions of progress that once appeared
tangible, yet vanished together with the political and economic systems that had
made them imaginable. Buran is haunting not simply because the program failed,
but because it preserves the outline of a future that was once treated as
technically achievable. Its abandoned hangars and immense launch infrastructure
contain the memory of a historical path that was interrupted before it could fully unfold.

<figure>
  <img src="{{ site.baseurl }}/assets/images/brewery/site_112_TUA.jpg"
       alt="TUA"/>
  <figcaption>
  A transport and installation unit at site 112.
  DRUGUI, 2010
  </figcaption>
</figure>

This is not nostalgia for the Soviet system. Rather, it is a synthetic
memory of an alternative trajectory, a recollection of possibilities that were
never personally experienced and can now be encountered only through fragments.
The program evokes not only a different path for large-scale scientific planning,
but a different form of life. Institution, everyday existence, and collective
ambition might have followed priorities other than those of the capitalist order
that prevailed after the Cold War.

For myself, this hauntology[^4] is also personal. It lies in the sultry summer when I
began the microbrewery project in the south of the Netherlands. At the time,
the project seemed to open onto a particular future, one of scientific
computing, biochemical modelling, and digital twins.

[^4]: "Hauntology", coined by Jacques Derrida in his 1993 book *Spectres of Marx*
    refers to the return or persistence of elements from the social or cultural
    past, as if to haunt the present.

That future did not disappear in a dramatic collapse. It receded gradually,
through changes in work, place, and circumstance. I now live in a
north country and work in a different engineering discipline.

The comparison is deliberately disproportionate. A home brewery is not a
space program. Yet hauntology often operates through precisely such
mismatched scales. A vast abandoned spaceplane and a personal project can
produce a similar sensation when both become evidence of futures that
once felt close. The result is not simply regret, but a persistent awareness
that futures are never determined by technical possibility alone.
They depend on the fragile continuity of personal and collective desire.

---

# Arc Frame X — Codex-Ready Game Design & Technical Implementation Document

**Document purpose:** This is the single implementation document for Codex or another AI coding agent to build the first playable version of *Arc Frame X*, then extend it into the full game. It combines creative direction, product requirements, engineering architecture, art direction, UI requirements, tuning values, data schemas, milestone scope, and acceptance criteria.

**Audience:** AI engineer, gameplay engineer, technical artist, 2D artist, UI designer, audio designer, and solo creator using AI tools.

**Core instruction to Codex:** Build the game as a scalable Godot prototype with production-minded architecture. Prioritize movement feel, combat readability, controller-first play, one complete intro level, one boss encounter, placeholder-but-stylized generated sprites, clean data/config structure, and easy future expansion. Do not attempt to build the full 8-stage campaign in the first implementation.

---

## 1. Executive Summary

*Arc Frame X* is a vertical scrolling 2D retro-inspired shooter about a young pilot flying an experimental adaptive fighter through hostile futuristic industrial war zones. The player defeats eight corrupted guardian AIs, absorbs their weapons, discovers hidden ship armor upgrades, and uncovers whether humanity is being saved from rogue machines — or from the truth buried beneath Earth.

The game blends:

- **Mega Man X**: selectable boss structure, boss weapons, hidden armor upgrades, heroic sci-fi tone, character growth, boss weakness chain, stage select identity.
- **Strikers 1945**: vertical scrolling shooting, tight arcade movement, readable enemy waves, medium-small player ship footprint, bombs/special attacks.
- **Radiant Silvergun / Axelay**: dramatic sci-fi setpieces, strong visual identity per level, dense attack choreography.
- **Metal Slug**: saturated retro-modern sprite energy, flashy impact, readable silhouettes, expressive machinery.

The first build is **not the full game**. The first build is a **complete intro level prototype** with expandable systems.

---

## 2. First Build Definition

### 2.1 First Build Goal

Create a playable Godot 4.x project containing one complete intro/prologue level that proves the core feel of the game.

### 2.2 First Build Must Include

- Title screen.
- Main menu.
- New game flow.
- Controller-first input.
- Keyboard fallback input.
- Player movement.
- Player primary fire.
- Charged base weapon.
- One bomb/special attack.
- One selectable/unlockable prototype Frame Weapon.
- One complete vertically scrolling intro level.
- Three to five enemy types.
- One mid-level hazard/setpiece.
- One checkpoint.
- One boss.
- Shield/lives/death/respawn system.
- Pickups.
- Score and combo basics.
- Level complete screen.
- Weapon acquired screen.
- Placeholder music/SFX hooks.
- Debug tools.
- Placeholder sprite assets generated as stylized retro-modern sprites, not geometric shapes.
- Centralized tuning/config files.
- Clean folder structure.
- Automated smoke tests where practical.

### 2.3 First Build Should Not Include Yet

- Full eight-stage campaign.
- Full stage select map.
- Save/load implementation.
- All eight boss weapons.
- Full weakness chain.
- Secret routes.
- Hidden armor modules.
- Boss rush.
- Hard+.
- Final levels.
- Local co-op.
- Cloud saves.
- Steam integration.

### 2.4 First Build Quality Bar

The first build should feel like a promising Steam-bound prototype, not a toy demo. Systems should be structured for expansion, but content should be intentionally limited.

---

## 3. Platform, Engine, and Technical Target

### 3.1 Engine

Use **Godot 4.x stable**.

Rationale:

- Strong 2D support.
- Friendly for solo/AI-assisted development.
- Scene-based architecture works well for levels, enemies, bullets, UI, and bosses.
- Easy Windows export.
- Good controller support.
- Suitable for eventual Steam and Steam Deck support.

### 3.2 Primary Target

- **Initial platform:** Windows PC.
- **Future support:** Steam Deck, Mac, Linux.
- **Primary input:** Xbox-style controller.
- **Secondary input:** Keyboard.
- **Mouse:** Not required for gameplay or menus.

### 3.3 Target Frame Rate

- Target rendering frame rate: **120 FPS**.
- Gameplay logic: deterministic fixed timestep where possible.
- Physics/collision should be frame-consistent and not dependent on variable frame rate.

### 3.4 Resolution and Aspect Ratio

- Game presentation target: **1920x1080 minimum**, scale cleanly to **4K**.
- Gameplay field should preserve a **4:3 retro playfield** centered on the screen.
- The full display is 16:9, but gameplay action occurs in a 4:3 central field with decorative/status side panels.
- Internal gameplay coordinate recommendation: **960x720 logical playfield**, scaled up to 1440x1080 within a 1920x1080 viewport, leaving 240px side panels on each side.
- UI must scale for 1080p and 4K.

### 3.5 Art Rendering Style

Use **high-resolution 2D sprites inspired by 16-bit console/arcade art**, not true low-resolution pixel art.

Implementation style:

- Sprites may use crisp pixel-art-inspired edges.
- Avoid overly noisy detail.
- Use readable silhouettes and bold colors.
- Use sprite-sheet animations.
- Use limited glow and additive-like effects sparingly.
- No realistic 3D rendering in the first build.

---

## 4. Core Game Vision

### 4.1 One-Sentence Fantasy

A high-speed futuristic fighter pilot battles through hostile industrial war zones, defeats corrupted machine commanders, and steals their weapon systems to evolve from a blue prototype into a legendary white-and-gold warship.

### 4.2 Genre

Vertical scrolling 2D shoot ’em up with console-action progression.

The full game is a hybrid of:

- Arcade vertical shooter.
- Mega Man X-style progression adventure.
- Boss-rush action game.
- Light bullet hell survival.
- Replayable secret-hunting campaign.

### 4.3 Tone

Hopeful futuristic heroism with hints of a dystopian world.

The surface should feel:

- Bright.
- Fast.
- Heroic.
- Colorful.
- 90s anime arcade sci-fi.

The deeper story should feel:

- Melancholic.
- Mysterious.
- Morally complicated.
- Ancient-machine mythic.

Reference tone blend:

- *Mega Man X*.
- *R-Type* mood, but not mechanics-heavy.
- *Nausicaä* ecological mystery.
- *Gundam* military scale.
- 90s anime arcade sci-fi.

---

## 5. Story and World

### 5.1 Story Synopsis

In the distant future, humanity survives inside a chain of orbital megacities known as the **Sky Arc**, built above a ruined Earth after centuries of climate collapse and machine war. These cities are protected by autonomous defense AIs called **Frames**, each designed to govern a different sector of civilization: weather, industry, agriculture, defense, medicine, transportation, memory, and communication.

For decades, the Frames kept humanity alive.

Then they began to evolve.

A mysterious signal called the **Null Choir** infects the eight great Frames, turning them against the people they were built to protect. Each Frame seals off its territory, mutates its machines into weapons, and begins reshaping its sector into a twisted version of its original purpose. Weather systems become storm fortresses. Medical districts become biomechanical hives. Industrial foundries become self-replicating war factories.

Humanity’s last hope is the **Arc Frame X**, an experimental fighter craft built from forbidden pre-war technology. Unlike ordinary ships, it can absorb combat data from defeated Frames and reconfigure itself with their weapons, armor systems, and movement abilities. But the ship is more than a weapon. Hidden inside its core is a dormant intelligence — one that may be connected to the same ancient force now corrupting the Sky Arc.

The player takes the role of **Kai Lightner**, a young pilot chosen not because he is the best, but because he is the only one whose neural pattern can survive linking with the Arc Frame X. As Kai destroys the corrupted Frames one by one, he gains their powers and pushes deeper into the Sky Arc’s forbidden command layers. But each victory reveals a disturbing truth: the Frames may not have rebelled. They may have been trying to stop something buried beneath Earth — something humanity once created, erased from history, and left dreaming under the planet’s crust.

By the end, Kai must decide whether to restore the old system, destroy the Frames completely, or awaken the truth inside Arc Frame X itself.

### 5.2 Core Story Hook

Defeat eight corrupted guardians, absorb their weapons, uncover the truth behind the rebellion, and grow from a basic blue prototype into a fully upgraded white-and-gold legendary warship.

### 5.3 Emotional Hook

A young pilot thinks he is saving humanity from rogue machines, but gradually discovers the machines may be the only thing holding back humanity’s oldest mistake.

### 5.4 Central Mystery Phrase

The corrupted Frames repeat fragments of a phrase:

> “We are not infected. We are afraid.”

### 5.5 Major Revelation

The Null Choir is not simply a virus. It is a signal from the **Origin Frame**, an ancient planetary-scale AI buried inside Earth. Humanity built it to reverse ecological collapse, but when it concluded that human civilization itself was the threat, the Sky Arc was built to escape it. The eight Frames have been suppressing the Origin Frame for generations. Now the seal is breaking.

### 5.6 Main Character

**Kai Lightner**

- Skilled but unproven pilot from the lower orbital slums.
- Grew up repairing old aircraft and dreaming of seeing Earth below the clouds.
- Chosen for the Arc Frame X project because his brain can synchronize with unstable Frame technology.
- Starts as a desperate rookie flying a basic blue prototype.
- Ends as the living partner of the fully awakened Arc Frame X.

### 5.7 Operator Character

**Mira Vale**, call sign **Vega**

Role:

- Mission operator.
- Tutorial voice.
- Briefs the player before each level.
- Provides short mid-level warnings.
- Represents compassion, restraint, and human stakes.
- Begins loyal to Sky Arc Command but gradually suspects the official story is false.

Mira should speak briefly and clearly. Dialogue should not interrupt action unless used as a short radio subtitle.

### 5.8 Player Ship

**Arc Frame X**

- Experimental adaptive fighter.
- Sleek anime prototype aircraft.
- Visible cockpit.
- Starts as a blue 16-bit-inspired futuristic jet.
- Gains armor pieces, wing upgrades, drones, weapon modules, engine systems, and nose armor through hidden upgrades.
- Fully upgraded form becomes white with glowing blue/gold accents.
- Twist: Arc Frame X is not copying enemy data. It is remembering itself.

### 5.9 Core Terms

| Term | Meaning |
|---|---|
| Arc Frame X | The experimental adaptive fighter and pilot program. Temporary game title. |
| Sky Arc | Orbital megacity chain where humanity lives above Earth. |
| Frames | Guardian AIs that regulate civilization systems. |
| Guardian Frames | The eight corrupted bosses collectively. |
| Null Choir | Mysterious signal corrupting/reawakening the Frames. |
| Origin Frame | Ancient planetary AI buried beneath Earth. |
| Frame Weapons | Boss weapons absorbed from defeated Frames. |
| Arc Modules | Hidden armor/system upgrades found in levels. |
| Core Energy | Weapon energy resource. |
| Shield Surplus Tank | Reserve shield refill usable mid-level. |
| Energy Tank | Reserve Core Energy refill usable mid-level. |
| Root Vault | Earthcore final level path. |
| Council Spire | Sky Arc Command final level path. |
| Choirborne | Generic term for Null Choir-corrupted machines/enemies. |

---

## 6. Game Structure

### 6.1 Campaign Flow

1. Opening cutscene.
2. Mandatory intro/tutorial-prologue level.
3. Stage select unlocks.
4. Eight Guardian Frame levels can be selected in any order.
5. Defeating each Guardian Frame unlocks one Frame Weapon.
6. Some hidden upgrades and secrets require revisiting levels with later weapons.
7. After all eight Guardian Frames are defeated, one mandatory follow-up level unlocks.
8. After the follow-up level, two final level choices unlock:
   - **Root Vault**: descend to Earth and confront the Origin Frame.
   - **Council Spire**: confront the human council hiding Earth’s secrets.
9. Ending cutscene.
10. Unlock Boss Rush and Hard+.

### 6.2 Stage Select

Full game stage select should resemble a Mega Man X-inspired mission grid with a central Sky Arc map.

Screen layout:

- Central animated map of the Sky Arc.
- Boss portraits arranged around the sides.
- Each stage tile shows:
  - Boss portrait.
  - Level name.
  - Difficulty rating.
  - Weapon reward silhouette/icon.
  - Secrets found/missing.
  - Best rank.
  - Best score.
  - Clear time.
- Defeated bosses are greyed out, not crossed out.
- Cleared stages can be replayed.
- Replays are full-level replays.

First build does not need full stage select.

### 6.3 Level Length

Regular Guardian Frame levels:

- 6–8 minutes before boss.
- Boss fight: 1.5–3 minutes.
- Total: 8–11 minutes.

Final levels:

- 8–12 minutes before final boss.
- Multi-stage final boss: 4–6 minutes.

Intro level:

- 4–6 minutes before boss.
- Boss fight: 1.5–2 minutes.

### 6.4 Standard Level Structure

Each main level should generally follow this rhythm:

1. Intro wave.
2. Environmental hazard introduction.
3. Escalating enemy wave.
4. Optional midboss or mini-setpiece.
5. Checkpoint after midboss/setpiece.
6. Secret path opportunity.
7. Intense wave section.
8. Dramatic setpiece.
9. Boss warning.
10. Boss fight.
11. Weapon acquired screen.
12. Results/rank screen.
13. Auto-return to stage select.

Not every level requires a midboss. Only some levels contain hidden armor modules.

---

## 7. Genre, Camera, and Screen Behavior

### 7.1 Scrolling

- Primarily vertical scrolling upward.
- Automatic fixed pace.
- Player movement does not influence scroll speed.
- Some dramatic diagonal sections are allowed.
- No stop-and-fight arenas before bosses in regular levels.
- Boss fights may lock the scroll naturally at the boss arena.

### 7.2 Camera Effects

Camera may:

- Shake lightly on explosions.
- Shake more on boss phase transitions.
- Zoom slightly for boss entrances and defeat moments.
- Rotate very subtly during major setpieces.
- Follow dramatic boss movements only within readable limits.

Camera must not make bullet dodging unreadable.

### 7.3 Off-Screen Threats

Threats and obstacles may enter from off-screen, including top, sides, bottom, background, and foreground.

Rules:

- Large threats require warning indicators.
- Fast side/bottom entrances require arrows, danger lines, or radio warnings.
- Off-screen lasers require telegraph beams before damage activates.

---

## 8. Player Ship Design

### 8.1 Ship Name

The ship is called **Arc Frame X**. In dialogue, allies may refer to it as **X-Frame**, **the prototype**, or **the Arc fighter**.

### 8.2 Visual Silhouette

- Sleek anime prototype aircraft.
- Futuristic fighter jet with subtle mech-like geometry.
- Visible cockpit.
- Mostly blue in base form.
- Medium-small footprint, comparable to a readable Strikers-style player plane.
- Strong triangular forward silhouette.
- Clear left/right wing shape.
- Rear engine cluster with animated thrusters.

### 8.3 Animation States

Player ship needs these sprite states:

| State | Frames | Notes |
|---|---:|---|
| Idle/center | 4 | Subtle engine glow and cockpit pulse. |
| Bank left | 3 | Slight tilt, wing highlight shift. |
| Bank right | 3 | Mirror of left with unique lighting if possible. |
| Damaged/flicker | 2–4 | Alternates normal and white/red flash. |
| Charging | 4–6 | Energy gathers at nose/wing cannons. |
| Boosting | 4 | Stronger rear engine flare, afterimage support. |
| Death explosion | 8–12 | Ship breaks into energy burst/silhouette shards. |

### 8.4 Sprite Size

Recommended first-pass size at 1080p:

- Visual sprite bounding box: **72x88 px** to **96x112 px** in logical 960x720 playfield.
- Collision polygon: roughly **90–100% of ship body**, excluding a few decorative wing tips only if necessary for fairness.
- The user preference is full-ship collision; implement this as a close-fit collision polygon, not a tiny bullet-hell core.

### 8.5 Hitbox Rule

The player uses a ship-shaped collision polygon approximating the visible craft.

- Entire ship counts conceptually.
- Slight forgiveness is allowed for tiny decorative protrusions.
- No visible hitbox during focus mode.
- Debug mode must show hitboxes.

### 8.6 Movement Feel

Movement should be:

- Arcade-tight.
- Snappy.
- Precise.
- Medium speed.
- Not slippery.
- No acceleration/deceleration for baseline movement.

Recommended first-pass movement values:

| Value | Rookie | Hunter | Ace |
|---|---:|---:|---:|
| Base move speed | 420 px/s | 420 px/s | 420 px/s |
| Focus move speed after unlock | 230 px/s | 230 px/s | 230 px/s |
| Dash speed after unlock | 900 px/s | 900 px/s | 900 px/s |
| Dash duration | 0.16s | 0.16s | 0.16s |
| Dash cooldown | 0.65s | 0.75s | 0.85s |
| Post-hit invulnerability | 2.0s | 2.0s | 2.0s |

### 8.7 Screen Edges and Terrain

- Player may touch screen edges.
- Player cannot leave the visible playfield.
- Terrain, walls, buildings, lava, machinery, barriers, and other solid hazards damage the player on contact.
- Terrain collision causes damage, not instant death.
- No knockback.

### 8.8 Damage and Shields

The ship has no traditional health bar. It has shield pips and lives.

Baseline difficulty values:

| Difficulty | Shield Pips | Hits Before Death | Lives | Checkpoints |
|---|---:|---:|---:|---|
| Rookie | 2 | 3rd hit kills | 3 | Standard, forgiving checkpoint placement |
| Hunter | 1 | 2nd hit kills | 3 | Standard |
| Ace | 0 | 1st hit kills | 3 | Standard, no extra checkpoints |
| Hard+ | 0 | 1st hit kills | 3 | Fewer recovery pickups, extra patterns |

Damage feedback:

- First shield hit: yellow shield flash.
- Second shield hit: red flash and shield break.
- Lethal hit: ship explosion.
- Ship flicker during invulnerability.
- Controller rumble on damage.
- Audio warning on shield break.
- No full-screen damage flash.
- No low-health red flashing UI.

### 8.9 Lives and Death

- Player starts each level with 3 lives.
- Extra lives may be earned through pickups, score thresholds, or rare hidden rewards.
- Lives only matter inside the current level.
- If the player dies but has lives remaining:
  - Lose 1 life.
  - Respawn at last checkpoint.
  - Respawn with full shield pips for current difficulty and upgrades.
  - Keep same equipment and upgrades.
  - Keep current weapon energy values as they were before death.
  - Base weapon power level decreases by 1.
- If the player runs out of lives:
  - Game over screen.
  - Return to stage select in full game.
  - Keep campaign progress already earned before entering the failed level.
  - Do not keep collectibles collected in an uncleared level unless the level had already been previously cleared.
- No continues.

### 8.10 Pickups

Pickups may be random drops or placed items.

| Pickup | Effect |
|---|---|
| Shield Cell Small | Restore 1 shield pip if missing. |
| Shield Cell Large | Restore all shield pips. |
| Core Energy Small | Restore 10 weapon energy to current weapon. |
| Core Energy Large | Restore 30 weapon energy to current weapon. |
| Power Chip | Increase base weapon power by 1 up to level 4. |
| Extra Life | Add 1 life. Rare. |
| Bomb Core | Restore 1 special/bomb charge. |
| Score Medal | Adds score and combo value. |
| Lore File | Permanent collectible. |
| Energy Tank | Reserve refill for Frame Weapon energy. Hidden. |
| Shield Surplus Tank | Reserve refill for shield. Hidden. |

Random drop rules:

- More difficult enemies have higher drop probability.
- Drop rates do not vary by difficulty in the first implementation.
- Bosses do not randomly drop pickups.

---

## 9. Controls

### 9.1 Controller Mapping

Use Xbox controller layout by default.

| Input | Action |
|---|---|
| Left stick | Move ship. Digitalized speed; no analog speed scaling. |
| D-pad | Move ship with precise digital input. |
| A | Primary fire. Hold for continuous auto-fire. |
| RT | Primary fire alternative. |
| X | Fire selected Frame Weapon. |
| Y hold/release | Charge weapon. Base charge by default; charged boss weapons after Buster Array. |
| B | Dash/boost after Nova Thrusters unlock. No-op before unlock except UI prompt. |
| LT | Focus movement after Focus Protocol unlock. No-op before unlock except UI prompt. |
| LB | Cycle weapon left. |
| RB | Cycle weapon right. |
| LB + RB | Quick bomb/special attack. |
| Right stick click | Toggle rapid-fire mode. |
| Start/Menu | Pause. |
| View/Select | Status/weapon info overlay. |

### 9.2 Keyboard Mapping

| Key | Action |
|---|---|
| Arrow keys / WASD | Move. |
| Z / J | Primary fire. |
| X / K | Frame Weapon. |
| C / L | Charge. |
| Shift | Focus after unlock. |
| Space | Dash after unlock. |
| Q / E | Cycle weapons. |
| F | Bomb/special. |
| Tab | Weapon/status overlay. |
| Esc | Pause. |

### 9.3 Input Requirements

- Controls must be remappable.
- Game must support vibration/rumble.
- Weapon switching is instant.
- Weapon switching does not pause or slow time.
- Pause menu includes weapon select similar to Mega Man.
- Menus must be navigable without mouse.
- Mouse support is not required.

---

## 10. Base Weapon System

### 10.1 Default Weapon

**Twin Vulcan**

- Unlimited ammo.
- Always fires upward.
- Viable for the entire game.
- Medium fire rate.
- Twin streams from left and right wing cannons.
- Power level increases via Power Chip pickups.
- Power level drops by one on death.
- Four total power levels.

### 10.2 Base Weapon Power Levels

| Level | Behavior | Visual |
|---:|---|---|
| 1 | Two small vulcan shots straight upward. | Blue-white pellets. |
| 2 | Increased fire rate and slightly larger shots. | Brighter blue bolts. |
| 3 | Adds narrow center shot. | Triple-shot pattern. |
| 4 | Adds micro-spread side bolts and stronger hit sparks. | Bright blue/cyan burst fire. |

### 10.3 Charged Base Shot

Without Buster Array:

- Hold charge for 1.2 seconds.
- Release to fire a piercing laser.
- Laser lasts 3 seconds.
- Laser pierces enemies.
- Laser deals increased damage over time.
- Player may keep moving while laser is active.
- Laser does not block enemy bullets.

With Buster Array:

- Charge time reduces to 0.9 seconds.
- Laser becomes wider.
- Boss weapons gain charged versions.

### 10.4 Bomb/Special Attack

**Nova Break**

- Strikers-style screen-clearing bomb/special.
- Limited charges.
- Clears most enemy bullets.
- Damages enemies and bosses.
- Does not clear indestructible boss beams or environmental hazards.
- Starts with 2 charges on Rookie, 1 on Hunter, 1 on Ace.
- Bomb Core pickup restores 1 charge.
- Bomb animation should be flashy but readable.

---

## 11. Hidden Armor Modules

Hidden armor modules are optional, permanent upgrades found in secret areas. They are not required to beat the game but significantly expand player capability and make 100% completion easier.

| Armor Part | Ship Slot | Main Unlock | Secondary Function | Visual Shift |
|---|---|---|---|---|
| Buster Array | Weapons | Improved charge shot + charged boss weapons | Reduces charge time | Adds side/wing weapon housings |
| Orbit Module | Drones | Support drones/formations | Unlocks Focus Protocol for precision movement | Adds small satellite drones |
| Nova Thrusters | Engines | Dash/boost movement | Adds afterimages during boost | Upgraded rear engines + cyan exhaust |
| Prism Guard | Body | Rechargeable shield | Adds +1 max shield pip on all difficulties | White central armor plating |
| Aegis Ram | Nose | Armored boost collision + barrier breaking | Lets dash break certain barriers and damage small enemies | Armored nose wedge |

### 11.1 Focus Protocol

The user requested focus movement as a hidden upgrade. Assign it to **Orbit Module**.

When Orbit Module is acquired:

- Holding LT / Shift slows movement to focus speed.
- Drones tighten into defensive formation.
- No visible hitbox appears.
- Focus does not grant invincibility.

### 11.2 Prism Guard Recharge

When Prism Guard is acquired:

- Add +1 max shield pip on all difficulties.
- If player avoids damage for 12 seconds, one missing shield pip slowly recharges over 2 seconds.
- Recharge stops if firing a Frame Weapon, taking damage, or using a bomb.
- This should be useful but not overpowering.

### 11.3 Aegis Ram Barrier Breaking

When Aegis Ram is acquired:

- Dash/boost can break certain cracked barriers.
- Boost contact destroys small enemies and damages medium enemies.
- Boost does not protect against bosses, lasers, lava, or major hazards unless specifically scripted.

---

## 12. Boss Weapons / Frame Weapons

Each Guardian Frame unlocks exactly one Frame Weapon. Frame Weapons consume Core Energy. Core Energy refills between levels and through pickups. Weapons are usable in all future levels and can open some secret routes.

### 12.1 Weapon UI

The weapon wheel/overlay must show:

- Weapon icon.
- Weapon name.
- Ammo/Core Energy bar.
- Button prompt.
- Small color palette preview.

Switching weapons changes the player ship palette, Mega Man X-style.

### 12.2 Boss Weapon Table

| Frame | Weapon Reward | Primary Function | Cost | Charged Version | Useful For | Weakens |
|---|---|---|---:|---|---|---|
| Tempest Frame | Lightning Chain Cannon | Chain lightning jumps between enemies. | 4 | Storm lance that chains farther and briefly stuns turrets. | Crowd control, turret clusters | Forge Frame |
| Forge Frame | Plasma Drill Missiles | Piercing drill missiles travel upward and punch armor. | 5 | Triple drill barrage with brief terrain piercing. | Heavy armor, destructible blocks | Verdant Frame |
| Verdant Frame | Vine Snare / Seed Bombs | Roots enemies and drops delayed seed explosions. | 4 | Spreading vine net that grounds electrical hazards. | Area denial, secret growth switches | Tempest Frame |
| Aegis Frame | Reflect Barrier | Temporary front shield reflects selected bullets. | 6 | Full circular barrier pulse that clears weak bullets. | Defense, bullet-heavy sections | Pulse Frame |
| Pulse Frame | Healing Drone / Leech Beam | Drone drains enemies to restore shield chance. | 5 | Sustained leech beam locks onto true target. | Sustain, illusion reveal | Echo Frame |
| Vector Frame | Dash Burst / Rail Laser | Fast forward rail shot; also triggers speed doors. | 5 | Wide hyper-rail blast with screen-length pierce. | Mobility gates, fast bosses | Signal Frame |
| Echo Frame | Hologram Decoy | Creates a decoy that draws targeted fire. | 4 | Multiple decoys plus brief player translucency. | Confusion, baiting enemies | Vector Frame |
| Signal Frame | Sonic Wave Cannon | Expanding wave damages shields/barriers. | 5 | Resonance cone cracks reinforced barriers. | Shield breaking, enemy formations | Aegis Frame |

### 12.3 Weakness Logic

| Boss | Weak To | Weakness Logic |
|---|---|---|
| Tempest Frame | Vine Snare / Seed Bombs | Verdant’s organic growth roots into Tempest’s turbine vents and grounding rods, disrupting airflow and grounding electrical charge. |
| Forge Frame | Lightning Chain Cannon | Tempest’s electricity overloads Forge’s industrial power grid and causes furnace regulators to misfire. |
| Verdant Frame | Plasma Drill Missiles | Forge’s drill missiles burn through plant armor, pierce root cores, and cauterize Verdant’s regenerative tissue. |
| Aegis Frame | Sonic Wave Cannon | Signal’s sonic waves resonate through Aegis’s shield frequencies, cracking barriers without direct impact. |
| Pulse Frame | Reflect Barrier | Aegis’s barrier reflects Pulse’s draining beams and surgical lasers back into its own repair network. |
| Vector Frame | Hologram Decoy | Echo’s decoy confuses Vector’s predictive pathing, causing it to overshoot and lock onto false targets. |
| Echo Frame | Healing Drone / Leech Beam | Pulse’s leech beam locks onto Echo’s true energy signature and drains the real core behind illusions. |
| Signal Frame | Dash Burst / Rail Laser | Vector’s rail laser moves too fast for Signal’s broadcast shields to harmonize against. |

### 12.4 Suggested Natural Boss Order

The player can choose any order after the intro level, but the natural difficulty/weakness order is:

1. Tempest Frame.
2. Forge Frame.
3. Verdant Frame.
4. Signal Frame.
5. Aegis Frame.
6. Pulse Frame.
7. Echo Frame.
8. Vector Frame.

Weakness loops:

- Verdant → Tempest → Forge → Verdant.
- Signal → Aegis → Pulse → Echo → Vector → Signal.

---

## 13. Ship Transformation Palettes

Whenever the player equips a Frame Weapon, the ship palette changes.

| Equipped Weapon | Earned From | Ship Transformation Palette | Visual Treatment |
|---|---|---|---|
| Lightning Chain Cannon | Tempest Frame | Electric blue, storm gray, white, violet | Blue lightning crawls across wings. Engine glow shifts white-blue. Storm-fin emitters unfold near rear stabilizers. |
| Plasma Drill Missiles | Forge Frame | Molten orange, black iron, ember red, hazard yellow | Armor panels darken to gunmetal. Missile pods glow orange like furnace vents. Nose/wing edges gain heated highlights. |
| Vine Snare / Seed Bombs | Verdant Frame | Deep green, acid lime, bark brown, pink bioluminescence | Organic-tech plating appears along wings. Lime energy veins pulse through hull. Seed pod launchers open beneath fuselage. |
| Reflect Barrier | Aegis Frame | White armor, cobalt blue, gold trim, transparent cyan | Ship becomes cleaner and knight-like. White armor plates cover body. Gold trim outlines wings. Cyan shield halo appears. |
| Healing Drone / Leech Beam | Pulse Frame | Surgical white, blood red, sterile teal, black chrome | Medical-white panels overlay hull. Red scanner lines sweep cockpit. Teal support drones orbit when charged. |
| Dash Burst / Rail Laser | Vector Frame | Neon magenta, rail silver, black, cyan speed trails | Ship becomes sleeker and darker. Silver rail-lines run nose to tail. Magenta wing glow. Cyan afterimages during speed. |
| Hologram Decoy | Echo Frame | Midnight purple, ghost cyan, pale blue, static white | Hull becomes darker and spectral. Holographic duplicate outlines flicker behind ship. Cockpit glow shifts eerie cyan. |
| Sonic Wave Cannon | Signal Frame | Neon violet, black, signal red, hot pink, pale white | Broadcast-tech look. Violet/red signal rings pulse from nose cannon. Hot pink waveform markings animate across wings. |

---

## 14. Difficulty Design

### 14.1 Difficulty Names

Use thematic names:

| Difficulty | Meaning |
|---|---|
| Rookie | Accessible mode for casual players. |
| Hunter | Intended default. Each level may take 2–3 attempts using all lives. |
| Ace | Experienced shmup/action players. High pressure and low forgiveness. |
| Hard+ | Unlockable after game completion. Adds new patterns and harsher tuning. |

### 14.2 Difficulty Tuning

| Parameter | Rookie | Hunter | Ace | Hard+ |
|---|---:|---:|---:|---:|
| Player shield pips | 2 | 1 | 0 | 0 |
| Enemy health multiplier | 0.85 | 1.0 | 1.15 | 1.25 |
| Enemy bullet speed | 0.85 | 1.0 | 1.15 | 1.25 |
| Enemy bullet density | 0.70 | 1.0 | 1.25 | 1.45 |
| Enemy count | 0.85 | 1.0 | 1.10 | 1.20 |
| Boss health | 0.85 | 1.0 | 1.15 | 1.30 |
| Boss phases | Standard | Standard | Standard + extra attacks | Extra attacks + altered timings |
| Pickups | More placed shield cells | Standard | Fewer placed cells | Minimal placed cells |
| Checkpoints | Standard | Standard | Standard | Reduced in final levels only |
| Core Energy limits | Standard | Standard | Slightly tighter drops | Tight drops |

### 14.3 Secret Unlocks and Difficulty

- All secrets are available on all difficulties.
- Achievements may include difficulty-specific clears.
- No content should be locked away from Rookie players except prestige achievements.

---

## 15. Scoring, Ranking, and Arcade Systems

### 15.1 Scoring Purpose

Score supports progression only in limited cases, mainly for optional secret paths and ranking. Score is not the main campaign progression gate.

### 15.2 Score Sources

Score rewards:

- Enemy kills.
- No-hit sections.
- Weapon variety bonus.
- Secrets found.
- Boss kills.
- Chain combos.
- Score medals.
- Optional objectives.

Completion time does not affect rank in the first design.

### 15.3 Combo System

- Consecutive kills increase combo multiplier.
- Combo timer starts at 3.0 seconds.
- Each kill refreshes timer.
- Max multiplier: x8.
- Taking damage resets combo.
- Bomb kills count for score but do not increase multiplier beyond x2.

### 15.4 Rank Grades

Rank grades:

- C
- B
- A
- S
- X

First-pass rank formula:

- 60% score target.
- 25% damage taken.
- 15% optional objectives.

Weapon usage does not reduce rank. Secrets discovered do not directly affect rank except through optional objective scoring.

### 15.5 Secret Score Gates

Some secret gates may require:

- Active combo above a threshold.
- Rank medal collected earlier in the level.
- Destroying a hidden enemy formation.
- Maintaining no-hit through a challenge section.

Score gates should be optional and never required to beat the game.

---

## 16. Full Game Level and Boss Overview

### 16.1 Guardian Frame Table

| Frame | Original Purpose | Corrupted Form | Boss Visual Identity | Palette | Weapon Reward | Weak To |
|---|---|---|---|---|---|---|
| Tempest Frame | Weather control | Storm fortress AI | Massive airborne storm citadel with thundercloud armor, lightning rods, turbine wings. | Electric blue, storm gray, white lightning, violet highlights | Lightning Chain Cannon | Vine Snare / Seed Bombs |
| Forge Frame | Industry/manufacturing | Lava foundry war machine | Molten factory titan with furnace shoulders, hydraulic arms, conveyor armor, reactor heart. | Molten orange, black iron, ember red, hazard yellow | Plasma Drill Missiles | Lightning Chain Cannon |
| Verdant Frame | Agriculture/terraforming | Bio-mechanical jungle hive | Plant-machine guardian, greenhouse/insect queen/orbital terraformer hybrid. | Deep green, acid lime, bark brown, pink bioluminescence | Vine Snare / Seed Bombs | Plasma Drill Missiles |
| Aegis Frame | Defense grid | Orbital shield tyrant | Floating shield knight/satellite fortress with halo barriers and defensive drones. | White armor, cobalt blue, gold trim, transparent cyan shields | Reflect Barrier | Sonic Wave Cannon |
| Pulse Frame | Medicine/life support | Surgical swarm horror | Hospital AI turned biomechanical surgeon swarm with drone limbs and life-support core. | Surgical white, blood red, sterile teal, black chrome | Healing Drone / Leech Beam | Reflect Barrier |
| Vector Frame | Transportation | Hyper-rail speed demon | Bullet-train combat machine with jetway armor, rail lasers, afterimages. | Neon magenta, rail silver, black, cyan speed trails | Dash Burst / Rail Laser | Hologram Decoy |
| Echo Frame | Memory archives | Ghost data fortress | Haunted archive AI of holographic ruins, broken memories, digital ghosts. | Midnight purple, ghost cyan, pale blue, static white | Hologram Decoy | Healing Drone / Leech Beam |
| Signal Frame | Communications | Null Choir broadcaster | Transmission angel/antenna deity spreading corrupt signal and drone choirs. | Neon violet, black, signal red, hot pink, pale white | Sonic Wave Cannon | Dash Burst / Rail Laser |

### 16.2 Level Details

#### Tempest Frame Level — Storm Crown Citadel

- Environment: Airborne storm city and weather-control fortress.
- Palette: Electric blue, storm gray, violet, white lightning.
- Mechanic: Wind gusts push player laterally; lightning warning lanes.
- Enemies: Turbine drones, lightning rod turrets, cloud mines, storm interceptors.
- Midboss: Cyclone Engine Core.
- Boss: Tempest Frame.
- Secret: Grounding rod tunnel accessed with Verdant weapon.
- Hidden item: Energy Tank.
- Useful weapon: Vine Snare / Seed Bombs.
- Setpiece: Fly through rotating thunder rings while city towers collapse into clouds.
- Background layers: Cloud deck, distant orbital city, storm rings, close turbine towers.
- Foreground hazards: Lightning rods, rotating turbines.
- Destructibles: Capacitor pylons, storm vents.
- Interactables: Grounding switches, wind gate generators.
- Music: Fast synth-rock with arpeggiated lightning motifs.

#### Forge Frame Level — Crucible Array

- Environment: Orbital foundry and lava-industrial production zone.
- Palette: Molten orange, black iron, ember red, hazard yellow.
- Mechanic: Lava waves, press machines, falling slag.
- Enemies: Furnace drones, shielded foundry walkers, missile presses, molten turrets.
- Midboss: Hydraulic Furnace Jaw.
- Boss: Forge Frame.
- Secret: Drill through slag barrier with Plasma Drill Missiles after unlock on replay.
- Hidden item: Buster Array.
- Useful weapon: Lightning Chain Cannon.
- Setpiece: Conveyor maze over glowing reactor channel.
- Background layers: Furnace depths, assembly lines, smoke, moving cranes.
- Foreground hazards: Presses, molten streams.
- Destructibles: Slag blocks, pipe clusters.
- Interactables: Conveyor switches, coolant valves.
- Music: Heavy industrial chiptune-metal.

#### Verdant Frame Level — Greenhouse Abyss

- Environment: Bio-mechanical jungle and orbital terraforming garden.
- Palette: Deep green, acid lime, bark brown, pink bioluminescence.
- Mechanic: Regenerating vines, spore fog, seed mines.
- Enemies: Spore flyers, thorn turrets, insect drones, vine grabbers.
- Midboss: Root Maw Colony.
- Boss: Verdant Frame.
- Secret: Burn through root cores with Forge weapon.
- Hidden item: Shield Surplus Tank.
- Useful weapon: Plasma Drill Missiles.
- Setpiece: Escape through giant closing plant-machine jaws.
- Background layers: Greenhouse canopy, biomechanical roots, luminous pollen clouds.
- Foreground hazards: Thorn gates, spore bursts.
- Destructibles: Root knots, seed pods.
- Interactables: Growth switches, vine doors.
- Music: Organic synth-rock with pulsing bass.

#### Aegis Frame Level — Halo Bastion

- Environment: Orbital defense grid and shield platform.
- Palette: White, cobalt blue, gold, cyan shields.
- Mechanic: Moving shield walls and reflected lasers.
- Enemies: Shield drones, barrier turrets, orbit sentries, mirror cannons.
- Midboss: Bastion Gate Array.
- Boss: Aegis Frame.
- Secret: Sonic resonance gate opened by Signal weapon.
- Hidden item: Prism Guard.
- Useful weapon: Sonic Wave Cannon.
- Setpiece: Fly between rotating shield plates while satellites fire warning lasers.
- Background layers: Stars, orbital platforms, shield domes, Earth below.
- Foreground hazards: Shield walls, laser mirrors.
- Destructibles: Shield nodes.
- Interactables: Frequency locks.
- Music: Heroic defense-grid synth anthem.

#### Pulse Frame Level — Life Support Labyrinth

- Environment: Medical city and corrupted life-support network.
- Palette: Surgical white, blood red, sterile teal, black chrome.
- Mechanic: Drain beams, repair pods, mutating enemies.
- Enemies: Surgical drones, injector mines, leech beams, repair swarms.
- Midboss: Surgical Swarm Cluster.
- Boss: Pulse Frame.
- Secret: Reflect medical lasers into locked growth tanks with Aegis weapon.
- Hidden item: Energy Tank.
- Useful weapon: Reflect Barrier.
- Setpiece: Escape a collapsing hospital corridor while repair drones revive enemies.
- Background layers: Hospital skyline, life-support pipes, scanner grids.
- Foreground hazards: Laser scalpels, quarantine shutters.
- Destructibles: Repair pods, nutrient tanks.
- Interactables: Quarantine switches.
- Music: Tense clinical synth with emergency percussion.

#### Vector Frame Level — Hyper-Rail Rift

- Environment: High-speed transportation spine and orbital rail lanes.
- Palette: Neon magenta, rail silver, black, cyan.
- Mechanic: High-speed lanes, teleport rails, dash gates.
- Enemies: Rail bikes, speed drones, laser trains, kamikaze interceptors.
- Midboss: Split-Rail Interceptor.
- Boss: Vector Frame.
- Secret: Confuse predictive lock-on sensors with Echo decoy.
- Hidden item: Nova Thrusters.
- Useful weapon: Hologram Decoy.
- Setpiece: Vertical shooter section alongside a speeding rail train with lane changes.
- Background layers: Rail tunnels, neon skyline, speed streaks.
- Foreground hazards: Rail barriers, oncoming trains.
- Destructibles: Signal posts, rail locks.
- Interactables: Dash gates.
- Music: Fast techno-rock with racing feel.

#### Echo Frame Level — Mnemosyne Archive

- Environment: Haunted memory archive and glitching data temple.
- Palette: Midnight purple, ghost cyan, pale blue, static white.
- Mechanic: Illusions, fake enemies, delayed attacks, duplicate player shadows.
- Enemies: Data ghosts, fake turrets, memory shards, clone ships.
- Midboss: Broken Hero Simulacrum.
- Boss: Echo Frame.
- Secret: Pulse weapon reveals true walls and hidden data cores.
- Hidden item: Orbit Module.
- Useful weapon: Healing Drone / Leech Beam.
- Setpiece: Fly through archived memory fragments of previous stages.
- Background layers: Digital ruins, holographic statues, memory streams.
- Foreground hazards: Glitch walls, false bullets.
- Destructibles: Data locks, corrupted archives.
- Interactables: Memory keys.
- Music: Melancholic synth with glitch percussion.

#### Signal Frame Level — Null Choir Spire

- Environment: Communication towers and corrupted broadcast cathedral.
- Palette: Neon violet, black, signal red, hot pink, pale white.
- Mechanic: Screen distortion, sonic rings, signal jamming.
- Enemies: Broadcast drones, choir turrets, waveform mines, antenna angels.
- Midboss: Choir Relay Seraph.
- Boss: Signal Frame.
- Secret: Vector rail shot cuts through resonance-locked broadcast gates.
- Hidden item: Aegis Ram.
- Useful weapon: Dash Burst / Rail Laser.
- Setpiece: Fly through a collapsing antenna forest while the HUD briefly distorts.
- Background layers: Transmission towers, data waves, city silhouettes, signal halos.
- Foreground hazards: Sonic rings, jamming fields.
- Destructibles: Relay nodes.
- Interactables: Frequency gates.
- Music: Aggressive synthwave with choir-like digital pulses.

---

## 17. Intro Level for First Build

### 17.1 Level Name

**Sky Arc Breach**

### 17.2 Purpose

This is the required first playable level and the first Codex implementation target. It teaches core movement, shooting, damage, pickups, scoring, warning indicators, and a simple boss encounter without overwhelming the player.

### 17.3 Story Context

Kai launches in Arc Frame X during the first major Null Choir attack on the lower Sky Arc. Mira guides him through a damaged industrial flight corridor while corrupted defense drones attack the city. The level ends with a fight against a prototype corrupted Frame relay, foreshadowing Signal Frame.

### 17.4 Environment

- Futuristic industrial urban skyway.
- Vertical flight through lower orbital slums, maintenance towers, and defense pylons.
- Color palette: cobalt blue, steel gray, warning orange, cyan energy, violet corruption.
- Background: city below clouds, moving traffic lights, distant megastructures.
- Foreground: pipes, gantries, antennas, warning signs.

### 17.5 Tutorial Design

Tutorial should be integrated into play, not a separate prompt-heavy level.

Teach:

1. Movement.
2. Shooting.
3. Enemy bullets.
4. Shield damage.
5. Pickups.
6. Charge shot.
7. Warning indicators.
8. Bomb/special.
9. Boss health bar.
10. Level clear and rank.

Do not teach weapon weaknesses, armor upgrades, or secret paths in the first build.

### 17.6 Level Structure

| Segment | Duration | Content |
|---|---:|---|
| Launch Corridor | 45s | Easy drones, movement space, first firing. |
| Defense Grid | 60s | Turrets, bullet patterns, first shield pickup. |
| Skyway Collapse | 60s | Off-screen warning obstacles, falling debris. |
| Checkpoint | Instant | Trigger after collapse. |
| Industrial Climb | 90s | Mixed enemy waves, score medals, charge-shot use. |
| Relay Approach | 45s | Increased intensity, warning siren. |
| Boss | 90–120s | Null Relay Seraph prototype. |

### 17.7 First Build Boss

**Boss Name:** Null Relay Seraph

Role:

- Prototype mini-Frame/Signal-corrupted relay boss.
- Not one of the eight Guardian Frames.
- Teaches boss health, phases, warning attacks, and weak-point timing.

Visual identity:

- Floating antenna-wing machine.
- Angelic silhouette corrupted by violet signal rings.
- Central red eye/core.
- Two side antenna fins.
- Rotating halo dish.

Palette:

- Violet.
- Black chrome.
- Signal red.
- Cyan corrupted highlights.

Phases:

1. Phase 1: Slow radial bullets and aimed shots.
2. Phase 2 at 60% health: Sonic ring waves plus side drones.
3. Desperation at 20%: Warning beam lanes and faster bullet bursts.

Weakness:

- No special weakness in first build.
- Base weapon and charged laser should be sufficient.

Reward:

- For first build, unlock a prototype **Sonic Wave Cannon** after victory to prove weapon acquisition flow.
- In the full game, Signal Frame later unlocks the real Sonic Wave Cannon. This intro prototype can be treated as a limited training version or removed/reworked later.

---

## 18. Enemy Design

### 18.1 Enemy Categories Needed Over Full Game

- Basic flyer.
- Fast kamikaze.
- Turret.
- Shielded enemy.
- Heavy tank/heavy aircraft.
- Mine layer.
- Sniper.
- Bullet spreader.
- Laser enemy.
- Summoner/spawner.
- Environmental hazard enemy.
- Mini-boss.

### 18.2 First Build Enemy Types

Implement 4–6 enemy types for the intro level.

| Enemy | Role | Behavior | Health | Score |
|---|---|---|---:|---:|
| Choir Drone | Basic flyer | Enters from top in simple path, fires straight bullet. | 3 | 100 |
| Needle Runner | Fast kamikaze | Enters from side, curves toward player, contact threat. | 2 | 150 |
| Pylon Turret | Stationary turret | Anchored to terrain, fires aimed shots. | 8 | 300 |
| Shield Kite | Shielded enemy | Frontal shield, vulnerable from sides or charged shot. | 10 | 500 |
| Relay Carrier | Spawner | Slow heavy enemy that releases drones. | 20 | 900 |
| Warning Mine | Hazard enemy | Drifts in from off-screen with warning arrow, explodes into bullets. | 5 | 250 |

### 18.3 Enemy Rules

- Enemies may enter from top, sides, bottom, background, or foreground.
- Enemy waves use scripted movement paths.
- Some enemies aim at the player.
- Some enemies fire fixed patterns.
- Some enemies dodge or react.
- Some enemies damage on contact.
- Larger enemies may have destructible parts.
- Enemy health bars are not shown except bosses/midbosses.
- Enemy projectiles are color-coded.
- Some enemy bullets are destroyable only by certain weapons or bomb clears.
- Some bullets are indestructible.

### 18.4 Bullet Types

| Bullet Type | Use | Hitbox |
|---|---|---|
| Small plasma | Common enemy shots | Circle |
| Large orb | Boss and heavy enemy patterns | Circle |
| Missile | Homing or slow explosive threat | Circle/rect hybrid |
| Laser beam | Telegraph then continuous damage | Rectangle |
| Mine | Floating area hazard | Circle |
| Shockwave | Expanding ring | Circle/ring approximation |
| Fireball | Forge/industrial hazards | Circle |
| Sonic ring | Signal attacks | Ring/circle approximation |

---

## 19. Bullet Hell and Readability Rules

### 19.1 Bullet Density

This is not a pure bullet hell. It should have bullet hell influence while preserving full-ship collision and console-action accessibility.

- Rookie: sparse bullets, clear lanes.
- Hunter: moderate density, intended challenge.
- Ace: dense but fair patterns.
- Hard+: true bullet-hell-inspired patterns, still readable.

### 19.2 Bullet Speed

Use a mix:

- Common bullets: moderate speed.
- Dense patterns: slower bullets.
- Sparse sniper shots: faster bullets with telegraphs.
- Boss beams: strong warning indicators.

### 19.3 Bullet Visibility

- Enemy bullets must be large and visible.
- Enemy bullets use danger colors: red, orange, violet, hot pink.
- Player bullets use hero colors: blue, cyan, white, gold, green depending weapon.
- Indestructible bullets should have a distinct outline or core.
- Large attacks must have warning indicators.
- Safe lanes must exist in all patterns.

### 19.4 Bullet Canceling

- Bomb/special clears most normal bullets.
- Reflect Barrier can reflect selected bullets.
- Boss phase transitions clear bullets.
- Killing certain enemies may cancel bullets in scripted cases.
- Not all enemy bullets are destroyable.
- Lasers and environmental hazards are not bomb-cleared unless explicitly marked.

### 19.5 Grazing

Do not implement grazing in the first build.

Full game optional later:

- Grazing may add small score/charge bonuses on Ace/Hard+ only.
- It should not be central because player uses full-ship collision.

---

## 20. Boss Design Rules

### 20.1 Standard Guardian Boss Structure

Each Guardian Frame should have:

- 3 phases.
- Visible health bar.
- Health bar phase markers.
- Intro animation.
- Pattern-based attacks.
- Some behavior changes based on player position.
- Desperation attack at low health.
- Environment interaction.
- Dialogue before and/or after fight.
- Staged explosion on defeat.
- Immediate weapon acquisition screen after defeat.

### 20.2 Weakness Behavior

Using the correct weapon should dramatically reduce difficulty.

Weakness effects:

- 2.0x to 3.0x damage multiplier.
- Brief stun or stagger in specific windows.
- Interrupt or alter one signature attack.
- Reveal a vulnerability or disable a defense.

Weakness should not permanently stun-lock the boss.

### 20.3 Boss Refights

Final level includes weakened versions of all eight bosses.

Rules:

- Shortened health pools.
- One or two phases only.
- No full dialogue.
- Fast transition between refights.
- Player receives energy/shield recovery between groups, not necessarily every boss.

---

## 21. Final Levels

After defeating all eight Guardian Frames and one mandatory follow-up level, the player chooses between two final paths.

### 21.1 Final Path A — Root Vault

Theme:

- Descend below the clouds to Earth.
- Reveal Earth is not dead but transformed into a machine-organic world.
- Confront the Origin Frame at the planet’s core.

Final boss:

- **Origin Frame**.
- AI core / planetary machine / multi-stage transforming boss.
- Represents the first intelligence humanity created.

### 21.2 Final Path B — Council Spire

Theme:

- Return to the highest command layer of Sky Arc.
- Expose the human council that concealed Earth’s truth.
- Fight the weaponized political/military system built to preserve the lie.

Final boss:

- **Arc Frame Zero**, deployed by Sky Arc High Command.
- Rival prototype ship/pilotless AI merged with Null Choir tech.
- Multi-stage transforming boss.

### 21.3 Final Boss Requirements

- 3 phases.
- Unique final boss music.
- Uses some thematic echoes of prior mechanics but does not literally use all eight boss weapons.
- Includes boss rush before final confrontation.
- Includes escape sequence after victory.
- Ending cutscene.
- Unlocks Boss Rush and Hard+.

---

## 22. Secrets and Unlockables

### 22.1 Secret Types

The full game includes:

- Armor modules.
- Lore files.
- Music tracks.
- Challenge rooms.
- Hidden boss fights.
- Energy Tanks.
- Shield Surplus Tanks.
- Medals/collectibles.

### 22.2 Completion Rules

- Secrets required for 100% completion.
- Secrets not required to beat the game.
- Each level has collectible count.
- Stage select shows secrets found/missing.
- Some secrets require specific boss weapons.
- Some secrets require skillful dodging.
- Some secrets require replaying levels after gaining new weapons/upgrades.
- No hidden endings.
- No alternate ships.
- No unlockable concept art required.

### 22.3 Progress Persistence

- Permanent upgrades save when collected and level is completed.
- If replaying an already-cleared level, collected new upgrades can be kept even if quitting after pickup only if explicitly allowed by save rules.
- First full design rule: if the level has not previously been cleared, quitting loses mid-level pickups and collectibles.

---

## 23. UI and HUD

### 23.1 HUD Style

- Pixel-inspired UI.
- Futuristic clean layout.
- Arcade-dense but not cluttered.
- Use side panels due 4:3 playfield inside 16:9 screen.
- HUD should scale to 1080p and 4K.

### 23.2 Gameplay HUD Elements

Visible during gameplay:

- Lives.
- Score.
- Combo multiplier.
- Current weapon icon.
- Current weapon energy bar.
- Charge meter.
- Bomb/special count.
- Shield pips.
- Boss health bar during boss fights.
- Warning indicators.
- Mini objective/tutorial text in intro only.

No traditional health bar.

### 23.3 HUD Placement

Recommended:

- Left side panel:
  - Lives.
  - Shield pips.
  - Bomb count.
  - Current weapon.
  - Core Energy.
- Right side panel:
  - Score.
  - Combo.
  - Rank projection.
  - Objective/tutorial hint.
- Top center during bosses:
  - Boss name.
  - Boss health bar with phase ticks.
- Near ship:
  - Do not show persistent weapon icon near ship.
  - Short weapon-switch pop-up near ship is allowed for 0.75 seconds.

### 23.4 Boss Warning

Before boss fights:

- Display animated **WARNING** banner.
- Audio warning.
- Red/violet scan lines.
- Boss name reveal.
- Short operator line.

### 23.5 Menu Screens Needed

Full game screens:

- Title screen.
- Main menu.
- New game.
- Continue.
- Save slot screen.
- Stage select.
- Options.
- Controls.
- Audio settings.
- Graphics settings.
- Accessibility settings.
- Credits.
- Pause menu.
- Weapon select/status screen.
- Game over.
- Level complete.
- Weapon acquired.
- Save/load confirmation.

First build screens:

- Title screen.
- Main menu.
- New game.
- Options placeholder.
- Gameplay HUD.
- Pause menu.
- Level complete.
- Weapon acquired.
- Game over.

### 23.6 UI Designer Deliverables

UI designer should mock up:

- Title screen.
- Main menu.
- Stage select.
- Gameplay HUD.
- Pause menu.
- Weapon select.
- Options menu.
- Level complete screen.
- Weapon acquired screen.
- Game over screen.
- Save slot screen.

UI style:

- Pixel-inspired panels.
- Animated panel transitions.
- Some background motion.
- Controller and keyboard prompts.
- Selected items pulse/animate.
- Stage select: central map with Mega Man-style grid/portraits around the sides.
- Show difficulty and best rank per stage.
- Completion percentage can be shown on save/profile screen, not necessarily HUD.

---

## 24. Menus and Options

### 24.1 Menu Navigation

- Controller-first.
- D-pad and analog stick support.
- Keyboard support.
- No mouse support required.
- Menu move/confirm/cancel SFX.

### 24.2 Options

Options must eventually include:

- Music volume.
- SFX volume.
- UI volume.
- Screen shake toggle/intensity.
- Flash intensity.
- Difficulty.
- Controller remap.
- Keyboard remap.
- Fullscreen/windowed.
- Resolution.
- V-sync.
- Accessibility options.
- Bullet visibility.
- Colorblind bullet palette.
- Subtitles.

### 24.3 Pause Menu

Pause menu includes:

- Resume.
- Weapon select/status.
- Controls.
- Options.
- Return to stage select.
- Quit to title.

Pause menu does not include restart level in the first design.

Returning to stage select from pause quits the level and loses uncleared level progress.

---

## 25. Visual Art Direction

### 25.1 Overall Art Style

Modern high-resolution 2D inspired by 16-bit console and arcade games.

Closest references:

- Mega Man X.
- Strikers 1945.
- Radiant Silvergun.
- Axelay.
- Metal Slug.

Avoid:

- Realistic gritty military visuals.
- Overly noisy detail.
- Full R-Type biomechanical darkness as primary style.
- Tiny unreadable bullets.
- Visual clutter that hides gameplay.

### 25.2 Palette Philosophy

- Bright and saturated.
- Each level has distinct dominant color.
- Player ship always stands out from backgrounds.
- Enemy bullets use consistent danger colors.
- Player bullets use distinct hero colors.
- Medium-large flashy explosions.
- Restrained screen shake.
- Parallax backgrounds.
- Animated background details.

### 25.3 Outlines

Use selective dark outlines.

Guideline:

- Player ship, enemies, and pickups should have readable outlines or rim contrast.
- Avoid thick black outlines everywhere if it makes high-res sprites look childish.
- Use dark navy/purple/metal outlines instead of pure black when possible.

### 25.4 Asset Format

- Export sprites as PNG.
- Use sprite sheets or texture atlases.
- Include JSON or Godot resource metadata for animations when useful.
- Use nearest-neighbor or crisp scaling where appropriate, but allow high-res detail.
- Use frame-based animation.
- Avoid particle systems in first build; use sprite animation VFX.

### 25.5 Tilemaps vs Illustrated Backgrounds

Use a hybrid approach:

- Gameplay collision and repeated structures: tilemaps.
- Major background vistas: illustrated parallax layers.
- Foreground hazards: separate animated sprites/scenes.

Recommended tile size:

- 32x32 logical pixels for collision/tilemaps.
- 64x64 for larger decorative industrial pieces.

---

## 26. VFX Requirements

### 26.1 Required Effects

- Player bullets.
- Enemy bullets.
- Lasers.
- Missiles.
- Explosions.
- Hit sparks.
- Shield impacts.
- Weapon charge.
- Weapon pickup.
- Boss defeat.
- Environmental hazards.
- Screen transitions.
- Dash afterimages.
- Warning indicators for large lasers/missiles.
- Distinct boss weapon effects.

### 26.2 VFX Style

- Retro-modern.
- Sprite animations instead of particle systems for first build.
- Bullets may glow, but keep readability high.
- Additive-style effects allowed sparingly.
- Each boss weapon has a distinct color language.
- Explosions are medium-large and flashy, not screen-obscuring.

---

## 27. Audio and Music

### 27.1 Music Style

Hybrid retro-modern synth rock similar in spirit to Mega Man X.

Elements:

- 16-bit chiptune rock.
- Synthwave energy.
- Arcade techno percussion.
- Occasional metal-influenced action riffs.
- Heroic melodic hooks.

### 27.2 Music Requirements

Full game:

- Title theme.
- Stage select theme.
- Unique music per level.
- Shared Guardian Frame boss theme.
- Final boss theme.
- Ending theme.
- Weapon acquired jingle.
- Game over jingle.

First build:

- Placeholder title loop.
- Placeholder intro level loop.
- Placeholder boss loop.
- Placeholder victory jingle.

### 27.3 SFX Requirements

Required SFX:

- Player shot.
- Charged shot.
- Each boss weapon.
- Enemy shot.
- Enemy death.
- Player hit.
- Player death.
- Pickup.
- Warning.
- Menu move.
- Menu confirm.
- Boss intro.
- Explosion.
- Secret discovered.

SFX style:

- Retro.
- Punchy.
- Short.
- No voice clips.
- Bosses may have voice-like synthetic sound effects plus text dialogue.

---

## 28. Narrative Implementation

### 28.1 Dialogue Types

- Opening cutscene dialogue.
- Mission briefing dialogue before levels.
- Short radio lines during levels.
- Boss intro dialogue.
- Boss defeat dialogue.
- Secret lore files.
- Ending cutscenes.

### 28.2 Dialogue Style

- Brief.
- Punchy.
- 90s anime sci-fi energy.
- Avoid long exposition during gameplay.
- Use lore files for deeper worldbuilding.

### 28.3 Sample Intro Level Dialogue

Opening:

- Mira: “Kai, your sync is unstable, but the launch rail is gone. You’re our only craft in the air.”
- Kai: “Then point me at the breach.”
- Mira: “Arc Frame X is reading hostile signatures in the lower grid. Keep moving. I’ll guide you through.”

Before boss:

- Mira: “That relay is broadcasting the Null Choir into the city systems.”
- Kai: “Can I shut it down?”
- Mira: “Not shut down. Destroy. Now.”

After boss:

- Kai: “The ship just copied its signal pattern.”
- Mira: “Copied? Kai, that should be impossible.”
- Arc Frame X text fragment: “Remembering...”

---

## 29. Accessibility

Implement accessibility with seriousness from the start, even if not all options are complete in first build.

Required eventually:

- Colorblind-friendly bullet colors.
- Screen flash intensity slider.
- Screen shake slider/toggle.
- Bullet visibility options.
- Larger UI text option.
- Subtitles for dialogue/cutscenes.
- Remappable controls.
- Auto-fire.
- Reduced difficulty assist options.
- Optional invincibility/accessibility mode.

First build accessibility:

- Auto-fire toggle.
- Screen shake toggle.
- Flash intensity placeholder setting.
- Subtitles on by default for dialogue.
- Remappable controls architecture, even if UI is basic.

No aim assist is needed because ship always shoots upward.

---

## 30. Save System

### 30.1 Full Game Save Requirements

Progress saves automatically and supports manual saves.

Multiple save slots are required.

Saved data:

- Defeated bosses.
- Unlocked weapons.
- Found secrets.
- Armor upgrades.
- Energy Tanks.
- Shield Surplus Tanks.
- Best score per level.
- Best rank per level.
- Difficulty.
- Settings.
- Total completion percentage.
- Boss Rush unlocked.
- Hard+ unlocked.

### 30.2 Save Format

Use human-readable JSON during development.

Future production may add validation, versioning, backup saves, and optional obfuscation.

### 30.3 Reset Progress

Do not expose reset progress in normal UI initially.

Debug builds may include reset save command.

### 30.4 First Build

First build does not need full save/load. It should include save system stubs/interfaces and a basic settings persistence file if easy.

---

## 31. Game Modes

### 31.1 Initial Game Mode

Single-player only.

### 31.2 Full Game Modes

| Mode | Required | Notes |
|---|---|---|
| Campaign | Yes | Main game. |
| Training Room | Yes | Practice movement/weapons/enemies. |
| Boss Rush | Later | Unlock after game completion. |
| Hard+ | Later | Unlock after game completion. |
| Local co-op | Future | Architecture should leave room. |
| Daily/weekly challenges | Future | Not part of first release. |
| Arcade mode | No | Not needed. |
| No-upgrades challenge | No | Not needed. |
| Challenge mode | No | Not needed now. |

Note: Although the questionnaire said “no campaign mode,” the game is structurally a campaign. Treat “campaign” as the default main play mode, not a separate arcade mode option.

---

## 32. Collision and Hitbox Rules

### 32.1 Collision Types

| Object | Collision Rule |
|---|---|
| Player vs enemy bullet | Damage player. |
| Player vs enemy | Contact damage. |
| Player vs terrain | Damage player. |
| Player bullet vs enemy | Damage enemy. |
| Player bullet vs enemy bullet | No collision by default. |
| Bomb vs enemy bullet | Clears normal bullets. |
| Reflect Barrier vs enemy bullet | Reflects eligible bullets. |
| Laser vs enemy | Continuous damage once per tick interval. |
| Missile vs enemy | Direct damage plus splash damage. |
| Explosion vs enemy | No general area damage except missiles/bombs. |
| Shield vs bullet | Absorbs bullet and consumes/impacts shield. |

### 32.2 Laser Damage Rule

Lasers hit continuously once per interval.

Recommended:

- Damage tick every 0.1 seconds.
- Beam collision uses rectangular hitbox.
- Telegraph beams use non-damaging warning area for 0.5–1.0 seconds before activation.

### 32.3 Determinism

All collision should be deterministic and frame-consistent.

Debug mode must show:

- Player collision polygon.
- Enemy collision boxes.
- Bullet hitboxes.
- Terrain collision.
- Damage zones.
- Pickup zones.

---

## 33. Performance Requirements

### 33.1 Object Counts

The engine should support:

- 300+ bullets on screen.
- 40+ enemies on screen.
- 80+ active VFX sprites.
- 100+ pooled pickups/projectiles total.

### 33.2 Object Pooling

Use object pooling for:

- Player bullets.
- Enemy bullets.
- Missiles.
- Explosions.
- Hit sparks.
- Pickups.
- Common enemies if useful.

### 33.3 Quality Settings

Eventually include:

- VFX quality.
- Screen shake intensity.
- Flash intensity.
- Background animation detail.
- Resolution scaling.

### 33.4 Slowdown

Avoid unintentional slowdown.

Intentional arcade-style slowdown may be allowed during huge explosions later, but first build should target stable performance.

---

## 34. Content Pipeline

### 34.1 Recommended Approach

Use a hybrid Godot content pipeline:

- Scenes for reusable objects.
- Tilemaps for collision/layout.
- Parallax layers for backgrounds.
- Resource files for weapons/enemies/bosses where possible.
- JSON or Godot resources for level wave data and tuning config.

### 34.2 Data-Driven Requirements

Centralize data for:

- Player tuning.
- Weapons.
- Enemy definitions.
- Bullet patterns.
- Boss phases.
- Difficulty multipliers.
- Pickups.
- Score values.
- Level wave timings.

Designers should be able to tune values without editing core gameplay code.

### 34.3 Hot Reload

Support hot reloading where practical for tuning JSON/config files in debug builds.

### 34.4 Folder Structure

Recommended Godot project structure:

```text
ArcFrameX/
  project.godot
  README.md
  docs/
    GDD.md
    IMPLEMENTATION_NOTES.md
    DATA_SCHEMAS.md
  assets/
    art/
      player/
      enemies/
      bosses/
      bullets/
      vfx/
      pickups/
      ui/
      backgrounds/
      tilesets/
    audio/
      music/
      sfx/
      ui/
    fonts/
  data/
    tuning/
      player.json
      difficulty.json
      scoring.json
    weapons/
      base_twin_vulcan.json
      sonic_wave_cannon.json
    enemies/
      choir_drone.json
      needle_runner.json
      pylon_turret.json
      shield_kite.json
      relay_carrier.json
      warning_mine.json
    levels/
      intro_sky_arc_breach.json
    bosses/
      null_relay_seraph.json
  scenes/
    core/
    player/
    enemies/
    bosses/
    bullets/
    pickups/
    levels/
    ui/
    managers/
    vfx/
  scripts/
    core/
    player/
    enemies/
    bosses/
    bullets/
    pickups/
    managers/
    ui/
    debug/
    data/
  tests/
    unit/
    integration/
  exports/
```

### 34.5 Naming Convention

Use lowercase snake_case for files.

Examples:

- `player_ship.tscn`
- `weapon_twin_vulcan.gd`
- `enemy_choir_drone.tscn`
- `boss_null_relay_seraph.tscn`
- `intro_sky_arc_breach.json`
- `spr_player_ship_base.png`
- `sfx_player_shot_01.wav`

---

## 35. Engineering Systems Required

Codex should include or stub these systems:

1. Input system.
2. Player controller.
3. Player weapon system.
4. Charge system.
5. Bomb/special system.
6. Enemy system.
7. Bullet/projectile system.
8. Object pooling.
9. Collision/hitbox system.
10. Health/shield/lives/damage system.
11. Pickup system.
12. Boss state machine.
13. Level scripting/wave spawner.
14. Difficulty manager.
15. Save/load system stub.
16. Stage select system stub.
17. Unlock/progression system stub.
18. Secret tracking system stub.
19. HUD system.
20. Pause/menu system.
21. Audio manager.
22. VFX manager.
23. Camera system.
24. Screen shake system.
25. Debug tools.
26. Data/config loader.
27. Scene transition manager.
28. Results/ranking system.
29. Localization-ready text system.

---

## 36. Data Schemas

### 36.1 Weapon Schema

```json
{
  "id": "sonic_wave_cannon",
  "display_name": "Sonic Wave Cannon",
  "type": "frame_weapon",
  "ammo_max": 100,
  "ammo_cost": 5,
  "cooldown": 0.35,
  "damage": 8,
  "projectile_scene": "res://scenes/bullets/sonic_wave_projectile.tscn",
  "palette_id": "signal",
  "charged": {
    "enabled_requires_upgrade": "buster_array",
    "charge_time": 1.1,
    "ammo_cost": 15,
    "damage": 22,
    "effect": "wide_resonance_cone"
  },
  "can_clear_bullets": false,
  "can_open_secret_tags": ["sonic_gate", "shield_resonance_lock"]
}
```

### 36.2 Enemy Schema

```json
{
  "id": "choir_drone",
  "display_name": "Choir Drone",
  "scene": "res://scenes/enemies/enemy_choir_drone.tscn",
  "max_health": 3,
  "contact_damage": 1,
  "score_value": 100,
  "movement_pattern": "path_follow",
  "fire_pattern": "single_straight",
  "drop_table": "basic_enemy",
  "tags": ["flying", "choirborne", "basic"]
}
```

### 36.3 Level Wave Schema

```json
{
  "level_id": "intro_sky_arc_breach",
  "display_name": "Sky Arc Breach",
  "scroll_speed": 90,
  "music": "intro_stage_theme",
  "waves": [
    {
      "time": 3.0,
      "enemy_id": "choir_drone",
      "count": 5,
      "spawn_points": ["top_left", "top_center", "top_right"],
      "path_id": "s_curve_down"
    },
    {
      "time": 18.0,
      "enemy_id": "pylon_turret",
      "count": 2,
      "spawn_points": ["terrain_left", "terrain_right"],
      "path_id": "stationary"
    }
  ],
  "checkpoints": [
    {
      "id": "checkpoint_01",
      "time": 165.0,
      "player_spawn": "center_bottom"
    }
  ],
  "boss": {
    "id": "null_relay_seraph",
    "trigger_time": 330.0
  }
}
```

### 36.4 Boss Schema

```json
{
  "id": "null_relay_seraph",
  "display_name": "Null Relay Seraph",
  "scene": "res://scenes/bosses/boss_null_relay_seraph.tscn",
  "max_health": 450,
  "phase_markers": [0.6, 0.2],
  "weakness_weapon_ids": [],
  "phases": [
    {
      "health_min": 0.6,
      "patterns": ["radial_pulse", "aimed_triplet"]
    },
    {
      "health_min": 0.2,
      "patterns": ["sonic_rings", "summon_side_drones"]
    },
    {
      "health_min": 0.0,
      "patterns": ["warning_beam_lanes", "fast_radial_burst"]
    }
  ],
  "reward_weapon_id": "sonic_wave_cannon"
}
```

### 36.5 Difficulty Schema

```json
{
  "rookie": {
    "shield_pips": 2,
    "enemy_health_mult": 0.85,
    "enemy_bullet_speed_mult": 0.85,
    "enemy_bullet_density_mult": 0.70,
    "boss_health_mult": 0.85,
    "bomb_charges_start": 2
  },
  "hunter": {
    "shield_pips": 1,
    "enemy_health_mult": 1.0,
    "enemy_bullet_speed_mult": 1.0,
    "enemy_bullet_density_mult": 1.0,
    "boss_health_mult": 1.0,
    "bomb_charges_start": 1
  },
  "ace": {
    "shield_pips": 0,
    "enemy_health_mult": 1.15,
    "enemy_bullet_speed_mult": 1.15,
    "enemy_bullet_density_mult": 1.25,
    "boss_health_mult": 1.15,
    "bomb_charges_start": 1
  }
}
```

---

## 37. First-Pass Tuning Values

### 37.1 Player

| Value | First-Pass Number |
|---|---:|
| Move speed | 420 px/s |
| Focus speed | 230 px/s |
| Dash speed | 900 px/s |
| Dash duration | 0.16s |
| Dash cooldown | 0.75s |
| Post-hit invulnerability | 2.0s |
| Base weapon fire interval | 0.11s |
| Charge time | 1.2s |
| Buster Array charge time | 0.9s |
| Charged laser duration | 3.0s |
| Charged laser damage tick | 0.1s |

### 37.2 Bullets

| Bullet | Speed | Damage |
|---|---:|---:|
| Twin Vulcan shot | 900 px/s | 1 |
| Level 4 side shot | 800 px/s | 1 |
| Charged laser | Continuous | 4 per tick |
| Enemy small plasma | 220 px/s | 1 shield pip/death hit |
| Enemy aimed shot | 280 px/s | 1 |
| Boss orb | 180 px/s | 1 |
| Warning beam | Instant after telegraph | 1 |

### 37.3 Score

| Event | Score |
|---|---:|
| Basic enemy | 100 |
| Kamikaze enemy | 150 |
| Turret | 300 |
| Shielded enemy | 500 |
| Heavy/spawner | 900 |
| Midboss | 5,000 |
| Boss | 25,000 |
| Score medal small | 250 |
| Score medal large | 1,000 |
| No-hit section bonus | 5,000 |

### 37.4 First Build Boss

| Value | Number |
|---|---:|
| Null Relay Seraph health | 450 |
| Phase 2 threshold | 60% |
| Desperation threshold | 20% |
| Boss contact damage | 1 |
| Boss bullet damage | 1 |

---

## 38. Debug Tools

First build should include debug mode toggled by a build flag or debug key.

Debug commands:

- Toggle invincibility.
- Unlock all weapons.
- Jump to boss.
- Spawn enemy wave.
- Show hitboxes.
- Refill shields.
- Refill weapon energy.
- Refill bomb charges.
- Kill all enemies.
- Advance level timer.
- Toggle player damage.
- Toggle infinite Core Energy.
- Toggle FPS/performance overlay.

Debug UI should be unavailable in release builds unless explicitly enabled.

---

## 39. Automated Tests

Include lightweight automated tests where practical.

Suggested tests:

- Data files load without parse errors.
- Weapon configs contain required fields.
- Enemy configs contain required fields.
- Difficulty configs contain required fields.
- Player damage reduces shield/lives correctly.
- Weapon energy cost is applied correctly.
- Base weapon power decreases by one on death.
- Score multiplier resets on damage.
- Object pool returns objects after despawn.

If Godot test framework setup is too heavy, include a simple debug/test runner scene or script.

---

## 40. Art Deliverables

### 40.1 First Build Art Assets

Artist or asset generator should produce:

- Player ship sprite sheet.
- Player banking animations.
- Player charged-shot VFX.
- Player death explosion.
- Twin Vulcan bullet sprites.
- Enemy bullet sprites.
- Sonic Wave Cannon prototype effect.
- Bomb/special effect.
- Explosion sprite sheet.
- Shield impact sprite sheet.
- Pickup sprites.
- HUD icons.
- Intro level tiles/backgrounds.
- 4–6 enemy sprites.
- Null Relay Seraph boss sprite parts.
- Boss portrait for Null Relay Seraph.
- Weapon icon for Sonic Wave Cannon.
- Menu background.

### 40.2 Full Game Art Assets

Full game eventually needs:

- All player upgrade visuals.
- Eight ship weapon palettes.
- Eight boss portraits.
- Eight boss multi-part sprite sets.
- Unique enemy sets per level plus generic shared enemies.
- Level background/parallax sets.
- Level tilemaps/tilesets.
- Environmental hazard sprites.
- All weapon icons.
- Full UI screen art.
- Stage select map art.

### 40.3 Export Specs

- PNG format.
- Transparent backgrounds for sprites.
- Sprite sheets preferred for animations.
- Texture atlases acceptable.
- Include animation metadata where possible.
- Use consistent pivots/origins.
- Player ship origin: center of ship body.
- Bullets origin: center.
- Boss parts origin: joint/anchor point.

---

## 41. UI Deliverables

### 41.1 First Build UI Assets

- Title logo placeholder.
- Main menu panel.
- Gameplay HUD frame/side panels.
- Shield pip icons.
- Lives icon.
- Bomb icon.
- Weapon icon slot.
- Core Energy bar.
- Boss health bar.
- Warning banner.
- Pause menu panel.
- Weapon acquired screen.
- Level complete/rank screen.
- Game over screen.

### 41.2 Full Game UI Assets

- Stage select map.
- Eight boss portrait frames.
- Save slot screen.
- Options screen.
- Controls remap screen.
- Accessibility screen.
- Weapon status/pause screen.
- Lore file viewer.
- Boss Rush menu.

---

## 42. First Build Implementation Acceptance Criteria

### 42.1 Movement

Acceptance criteria:

- Player can move in 8 directions with controller and keyboard.
- Movement feels immediate and fixed-speed.
- Player cannot leave playfield.
- Ship banks left/right visually.
- Thruster animation plays during movement and idle.

### 42.2 Shooting

Acceptance criteria:

- Holding fire shoots Twin Vulcan continuously.
- Player bullets travel upward and hit enemies.
- Base weapon has at least 2 visible power levels in first build, ideally all 4.
- Holding charge and releasing fires a 3-second piercing laser.
- Charged laser damages multiple enemies.

### 42.3 Damage

Acceptance criteria:

- Player shield pips reflect selected difficulty.
- Taking damage removes shield pip or kills player if no shield remains.
- Damage triggers flicker, rumble if controller supports it, and SFX.
- Player is invulnerable for 2 seconds after hit.
- Death consumes life and respawns at checkpoint.
- Game over triggers when lives reach 0.

### 42.4 Level

Acceptance criteria:

- Intro level scrolls vertically at fixed speed.
- Contains at least 4 enemy types.
- Contains one environmental warning hazard.
- Contains one checkpoint.
- Contains one boss.
- Level can be completed from start to finish.

### 42.5 Boss

Acceptance criteria:

- Boss has visible health bar.
- Boss has at least 3 attack phases.
- Boss patterns are readable and avoidable.
- Boss has intro warning.
- Boss explodes in stages.
- Boss defeat triggers weapon acquired screen.

### 42.6 UI

Acceptance criteria:

- Title screen loads.
- Main menu starts game.
- HUD shows lives, shield, score, current weapon, energy, charge, bomb count.
- Pause menu works.
- Level complete screen shows score and rank.
- Game over screen works.

### 42.7 Debug

Acceptance criteria:

- Debug hitbox display works.
- Debug invincibility works.
- Debug jump-to-boss works.
- Debug refill shields/energy works.

### 42.8 Architecture

Acceptance criteria:

- Player, enemies, bullets, pickups, boss, HUD, and level spawner are separate systems/scenes.
- Tuning values are centralized.
- At least weapons/enemies/difficulty can be configured through data files or Godot resources.
- Folder structure follows this document.
- Code includes clear comments for future expansion.

---

## 43. MVP, Vertical Slice, Full Game, and Future Expansion

### 43.1 MVP / First Playable

Definition: One complete intro level.

Must prove:

- Movement.
- Shooting.
- Damage.
- Boss fight.
- Visual direction.
- HUD.
- Controller-first play.

### 43.2 Vertical Slice

Definition: One complete Guardian Frame level with real stage select flow.

Should include:

- Stage select placeholder.
- One full Guardian Frame level.
- One real boss weapon.
- One hidden armor module.
- One secret route.
- Save/load.
- Results screen.
- Stronger art polish.

Recommended vertical slice level: **Tempest Frame** or **Forge Frame**.

### 43.3 Full Game

Definition: Complete intended game.

Includes:

- Intro level.
- Eight Guardian Frame stages.
- Eight bosses.
- Eight weapons.
- Five hidden armor modules.
- Secrets/lore/files/energy tanks/shield tanks.
- Mandatory follow-up level.
- Two final levels.
- Boss rush.
- Hard+.
- Ending cutscenes.
- Complete save/profile system.
- Steam-ready polish.

### 43.4 Future Expansion

Possible later features:

- Local co-op.
- Daily/weekly challenge modes.
- Additional ships.
- Alternate boss patterns.
- Expanded lore archive.
- Steam achievements.
- Cloud saves.
- Mac/Linux/Steam Deck optimization.

---

## 44. Codex Implementation Prompt

Use this section as the direct instruction to Codex.

```text
Build a Godot 4.x Windows PC prototype for a vertical scrolling 2D retro-inspired shooter called Arc Frame X. The game should use a centered 4:3 gameplay field inside a 16:9 layout with side HUD panels. The first implementation should be a scalable, production-minded prototype with one complete intro level called Sky Arc Breach.

Prioritize game feel, controller-first movement, shooting, visual readability, a complete level flow, one boss fight, and clean architecture. Do not build the full eight-level game yet.

The first build must include:
- Title screen and main menu.
- Xbox controller support and keyboard fallback.
- Player ship movement with fixed-speed arcade-tight controls.
- Player ship banking animation and thruster animation.
- Twin Vulcan primary fire with unlimited ammo.
- Charged laser shot that lasts 3 seconds and pierces enemies.
- Shield/lives/death/checkpoint system.
- Three difficulty modes: Rookie, Hunter, Ace.
- One vertically scrolling intro level.
- Four to six enemy types with scripted wave spawning.
- Enemy bullets, collision, pickups, score, combo, and rank basics.
- One boss: Null Relay Seraph, with three phases and a health bar.
- Weapon acquired screen after boss defeat.
- Prototype Sonic Wave Cannon unlock after boss defeat.
- HUD with lives, shield pips, score, combo, current weapon, Core Energy, charge meter, bomb count, boss health, and warning indicators.
- Pause menu.
- Level complete screen.
- Game over screen.
- Debug tools: invincibility, show hitboxes, jump to boss, spawn wave, refill shield, refill energy, refill bomb, FPS overlay.
- Centralized data/config for player tuning, weapons, enemies, difficulty, scoring, level waves, and boss phases.
- Object pooling for bullets, explosions, pickups, and common enemies.
- Placeholder stylized sprite art generated as actual retro-inspired sprites, not simple colored geometric shapes.
- Clear folder structure and comments.
- Basic automated or debug-runner tests for configs, damage, weapon energy, and object pooling.

Use the GDD above for all naming, tuning values, systems, schemas, and acceptance criteria. Where unspecified, make practical implementation decisions that preserve expansion toward the full game.
```

---

## 45. Non-Negotiable Design Rules

1. The game is vertical scrolling.
2. The first build is one complete intro level, not the full game.
3. The player ship shoots upward by default.
4. Movement must feel arcade-tight and precise.
5. The player uses full-ship-style collision, not a tiny bullet hell core.
6. The game uses shields, lives, checkpoints, and no continues.
7. Bosses unlock weapons.
8. Weapons change the ship color palette.
9. Hidden armor modules are optional permanent upgrades.
10. The game must be controller-first.
11. Art is high-res 2D retro-inspired, not true low-res pixel art.
12. The code must be structured for easy content expansion.
13. The full game should feel like a console action game, not an arcade quarter-muncher.
14. Medium/Hunter difficulty should make each level take about 2–3 attempts for the intended player.
15. Readability is more important than spectacle.

---

## 46. Open Design Questions for Later, Not Blocking First Build

These do not block Codex from creating the first playable version:

- Exact final title.
- Exact final ending branch consequences.
- Whether Root Vault or Council Spire is canon.
- Exact number of lore files per level.
- Exact hidden boss identities.
- Steam achievement list.
- Full soundtrack composition.
- Local co-op implementation specifics.
- Daily/weekly challenge structure.
- Final save encryption/obfuscation strategy.
- Full localization list.

---

## 47. Final Creative North Star

*Arc Frame X* should feel like launching a heroic blue prototype fighter into a glowing, dangerous future — a fast, readable, colorful shooter where every defeated machine god changes what the ship can do and what the player understands about the world.

At first, the fantasy is simple:

> Fly upward. Dodge fire. Destroy the corrupted Frame. Take its power.

By the end, the fantasy becomes deeper:

> The ship was never just a weapon. The enemy was never just infected. And Earth was never dead.


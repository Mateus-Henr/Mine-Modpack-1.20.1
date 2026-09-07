# Hearthbound — reset the Ender Dragon fight in place, WITHOUT killing the dragon.
#   /function hearthbound:reset_dragon
# Safe to run from anywhere: every selector is scoped to the End explicitly.

# 1. Remove a stranded True Ending decoy dragon. Tag-filtered — the real dragon
#    never carries trueEnding_mirrordragon, so this cannot touch it. Decoys are
#    Invulnerable and, having AI, can steal Savage Ender Dragon's dragonEntity
#    reference if left behind.
execute in minecraft:the_end run kill @e[type=ender_dragon,tag=trueEnding_mirrordragon]

# 2. Back to normal flight, out of any attack. True Ending's own function:
#    sets bosstime 219, removes trueEnding_inattack, DragonPhase -> 1.
execute in minecraft:the_end run function true_ending:commands/phase_normal

# 3. Clear the milestone markers phase_normal does not touch. These are
#    "already fired" flags — left set, the half/quarter-health attacks stay
#    permanently spent even at full health.
execute in minecraft:the_end run tag @e[type=ender_dragon] remove trueEnding_halfhealth
execute in minecraft:the_end run tag @e[type=ender_dragon] remove trueEnding_quarterhealth
execute in minecraft:the_end run tag @e[type=ender_dragon] remove trueEnding_inattack_tripledive
execute in minecraft:the_end run tag @e[type=ender_dragon] remove trueEnding_dragon_noAI
execute in minecraft:the_end run scoreboard players set @e[type=ender_dragon] trueEnding_bosstime2 0

# 4. Clear leftover adds. Phantoms and blazes do not spawn naturally in the End,
#    so this only removes fight spawns. Endermen are deliberately NOT touched —
#    Savage's melee adds are plain endermen and are indistinguishable from
#    natural ones, so killing them would wipe enderman farms too.
execute in minecraft:the_end positioned 0 64 0 run kill @e[type=phantom,distance=..256]
execute in minecraft:the_end positioned 0 64 0 run kill @e[type=blaze,distance=..256]

# 5. The reset itself. Dropping this tag makes True Ending re-run
#    boss/dragon_entity_spawn on the next tick: max_health Base re-read from the
#    dragonhealth scoreboard, Health set to full, knockback_resistance 300,
#    totem of undying restored, and all 10 pillar markers re-registered.
execute in minecraft:the_end run tag @e[type=ender_dragon] remove trueEnding_dragon_particlechecked

tellraw @a {"text":"[Hearthbound] Dragon fight reset — full health next tick, dragon not killed.","color":"light_purple"}

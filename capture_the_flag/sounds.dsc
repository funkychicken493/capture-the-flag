gun_sounds:
    type: data

    generic_revolver:
        - playsound <player.location> sound:entity_firework_rocket_blast pitch:2.0 sound_category:master volume:2.0
    generic_revolver_rl_1:
        - playsound <player.location> sound:entity_zombie_attack_wooden_door pitch:0.5 sound_category:master volume:2.0
    generic_revolver_rl_2:
        - playsound <player.location> sound:entity_zombie_attack_wooden_door pitch:2.0 sound_category:master volume:2.0

    generic_smg:
        - playsound <player.location> sound:entity_firework_rocket_blast_far pitch:1.5 sound_category:master volume:2.0
    generic_shotgun:
        - playsound <player.location> sound:entity_firework_rocket_blast_far pitch:0.5 sound_category:master volume:2.0

gun_sounds_need_reload:
    type: task
    debug: false
    script:
        - random:
            - playsound <player> sound:entity_villager_no pitch:2.0 sound_category:master volume:2.0
            - playsound <player> sound:entity_chicken_hurt pitch:1.5 sound_category:master volume:2.0
            - playsound <player> sound:item_shield_break pitch:1.5 sound_category:master volume:2.0
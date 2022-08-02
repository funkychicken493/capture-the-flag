gun_events:
    type: world
    debug: true
    events:
        on player right clicks block:
            - if !<context.item.has_flag[gun]>:
                - stop

            #Check that the player does not currently have a gun on cooldown
            - if <player.item_cooldown[<context.item.material>].in_ticks> > 0:
                - stop

            - determine passively cancelled

            #Grab the map containing all of the gun information
            - define gun <context.item.flag[gun]>
            - define type <[gun].get[type]>
            - define firerate <[gun].get[firerate]>
            - define damage <[gun].get[damage]>
            - define bullet_spread <[gun].get[spread]>
            - define bullet_range <[gun].get[range]>
            - define bullets_per_shot <[gun].get[count]>
            - define fire_sound_path <[gun].get[fire_sound_path]>
            - define clip_size <[gun].get[clip]>

            #Grab the map containing the data that is SPECIFIC to the gun (e.g. ammo)
            - define gun_data <context.item.flag[gun_data]>
            - define bullets_left <[gun_data].get[bullets_left]>

            #Tell the player to reload if they have no bullets left
            - if <[bullets_left]> == 0:
                - title title:<red>RELOAD targets:<player> fade_in:1t fade_out:1t stay:1s
                - playsound <player> sound:entity_villager_no pitch:<element[1.5].mul[<util.random.int[0.5].to[1.5]>]>
                - stop

            #Use archaic item cooldowns to prevent players from spamming the gun
            - itemcooldown <context.item.material> duration:<[firerate]>s
            - inventory flag slot:hand gun_data.bullets_left:<[bullets_left].sub[1]>

            #Play the fire sound
            - inject gun_sounds path:<[fire_sound_path]>

            - repeat <[bullets_per_shot]>:
                #Raytrace to find the impact point
                - define impact <player.eye_location.ray_trace[range=<[bullet_range]>;ignore=<player>;entities=*;fluids=true;nonsolids=true].if_null[null]>
                #If the impact is absent, the bullet will travel straight to the end of the range
                - if <[impact]> == null:
                    - define impact <player.eye_location.forward[<[bullet_range]>]>
                #Apply bullet spread, just randomly offset the impact location
                - if <[bullet_spread]> != 0:
                    - define impact <[impact].random_offset[<[bullet_spread]>,<[bullet_spread]>,<[bullet_spread]>]>
                - playeffect effect:crit offset:0 at:<player.eye_location.points_between[<[impact].forward[0.1]>].distance[0.4]>
                - foreach <[impact].find_entities[*].within[0.2]> as:entity:
                    #Check that the entity is living, if so, deal damage to it
                    - if <[entity].is_living>:
                        - hurt <[damage]> <[entity]> source:<player>

        on player left clicks block:
            #Get the item in the player's hand
            - define item <context.item.if_null[<player.item_in_hand>]>
            - if !<[item].has_flag[gun]>:
                - stop

            #Check that the player does not currently have a gun on cooldown
            - if <player.item_cooldown[<[item].material>].in_ticks> > 0:
                - stop

            - determine passively cancelled

            #Grab gun information or whatever
            - define gun <[item].flag[gun]>
            - define clip_size <[gun].get[clip]>
            - define reload_time <[gun].get[reload]>
            - define reload_sound_path <[gun].get[reload_start_sound_path]>
            - define reload_end_sound_path <[gun].get[reload_end_sound_path]>

            #Grab the gun data
            - define gun_data <[item].flag[gun_data]>
            - define bullets_left <[gun_data].get[bullets_left]>

            #If the player's magazine is full, no reloading required
            - if <[bullets_left]> == <[clip_size]>:
                - stop

            - title title:<yellow>RELOADING... targets:<player> fade_in:1t fade_out:1t stay:1s
            - inject gun_sounds path:<[reload_sound_path]>
            - itemcooldown <[item].material> duration:<[reload_time]>s
            - inventory flag slot:hand gun_data.bullets_left:<[clip_size]>
            - wait <[reload_time]>s
            - title title:<green>RELOADED targets:<player> fade_in:1t fade_out:1t stay:1s
            - inject gun_sounds path:<[reload_end_sound_path]>

gun_bullet_counter:
    type: world
    debug: false
    events:
        after tick every:5:
            - foreach <server.online_players> as:__player:
                - if <player.item_in_hand.has_flag[gun].not>:
                    - actionbar <empty> targets:<player>
                    - foreach next
                - foreach next if:<player.item_in_hand.has_flag[gun].not>
                - define gun <player.item_in_hand.flag[gun]>
                - define clip_size <[gun].get[clip]>
                - define gun_data <player.item_in_hand.flag[gun_data]>
                - define bullets_left <[gun_data].get[bullets_left]>
                - if <[bullets_left]> == <[clip_size]>:
                    - actionbar "<green><bold><[bullets_left]> <gray>| <gold><bold><[clip_size]>"
                - else if <[bullets_left]> > 0:
                    - actionbar "<yellow><bold><[bullets_left]> <gray>| <gold><bold><[clip_size]>"
                - else:
                    - actionbar "<red><bold><[bullets_left]> <gray>| <gold><bold><[clip_size]>"

base_gun:
    type: item
    material: wooden_hoe
    mechanisms:
        unbreakable: false
        hides: enchants|attributes|unbreakable
    enchantments:
        - unbreaking:1

default_revolver:
    type: item
    material: base_gun
    display name: <gold>Default Revolver
    flags:
        gun_data:
            bullets_left: 0
        gun:
            type: revolver
            fire_sound_path: generic_revolver
            #Time between shots in seconds
            firerate: 0.5
            #Bullet damage
            damage: 10
            #Bullet spread
            spread: 0.01
            #Bullet range
            range: 100
            #Bullet count
            count: 1
            #Shots per clip
            clip: 6
            #Reload time in seconds
            reload: 2.0
            #Reload sound path
            reload_sound_path: generic_revolver

default_smg:
    type: item
    material: base_gun
    display name: <gold>Default SMG
    flags:
        gun_data:
            bullets_left: 0
        gun:
            type: smg
            fire_sound_path: generic_smg
            #Time between shots in seconds
            firerate: 0.05
            #Bullet damage
            damage: 10
            #Bullet spread
            spread: 1.0
            #Bullet range
            range: 75
            #Bullet count
            count: 1
            #Shots per clip
            clip: 30
            #Reload time in seconds
            reload: 2.0
            #Reload sound path
            reload_sound_path: generic_smg

default_shotgun:
    type: item
    material: base_gun
    display name: <gold>Default Shotgun
    flags:
        gun_data:
            bullets_left: 0
        gun:
            type: shotgun
            fire_sound_path: generic_shotgun
            #Time between shots in seconds
            firerate: 0.5
            #Bullet damage
            damage: 15
            #Bullet spread
            spread: 1.13
            #Bullet range
            range: 20
            #Bullet count
            count: 7
            #Shots per clip
            clip: 6
            #Reload time in seconds
            reload: 2.0
            #Reload sound path
            reload_start_sound_path: generic_shotgun
            #Reload complete sound path
            reload_end_sound_path: generic_shotgun


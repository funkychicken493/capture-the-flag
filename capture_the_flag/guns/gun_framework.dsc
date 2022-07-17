default_revolver:
    type: item
    material: wooden_hoe
    mechanisms:
        unbreakable: false
        hides: enchants|attributes|unbreakable
    display name: <gold>Default Revolver
    enchantments:
        - unbreaking:1
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
    material: wooden_hoe
    mechanisms:
        unbreakable: false
        hides: enchants|attributes|unbreakable
    display name: <gold>Default SMG
    enchantments:
        - unbreaking:1
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
    material: wooden_hoe
    mechanisms:
        unbreakable: false
        hides: enchants|attributes|unbreakable
    display name: <gold>Default Shotgun
    enchantments:
        - unbreaking:1
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
            spread: 0.7
            #Bullet range
            range: 20
            #Bullet count
            count: 7
            #Shots per clip
            clip: 6
            #Reload time in seconds
            reload: 2.0
            #Reload sound path
            reload_sound_path: generic_shotgun

gun_events:
    type: world
    debug: true
    events:
        on player right clicks block:
            - if !<context.item.has_flag[gun]>:
                - stop

            - if <player.item_cooldown[<context.item.material>].in_ticks> > 0:
                - stop

            - determine passively cancelled
            - define gun <context.item.flag[gun]>
            - define type <[gun].get[type]>
            - define firerate <[gun].get[firerate]>
            - define damage <[gun].get[damage]>
            - define bullet_spread <[gun].get[spread]>
            - define bullet_range <[gun].get[range]>
            - define bullets_per_shot <[gun].get[count]>
            - define fire_sound_path <[gun].get[fire_sound_path]>

            - define gun_data <[gun].get[gun_data]>
            - define bullets_left <[gun_data].get[bullets_left]>
            - if <[bullets_left]> == 0:
                - title <red>RELOAD 1s targets:<player>
                - playsound <player> sound:entity_villager_no pitch:<element[1.5].mul[<util.random.int[0.5].to[1.5]>]>
                - stop

            - itemcooldown <context.item.material> duration:<[firerate]>s

            - inject gun_sounds path:<[fire_sound_path]>

            - repeat <[bullets_per_shot]>:
                - define hit <player.eye_location.ray_trace[range=<[bullet_range]>;ignore=<player>;entities=*;fluids=true;nonsolids=true].if_null[null]>
                - if <[hit]> == null:
                    - repeat next
                - if <[bullet_spread]> != 0:
                    - define hit <[hit].random_offset[<[bullet_spread]>,<[bullet_spread]>,<[bullet_spread]>]>
                - playeffect effect:crit offset:0 at:<player.eye_location.points_between[<[hit].forward[0.1]>].distance[0.4]>
                - foreach <[hit].find_entities[*].within[0.2]> as:entity:
                    - if <[entity].is_living>:
                        - hurt <[damage]> <[entity]> source:<player>

gun_bullet_counter:
    type: world
    debug: false
    events:
        after player holds item:
            - define item <player.inventory.slot[<context.new_slot>]>
            - if !<[item].has_flag[gun]>:
                - stop
            - define gun_data <[item].flag[gun_data]>
            - define gun <[item].flag[gun]>
            - define clip_size <[gun].get[clip]>

            - while <player.exists> && <player.inventory.slot[<player.held_item_slot>]> == <[item]>:
                - define bullets_left <[gun_data].get[bullets_left]>
                - if <[bullets_left]> != 0:
                    - actionbar "<green><bold><[bullets_left]> <gray>| <gold><bold><[clip_size]>"
                - else:
                    - actionbar "<red><bold><[bullets_left]> <gray>| <gold><bold><[clip_size]>"
                - wait 5t
            - if <player.exists>:
                - actionbar <empty>


copper_ar:
    type: item
    material: wooden_hoe
    mechanisms:
        unbreakable: false
        hides: enchants|attributes|unbreakable
    display name: <gold>Copper Assault Rifle
    enchantments:
        - unbreaking:1
    flags:
        gun_item: true
        ar: true

copper_ar_events:
    type: world
    debug: false
    events:
        on player right clicks block with:copper_ar:
            - determine passively cancelled
            - stop if:<player.item_cooldown[<context.item.material>].in_ticks.is_more_than[0]>
            - if <player.item_in_hand.durability> >= <player.item_in_hand.max_durability>:
                - title "subtitle:<red>Left click to reload!" stay:0.5s
                - itemcooldown <context.item.material> duration:0.5s
                - playsound <player.location> sound:block_anvil_land pitch:0.7
                - stop
            - itemcooldown <context.item.material> duration:0.2s
            - playeffect at:<player.eye_location.points_between[<player.eye_location.precise_cursor_on[50000].if_null[<player.location.forward[50]>]>].distance[0.4].remove[1|2|3]> effect:item_crack special_data:copper_ingot quantity:1 offset:0,0,0
            - if <player.eye_location.precise_cursor_on[50000].if_null[<player.location.with_yaw[5000]>].find_entities[!dropped_item].within[0.7].exclude[<player>].is_empty.not>:
                - hurt 4 <player.eye_location.precise_cursor_on[50000].if_null[<player.location.with_yaw[5000]>].find_entities[!dropped_item].within[0.7].exclude[<player>]>
                - playsound <player> sound:entity_experience_orb_pickup
            - else if <player.target[!dropped_item].exists>:
                - hurt 6 <player.target>
                - playsound <player> sound:entity_experience_orb_pickup
            #- take slot:<player.held_item_slot> quantity:1 from:<player.inventory>
            #- wait 1t
            #- give <context.item.with[durability=<context.item.durability.add[<context.item.max_durability.div[30].round_down>].min[<context.item.material.max_durability>]>]> slot:<player.held_item_slot>
            - inventory adjust durability:<context.item.durability.add[<context.item.max_durability.div[30].round_up>].min[<context.item.material.max_durability>]> slot:<player.held_item_slot>
            - playsound <player.location> sound:entity_blaze_hurt pitch:1 volume:0.5
            - playsound <player.location> sound:entity_firework_rocket_large_blast_far pitch:0.7 volume:2
            - playsound <player.location> sound:block_stone_break pitch:1 volume:0.5
        on player left clicks block with:copper_ar:
            - determine passively cancelled
            - stop if:<player.item_cooldown[<context.item.material>].in_ticks.is_more_than[0]>
            - stop if:<context.item.durability.equals[0]>
            - take slot:<player.held_item_slot> quantity:1 from:<player.inventory>
            - give <context.item.with[durability=0]> slot:<player.held_item_slot>
            - playsound <player.location> sound:entity_zombie_break_wooden_door pitch:0.8
            - itemcooldown <context.item.material> duration:<util.random.int[5].to[8]>s
            - while <player.item_cooldown[<context.item.material>].in_ticks.is_more_than[5]>:
                - wait 0.5s
                - if <player.item_in_hand.script.name.if_null[null]> == copper_ar:
                    - playsound <player.location> sound:entity_zombie_attack_wooden_door pitch:2 volume:0.5
            - playsound <player.location> sound:entity_zombie_break_wooden_door pitch:1.7

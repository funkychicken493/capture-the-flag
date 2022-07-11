#Create a new trap that will summon 3 random hostile mobs of the same type
#Name should be kept the same because I like it.
party_cage:
    type: item
    material: note_block
    mechanisms:
        hides: all
    display name: <blue>Party Cage
    lore:
        - Activate this note block...
    enchantments:
        - unbreaking:1
    flags:
        #Redundant flag, but it's here for completeness.
        party_cage: true

#Events for the party cage trap to prevent accidental breakage and summon mobs.
party_cage_events:
    type: world
    debug: false
    events:
        on player places party_cage:
            #Identify the location as a party cage trap
            - flag <context.location> party_cage
            - flag <context.location> trap
        on noteblock plays note location_flagged:party_cage:
            - determine passively cancelled

            #Remove the party cage trap identification flags
            - flag <context.location> party_cage:!
            - flag <context.location> trap:!

            #Remove the note block
            - modifyblock <context.location> air

            #Play a sound on activation
            #Sound is currently the same as the boom box sound, change it at some point.
            - playsound <context.location> sound:block_wood_break volume:2

            #This entire process should be removed and put in it's own event.
            #Initialize the list of the server's hostile mobs.
            - define hostile <list[]>
            #For each mob in the server, if it is hostile then add it to the hostile list.
            - foreach <server.entity_types>:
                #Ensure that the mob is hostile and not a boss or a removed mob.
                - if <entity[<[value]>].is_monster> && <entity[<[value]>].entity_type> not in wither|ender_dragon|giant|elder_guardian|illusioner:
                    - define hostile <[hostile].include[<entity[<[value]>].with[health_data=1/1].with[flag_map=<map[party_cage_mob=true]>]>]>
            #Play a sound just after the hostile mobs are identified, this is entirely redundant because the sound is played at the same tick as the activation sound. Remove this later.
            - playsound <context.location> sound:entity_witch_celebrate pitch:2

            #Spawn three of the randomly selected hostile mobs.
            - spawn <[hostile].random[1].get[1].repeat_as_list[3]> <context.location.center> target:<context.location.find_players_within[50].get[1].if_null[]>
        #Stop the party cage trap from burning down.
        on block burns location_flagged:party_cage:
            - determine cancelled
        #Redundant event, completely unnecessary, going to keep anyways.
        on block ignites location_flagged:party_cage:
            - determine cancelled
        #Stop the party cage trap from being pushed or pulled by a piston.
        on piston extends:
            - foreach <context.blocks>:
                - if <[value].has_flag[party_cage]>:
                    - determine cancelled
        on piston retracts:
            - foreach <context.blocks>:
                - if <[value].has_flag[party_cage]>:
                    - determine cancelled
        #Destroy the trap properly if it is destroyed by an explosion.
        on block destroyed by explosion location_flagged:party_cage:
            - flag <context.location> party_cage:!
            - flag <context.location> trap:!
        #When a mob with the party_cage_mob flag is killed, remove the drops of that mob.
        on entity dies:
            - if <context.entity.has_flag[party_cage_mob]>:
                - determine NO_DROPS
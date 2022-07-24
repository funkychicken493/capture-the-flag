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
        trap: party_cage

#Events for the party cage trap to summon mobs.
party_cage_events:
    type: world
    debug: false
    events:
        on noteblock plays note location_flagged:trap.party_cage:
            - determine passively cancelled

            - flag <context.location> trap:!
            - modifyblock <context.location> air
            - playsound <context.location> sound:block_wood_break volume:2

            #This entire process should be removed and put in it's own event.
            #Initialize the list of the server's hostile mobs.
            - define hostile <server.flag[party_cage_hostile]>

            #Spawn three of the randomly selected hostile mobs.
            - spawn <[hostile].random[1].get[1].repeat_as_list[3]> <context.location.center> target:<context.location.find_players_within[50].get[1].if_null[]>

        #When a mob with the party_cage_mob flag is killed, remove the drops of that mob.
        on entity dies:
            - if <context.entity.has_flag[party_cage_mob]>:
                - determine NO_DROPS

        after script reload:
            - define hostile <list[]>
            - foreach <server.entity_types>:
                #Ensure that the mob is hostile and not a boss or a removed mob.
                - if <entity[<[value]>].is_monster> && <entity[<[value]>].entity_type> not in wither|ender_dragon|giant|elder_guardian|illusioner:
                    - define hostile <[hostile].include[<entity[<[value]>].with[health_data=1/1].with[flag_map=<map[party_cage_mob=true]>]>]>
            - flag server party_cage_hostile:<[hostile]>
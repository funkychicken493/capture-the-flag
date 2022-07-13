#Create a trap that summons a small army of zombies when triggered.
#Awful external name for players, needs to be changed.
hazardous_waste:
    type: item
    material: note_block
    mechanisms:
        hides: all
    display name: <blue>Hazardous Waste
    lore:
        - Activate this note block...
    enchantments:
        - unbreaking:1
    flags:
        #Redundant flag, doesn't do anything. Should be removed.
        hazardous_waste: true

#Events for the hazardous waste trap.
hazardous_waste_events:
    type: world
    debug: true
    events:
        on player places hazardous_waste:
            #Identify the location as a trap on placement
            - flag <context.location> hazardous_waste
            - flag <context.location> trap
        on noteblock plays note location_flagged:hazardous_waste:
            - determine passively cancelled

            #Remove identifying flags from the location
            - flag <context.location> hazardous_waste:!
            - flag <context.location> trap:!

            #Remove the note block
            - modifyblock <context.location> air

            #Plays a sound effect when activated
            #Sound effect is the same as boom box trap, should be changed.
            - playsound <context.location> sound:block_wood_break volume:2

            #Spawns a zombie army of 5 at the location
            - repeat 5:
                #Spawn regular zombie
                - spawn zombie <context.location.center> target:<context.location.find_players_within[50].get[1].if_null[]>
                - playsound <context.location> sound:entity_zombie_break_wooden_door pitch:1 volume:2
                - wait 1s
        #Stop block from burning
        on block burns location_flagged:hazardous_waste:
            - determine cancelled
        #Redundant event, might be removed.
        on block ignites location_flagged:hazardous_waste:
            - determine cancelled
        #Stops the trap from being pushed/pulled by a piston
        on piston extends:
            - foreach <context.blocks>:
                - if <[value].has_flag[hazardous_waste]>:
                    - determine cancelled
        on piston retracts:
            - foreach <context.blocks>:
                - if <[value].has_flag[hazardous_waste]>:
                    - determine cancelled
        #Destroy the trap properly when it is blown up
        on block destroyed by explosion location_flagged:hazardous_waste:
            - flag <context.location> hazardous_waste:!
            - flag <context.location> trap:!
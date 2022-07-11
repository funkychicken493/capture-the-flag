#Create new trap dusty waste, needs better name externally
#Same format as previous traps, but with a different name
dusty_waste:
    type: item
    material: note_block
    mechanisms:
        hides: all
    display name: <blue>Dusty Waste
    lore:
        - Activate this note block...
    enchantments:
        - unbreaking:1
    flags:
        #Redundant flag, should be removed soon
        dusty_waste: true

#Events for the dusty waste trap
dusty_waste_events:
    type: world
    debug: true
    events:
        on player places dusty_waste:
            #Identify the trap as a trap for use in other events
            - flag <context.location> dusty_waste
            - flag <context.location> trap
        #When the block is right clicked or pulsed, the trap is activated
        on noteblock plays note location_flagged:dusty_waste:
            - determine passively cancelled

            #Remove identity flags of the trap location
            - flag <context.location> dusty_waste:!
            - flag <context.location> trap:!

            #Remove the trap block
            - modifyblock <context.location> air

            #Play sound effect when activated, same as boom box trap, need to change this
            - playsound <context.location> sound:block_wood_break volume:2

            #Spawn 10 special entities with a delay of 0.5 seconds
            #Plays skeleton ambient sound, need to make this more unique and complex
            - repeat 10:
                #Spawn the special skeleton entity
                - spawn dusty_waste_skeleton <context.location.center> target:<context.location.find_players_within[50].get[1].if_null[]>
                - playsound <context.location> sound:entity_skeleton_ambient pitch:2 volume:2
                - wait 0.5s
        #Stop the trap from burning
        on block burns location_flagged:dusty_waste:
            - determine cancelled
        #Redundant event, keep for now
        on block ignites location_flagged:dusty_waste:
            - determine cancelled
        #Stop the trap from being pushed or pulled by pistons
        on piston extends:
            - foreach <context.blocks>:
                - if <[value].has_flag[dusty_waste]>:
                    - determine cancelled
        on piston retracts:
            - foreach <context.blocks>:
                - if <[value].has_flag[dusty_waste]>:
                    - determine cancelled
        #Destroy the trap properly when it is blown up
        on block destroyed by explosion location_flagged:dusty_waste:
            - flag <context.location> dusty_waste:!
            - flag <context.location> trap:!
        #Stop the special skeleton entities from burning
        on dusty_waste_skeleton combusts:
            - determine cancelled
        #Make it so the special skeleton entities don't drop items
        on dusty_waste_skeleton dies:
            - determine NO_DROPS

dusty_waste_skeleton:
    type: entity
    entity_type: skeleton
    mechanisms:
        #Give the skeleton a total health of one heart
        health_data: 2/2
        #Give the skeleton a sword instead of a bow
        item_in_hand: stone_sword
        #Ensure the skeleton does not spawn with armor
        equipment:
            head: air
            chestplate: air
            leggings: air
            boots: air
        #Make the skeleton faster than normal
        speed: 0.5
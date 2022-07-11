#Item creation for trap "Boom Box"
#Trap will spawn multiple primed tnt entities with a delay between each
#Trap will play a sound when activated
#Trap will play a sound after spawning a primed tnt entity
boom_box:
    type: item
    material: note_block
    mechanisms:
        hides: all
    display name: <blue>Boom Box
    lore:
        - Activate this note block...
    enchantments:
        - unbreaking:1
    flags:
        #Emergency flag that allows for a check if the item is itself
        #Probably useless, may come in handy later
        boom_box: true

#This is the code that will be executed when the trap is activated
boom_box_events:
    type: world
    debug: true
    events:
        on player places boom_box:
            #Flag the location with identification flags when placed
            - flag <context.location> boom_box
            - flag <context.location> trap
        #Event to trigger the trap and summon primed tnt entities
        #Does not specifically handle the player right clicking the block, but rather the block itself being triggered by anything
        on noteblock plays note location_flagged:boom_box:
            - determine passively cancelled
            #Remove the identification flags when the trap is activated
            - flag <context.location> boom_box:!
            - flag <context.location> trap:!

            #Break the note block so that it won't exist in world
            - modifyblock <context.location> air

            #Initial sound when the trap is activated
            - playsound <context.location> sound:block_wood_break volume:2
            #Start the timer for the spawning of the primed tnt entities
            - repeat 10:
                - spawn boom_box_tnt <context.location.center>
                - playsound <context.location> sound:block_chest_locked pitch:0.5 volume:2
                - wait 0.3s
        #Stop location from burning
        on block burns location_flagged:boom_box:
            - determine cancelled
        #Useless, block does not ignite, may come in use in extremely weird cases
        on block ignites location_flagged:boom_box:
            - determine cancelled
        #Events to stop piston from moving when block is pushed
        on piston extends:
            - foreach <context.blocks>:
                - if <[value].has_flag[boom_box]>:
                    - determine cancelled
        on piston retracts:
            - foreach <context.blocks>:
                - if <[value].has_flag[boom_box]>:
                    - determine cancelled
        #Break block properly when exploded
        on block destroyed by explosion location_flagged:boom_box:
            - flag <context.location> boom_box:!
            - flag <context.location> trap:!
        #Stops the tnt entity from breaking block on explosion
        on boom_box_tnt explodes:
            - determine <list[]>

#Entity script for the primed tnt entity spawned by the trap
#Serves no purpose other than to make the primed tnt entity explode without breaking blocks
boom_box_tnt:
    type: entity
    entity_type: primed_tnt
    flags:
        #Redundant flag, but may come in use for future features
        boom_box_tnt: true
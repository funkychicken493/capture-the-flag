#Item creation for trap "Boom Box"
#Trap will spawn multiple primed tnt entities with a delay between each
#Trap will play a sound when activated
#Trap will play a sound after spawning a primed tnt entity
boom_box:
    type: item
    material: note_block
    mechanisms:
        hides: all
    display name: <blue>Boom Box Trap
    lore:
        - Spawns ten primed TNT that will not damage the environment.
    enchantments:
        - unbreaking:1
    flags:
        trap:
            boom_box: true

#This is the code that will be executed when the trap is activated
boom_box_events:
    type: world
    debug: true
    events:
        #Event to trigger the trap and summon primed tnt entities
        on noteblock plays note location_flagged:trap.boom_box:
            #Start the timer for the spawning of the primed tnt entities
            - repeat 10:
                - spawn boom_box_tnt <context.location.center>
                - playsound <context.location> sound:block_chest_locked pitch:0.5 volume:2
                - wait 0.3s

        #Stops the tnt entity from breaking blocks on explosion
        on boom_box_tnt explodes:
            - determine <list[]>

#Entity script for the primed tnt entity spawned by the trap
#Serves no purpose other than to make the primed tnt entity explode without breaking blocks
boom_box_tnt:
    type: entity
    entity_type: primed_tnt
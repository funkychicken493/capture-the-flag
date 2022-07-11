#Item creation for trap "drip_bomb", or as it is called in the game, "dripsplosion"
#This trap will be used to create a small explosion and summon many falling dripstone blocks
drip_bomb:
    type: item
    material: note_block
    mechanisms:
        hides: all
    display name: <blue>Dripsplosion
    lore:
        - Activate this note block...
    enchantments:
        - unbreaking:1
    flags:
        #Useless flag, but might be useful in the future
        drip_bomb: true

#Events for the drip_bomb item's mechanics
drip_bomb_events:
    type: world
    debug: true
    events:
        on player places drip_bomb:
            #Identify the location using flags
            - flag <context.location> drip_bomb
            - flag <context.location> trap
        #Activates when the player right clicks the note block or it is pulsed
        on noteblock plays note location_flagged:drip_bomb:
            - determine passively cancelled

            #Remove identifying flags from the location
            - flag <context.location> drip_bomb:!
            - flag <context.location> trap:!

            #Remove the note block
            - modifyblock <context.location> air

            #Play a sound once activated
            - playsound <context.location> sound:block_wood_break volume:2
            #Summon a total of 45 falling blocks with 15 being pointed dripstone and 30 being regular dripstone
            - repeat 15:
                #Redundant listtag, should be removed
                - spawn <list[<entity[falling_block].with[fallingblock_type=pointed_dripstone]>|].random> <context.location.center.add[0,1,0].random_offset[1]>
            - repeat 30:
                #Another redundant listtag, should be removed
                - spawn <list[<entity[falling_block].with[fallingblock_type=dripstone_block]>|].random> <context.location.center.add[0,1,0].random_offset[1]>

            #Create a small explosion to send the falling blocks flying
            - explode power:2 <context.location.above.center>
        #Cancel the burning of the trap
        on block burns location_flagged:drip_bomb:
            - determine cancelled
        #Redundant event, keep for now
        on block ignites location_flagged:drip_bomb:
            - determine cancelled
        #Stop pistons from pushing the trap around
        on piston extends:
            - foreach <context.blocks>:
                - if <[value].has_flag[drip_bomb]>:
                    - determine cancelled
        on piston retracts:
            - foreach <context.blocks>:
                - if <[value].has_flag[drip_bomb]>:
                    - determine cancelled

        #Break the trap properly when it is destroyed by an explosion
        on block destroyed by explosion location_flagged:drip_bomb:
            - flag <context.location> drip_bomb:!
            - flag <context.location> trap:!
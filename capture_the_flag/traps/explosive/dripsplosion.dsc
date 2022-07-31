#Item creation for trap "drip_bomb", or as it is called in the game, "dripsplosion"
#This trap will be used to create a small explosion and summon many falling dripstone blocks
drip_bomb:
    type: item
    material: note_block
    mechanisms:
        hides: all
    display name: <blue>Dripsplosion Trap
    lore:
        - Launches a ton of dripstone blocks around!
    enchantments:
        - unbreaking:1
    flags:
        trap:
            drip_bomb: true

#Events for the drip_bomb item's mechanics
drip_bomb_events:
    type: world
    debug: true
    events:
        #Activates when the player right clicks the note block or it is pulsed
        on noteblock plays note location_flagged:trap.drip_bomb:
            #Summon a total of 45 falling blocks with 15 being pointed dripstone and 30 being regular dripstone
            - repeat 15:
                - spawn <entity[falling_block].with[fallingblock_type=pointed_dripstone]> <context.location.center.add[0,1,0].random_offset[1]>
            - repeat 30:
                - spawn <entity[falling_block].with[fallingblock_type=dripstone_block]> <context.location.center.add[0,1,0].random_offset[1]>

            #Create a small explosion to send the falling blocks flying
            - explode power:2 <context.location.above.center>
#Simple script to remind players to stay hydrated with a small buff to water bottles in game.
drink_water:
    type: world
    debug: false
    events:
        after player consumes potion:
            - if <context.item.effects_data.get[1].get[type]> == WATER:
                #if the player consumed a water bottle, then add a small buff to their health
                - cast REGENERATION <player> amplifier:0 duration:10s
                - cast ABSORPTION <player> amplifier:0 duration:10s
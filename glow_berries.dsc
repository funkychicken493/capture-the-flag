#Picky script that simply gives the glowing effect to the player once they eat glow berries.
glow_berries_glow:
    type: world
    debug: false
    events:
        after player consumes glow_berries:
            #Give the player the glowing effect.
            - cast glowing duration:10s <player>
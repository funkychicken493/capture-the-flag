world_unloading:
    type: world
    debug: true
    events:
        on player teleports:
            - if <context.destination.world> != <context.origin.world> && <context.origin.world.players.size> <= 1 && <context.origin.world.name> != hub:
                - announce to_console "Unloading world <&sq><context.origin.world.name><&sq>"
                - adjust <context.origin.world> unload

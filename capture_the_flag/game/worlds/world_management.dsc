world_unloading:
    type: world
    debug: true
    events:
        after player teleports:
            - wait 10t
            - if <context.destination.world> != <context.origin.world> && <context.origin.world.players.size> <= 1 && <context.origin.world.name> != hub:
                - announce to_console "Unloading world <&sq><context.origin.world.name><&sq>"
                - adjust <context.origin.world> unload

world_creation_handler:
    type: task
    debug: true
    script:
        - define privacy <[privacy]>
        - define world_uuid <util.random_uuid.split[-].get[1]>
        - ~createworld ctfinstances/<[world_uuid]>
        - define nw <world[ctfinstances/<[world_uuid]>]>
        - adjust <[nw]> save
        - adjust <[nw]> keep_spawn:false
        - worldborder <[nw]> center:<location[0,0,0]> size:1000
        - announce to_console "World created with name <[nw].name>"

        - flag <player> hosting_games:<list[]> if:<player.has_flag[hosting_games].not>
        - flag <player> hosting_games:->:<[nw]>

        - flag <[nw]> invited_players:<list[<player>]>
        - flag <[nw]> host:<player>
        - flag <[nw]> private:<[privacy].if_null[false]>
        - flag <[nw]> date:<util.time_now>
        - flag <[nw]> paused:false

        - flag server active_games:<list[]> if:<server.has_flag[active_games].not>
        - flag server active_games:<server.flag[active_games].include[<[nw]>]>

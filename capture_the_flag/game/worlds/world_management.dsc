world_unloading:
    type: world
    debug: true
    events:
        on player teleports:
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
        - adjust <world[ctfinstances/<[world_uuid]>]> save
        - adjust <world[ctfinstances/<[world_uuid]>]> keep_spawn:false
        - worldborder <world[ctfinstances/<[world_uuid]>]> center:<location[0,0,0]> size:1000
        - announce to_console "World created with name 'ctfinstances/<[world_uuid]>'"
        - flag player hosting_games:<list[]> if:<player.has_flag[hosting_games].not>
        - flag <player> hosting_games:->:<world[ctfinstances/<[world_uuid]>]>
        - flag <world[ctfinstances/<[world_uuid]>]> invited_players:<list[<player>]>
        - flag <world[ctfinstances/<[world_uuid]>]> host:<player>
        - flag <world[ctfinstances/<[world_uuid]>]> private:<[privacy].if_null[false]>
        - flag server active_games:<list[]> if:<server.has_flag[active_games].not>
        - flag server active_games:<server.flag[active_games].include[<world[ctfinstances/<[world_uuid]>]>]>
        - flag <world[ctfinstances/<[world_uuid]>]> date:<util.time_now>
        - flag <world[ctfinstances/<[world_uuid]>]> paused:false
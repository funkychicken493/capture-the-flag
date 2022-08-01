ctf_command:
    type: command
    name: ctf
    description: All purpose command for Capture The Flag.
    usage: /ctf
    aliases:
        - capture
    script:
        - inventory open d:ctfmm

ctfmm:
    type: inventory
    inventory: chest
    gui: true
    size: 27
    title: <&l><&6>Capture The Flag
    procedural items:
        - determine <item[glass_pane].repeat_as_list[27]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [ctfmm_create_game] [] [] [] [ctfmm_games] [] []
    - [] [] [] [] [] [] [] [] []

ctfmm_events:
    type: world
    debug: true
    events:
        after player clicks ctfmm_create_game in ctfmm:
            - inventory open d:ctfmm_create_game_menu
            - flag <player> current_game_private:true
        after player clicks ctfmm_games in ctfmm:
            - inventory open d:ctfmm_games_submenu
        after player clicks ctfmm_create_game_privacy_true in ctfmm_create_game_menu:
            - flag <player> current_game_private:false
            - inventory o:ctfmm_create_game_privacy_false set slot:<context.slot> destination:<context.inventory>
        after player clicks ctfmm_create_game_privacy_false in ctfmm_create_game_menu:
            - flag <player> current_game_private:true
            - inventory o:ctfmm_create_game_privacy_true set slot:<context.slot> destination:<context.inventory>
        after player clicks ctfmm_create_game_host in ctfmm_create_game_menu:
            - run game_creation_handler def.player:<player> def.privacy:<player.flag[current_game_private].if_null[false]>
        after player clicks ctfmm_return in inventory:
            - inventory open d:ctfmm
        after player opens ctfmm_games_submenu:
            - define valid_worlds <list[]>
            - foreach <server.flag[active_games].if_null[<list[]>]>:
                - if <[value].flag[private].if_null[true]> && <player> in <[value].flag[invited_players].if_null[<list[]>]> || <[value].flag[private].if_null[true].not>:
                    - define valid_worlds <[valid_worlds].include[<[value]>]>
            - define world_items <list[]>
            - foreach <[valid_worlds]>:
                - define host <[value].flag[host].if_null[<player>]>
                - if <[value].flag[privacy].if_null[false]>:
                    - define privacy Yes
                - else:
                    - define privacy No
                - if <[value].flag[paused].if_null[false]>:
                    - define paused Yes
                - else:
                    - define paused No
                - define world_items "<[world_items].include[<item[player_head].with[skull_skin=<[host].uuid>|<[host].skin_blob>].with[display=<&6>Id: <[value].name.split[/].get[2]>;lore=<&a>Creator: <[host].name>|<&b>Created: <[value].flag[date].format.if_null[null]>|<&3>Private: <[privacy]>|<&2>Paused: <[paused]>]>]>"
            - define slot 1
            - foreach <[world_items]>:
                - inventory set o:<[value]> slot:<[slot]> d:<context.inventory>
                - define slot <[slot].add[1]>

ctfmm_games:
    type: item
    material: paper
    display name: <green>View Current Games
    mechanisms:
        hides: all
    enchantments:
        - unbreaking:1

ctfmm_games_submenu:
    type: inventory
    inventory: chest
    gui: true
    size: 54
    title: <green>Current CTF Games
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [ctfmm_return] [<item[gray_stained_glass_pane]>] [<item[gray_stained_glass_pane]>] [<item[gray_stained_glass_pane]>] [<item[gray_stained_glass_pane]>] [<item[gray_stained_glass_pane]>] [<item[gray_stained_glass_pane]>] [<item[gray_stained_glass_pane]>] [<item[gray_stained_glass_pane]>]

ctfmm_return:
    type: item
    material: barrier
    display name: <red>Return
    mechanisms:
        hides: all
    enchantments:
        - unbreaking:1

ctfmm_create_game_host:
    type: item
    material: target
    display name: <green>Host Game!
    mechanisms:
        hides: all
    enchantments:
        - unbreaking:1

ctfmm_create_game:
    type: item
    material: beacon
    mechanisms:
        hides: all
    display name: <green>Create New CTF Game
    enchantments:
        - unbreaking:1

ctfmm_create_game_menu:
    type: inventory
    inventory: chest
    gui: true
    size: 27
    title: <green>Create New CTF Game
    procedural items:
        - determine <item[glass_pane].repeat_as_list[27]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [ctfmm_create_game_host] [] [] [] [ctfmm_create_game_privacy_false] [] []
    - [ctfmm_return] [] [] [] [] [] [] [] []

ctfmm_create_game_privacy_true:
    type: item
    material: redstone_block
    mechanisms:
        hides: all
    display name: <red>Game Private
    enchantments:
        - unbreaking:1

ctfmm_create_game_privacy_false:
    type: item
    material: emerald_block
    mechanisms:
        hides: all
    display name: <green>Game Public
    enchantments:
        - unbreaking:1

game_creation_ui:
    type: inventory
    inventory: HOPPER
    title: <&4>Host Game
    gui: true
    procedural items:
        - determine <item[green_stained_glass].repeat_as_list[9]>
    slots:
    - [] [] [<item[game_creation_ui_button]>] [] []

game_creation_ui_button:
    type: item
    material: beacon
    display name: <green>Host Game!
    mechanisms:
        hides: all
    enchantments:
        - unbreaking:1

game_creation_ui_button_interaction:
    type: world
    debug: true
    events:
        after player clicks game_creation_ui_button in game_creation_ui:
            - run game_creation_handler def.player:<player>
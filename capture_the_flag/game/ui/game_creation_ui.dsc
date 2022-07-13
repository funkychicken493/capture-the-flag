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
game_ending_handler:
    type: task
    debug: true
    definitions: world
    script:
        - narrate "Game Over!" targets:<[world].players>
        - teleport <[world].players> hub_spawn
        - wait 3s
        - ~adjust <[world]> destroy

game_ending_handler_debug:
    type: command
    name: end
    description: write something here
    permission: ctf.end_game
    usage: /end
    script:
        - run game_ending_handler def.world:<player.location.world>
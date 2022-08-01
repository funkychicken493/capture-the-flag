game_creation_handler:
    type: task
    debug: true
    definitions: player|settings|privacy
    script:
        - inventory close destination:<player.open_inventory>
        - narrate "<&5>Creating your Capture The Flag world..."
        - inject world_creation_handler
        - wait 3s
        - narrate "<&5><element[World Created!].on_hover[<&7><[world_uuid]>]>"
        - narrate "<&5>Teleporting you to your world..."
        - teleport <player> <location[0,100,0,ctfinstances/<[world_uuid]>]>
        - narrate "<&5>Teleported! Welcome to your world!<&nl>You are the host."

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

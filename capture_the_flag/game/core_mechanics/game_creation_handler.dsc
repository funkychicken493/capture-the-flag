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

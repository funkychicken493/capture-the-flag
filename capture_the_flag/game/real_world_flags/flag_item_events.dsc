flag_item_events:
    type: world
    debug: true
    events:
        on player places flag_*:
            - determine cancelled
        on player drops flag_*:
            - determine passively cancelled
            - narrate "YOU CANT DROP THE FLAG IDIOT GO BACK TO YOUR BASE"
        on player picks up flag_*:
            - narrate "kys "
        on player opens inventory:
            - if <player.inventory.contains_item[flag_*]> && <context.inventory.script.exists.not>:
                - determine cancelled
        on player right clicks block with:flag_* location_flagged:flag_block:
            - if <context.location.flag[flag_color]> != <context.item.flag[flag_color]>:
                - narrate ratio
                - take iteminhand from:<player> quantity:1

flagpost_events:
    type: world
    debug: true
    events:
        on player drops flagpost_*:
            - narrate "cope "

flagpost_get_flag:
    type: world
    debug: true
    events:
        on player breaks block:
            - if <context.location.has_flag[flagpost_blue]>:
                - narrate "we do a little trolling (blue sus)"
                - determine passively NOTHING
                - give flag_blue
                - flag <player> flag_held
            - else if <context.location.has_flag[flagpost_red]>:
                - narrate "we do a little trolling (red sus)"
                - determine passively NOTHING
                - give flag_red
                - flag <player> flag_held
            - else:
                - narrate Error
flag_player_prevent:
    type: world
    debug: true
    events:
        on player opens inventory:
        - if <player.has_flag[flag_held]>:
            - determine cancelled
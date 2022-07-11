flagpost_placement_handler:
    type: task
    debug: true
    definitions: player|location
    script:
        - define result <proc[flag_place_check].context[<[location]>|<[player].item_in_hand.flag[flag_color]>]>
        - if <[result]> == flag_exists:
            - determine passively cancelled
            - narrate "<&c>This flag has already been placed. Cope." targets:<[player]>
            - stop
        - else if <[result]> == flag_near:
            - determine passively cancelled
            - narrate "<&c>Another flag is too close!" targets:<[player]>
            - stop
        - else if <[result]> == bedrock:
            - determine passively cancelled
            - narrate "<&c>Bedrock is too close!" targets:<[player]>
            - stop
        - else if <[result]> == success:
            - narrate "<[player].item_in_hand.flag[flag_color].if_null[null].to_titlecase> flag has been placed." targets:<[player]>
            - flag <[location]> flag_block
            - flag <[location]> flag_color:<[player].item_in_hand.flag[flag_color]>
            - ~modifyblock <[location].find_blocks.within[5].exclude[<[location]>]> air naturally:air delayed
            - flag <[location].find_blocks.within[5]> flag_zone
            - modifyblock <[location]> note_block
            - flag <[location].world> flags.<[player].item_in_hand.flag[flag_color]>.location:<[location]>
            - stop
        - else:
            - determine passively cancelled
            - narrate "<&c>Uncaught Error! Report this to staff immediately." targets:<[player]>
            - stop
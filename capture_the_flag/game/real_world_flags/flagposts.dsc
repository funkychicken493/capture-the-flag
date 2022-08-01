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
            - flag <[location]> flagpost_<[player].item_in_hand.flag[flag_color]>
            - stop
        - else:
            - determine passively cancelled
            - narrate "<&c>Uncaught Error! Report this to staff immediately." targets:<[player]>
            - stop

flag_place_check:
    type: procedure
    definitions: location|flag_color
    script:
        - define l <[location]>
        - if <[l].world.flag[flags.<[flag_color]>.location].exists>:
                - determine flag_exists
        - else if <[l].find_blocks_flagged[flag_block].within[100].size> > 0:
            - determine flag_near
        - else if <[l].find_blocks[bedrock].within[5].size> > 0:
            - determine bedrock
        - else:
            - determine success

flagpost_placement:
    type: world
    debug: true
    events:
        on player places flagpost_*:
            - define player <player>
            - define location <context.location>
            - inject flagpost_placement_handler

        on player places block location_flagged:flag_zone:
            - narrate "You can't build this close to flags!"
            - determine cancelled

flagpost_blue:
    type: item
    material: dirt
    mechanisms:
        custom_model_data: 2
    display name: <blue><bold>Blue Flag Post
    lore:
        - not the real flag idiot
    flags:
        flagpost_item: true
        flag_color: blue
        uniquefier: <util.random_uuid>

flagpost_red:
    type: item
    material: dirt
    mechanisms:
        custom_model_data: 1
    display name: <dark_red><bold>Red Flag Post
    lore:
        - not the real flag idiot
    flags:
        flagpost_item: true
        flag_color: red
        uniquefier: <util.random_uuid>
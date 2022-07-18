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
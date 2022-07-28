trap_handling:
    type: world
    debug: false
    events:

        #Event to stop players from tuning note blocks
        on player right clicks block:
            - if <context.location.material.name> == note_block || <context.location.has_flag[trap]>:
                - determine passively cancelled
                #Hacky method to replace the note block's note value with the original note value.
                - adjustblock <context.location> note:<context.location.material.note.sub[1].min[24].max[0]>

        on player places item_flagged:trap:
            - flag <context.location> trap.<context.item_in_hand.flag[trap]>
        on noteblock plays note location_flagged:trap:
            - determine passively cancelled

            - foreach <context.location.flag[trap].keys>:
                - definemap context:
                    location: <context.location>
                    trap_map: <context.location.flag[trap].if_null[null]>
                - customevent id:ta_<[value]> context:<[context]> save:<[value]>
                - if <entry[<[value]>].any_ran>:
                    - stop if:<entry[<[value]>].was_cancelled>

            - flag <context.location> trap:!
            - modifyblock <context.location> air
            - playsound <context.location> sound:block_wood_break volume:2

        on piston extends:
            - foreach <context.blocks>:
                - if <[value].has_flag[trap]>:
                    - determine cancelled
        on piston retracts:
            - foreach <context.blocks>:
                - if <[value].has_flag[trap]>:
                    - determine cancelled
        on block ignites location_flagged:trap:
            - determine cancelled
        on block burns location_flagged:trap:
            - determine cancelled
        on block destroyed by explosion location_flagged:trap:
            - flag <context.location> trap:!
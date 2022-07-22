##Pausing is NOT supported for now and will NOT be added for a very long time.



#ctf_pause_command:
#    type: command
#    name: pause
#    description: Pauses a CTF game.
#    usage: /pause
#    tab complete:
#        - determine <world[hub]>
#    aliases:
#        - p
#    script:
#        - define arg1 <context.args.get[1].if_null[uuuuuu]>
#        - if <world[<[arg1]>].if_null[uuuuuu]> == <world[hub].if_null[ihateithere]>:
#            - narrate kys
#            - stop
#        - else if <world[<[arg1]>].exists>:
#            - define world <world[<[arg1]>]>
#        - else if <world[ctfinstances/<[arg1]>].exists>:
#            - define world <world[ctfinstances/<[arg1]>]>
#        - else:
#            - define world <player.location.world>
#        - run ctf_pause def.world:<[world]> def.player:<player>
#
#ctf_pause:
#    type: task
#    debug: true
#    definitions: player|world
#    script:
#        - if <[player]> == <[world].flag[host].if_null[null]>:
#            - flag <[world]> paused:<[world].flag[paused].if_null[false].not>
#            - narrate <[world].flag[paused]>
#            - if <[world].flag[paused]>:
#                - if <world[hub].exists.not>:
#                    - createworld hub
#                - teleport <[world].players> <location[0,100,0,hub]>
#                - adjust <[world]> unload
#            - else:
#                - createworld <[world]>

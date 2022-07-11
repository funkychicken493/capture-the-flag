chatting_channel_command:
    type: command
    name: channel
    description: write something here
    usage: /channel
    aliases:
        - c
    tab completions:
        1: team|global|g|t
    script:
        - if <context.args.get[1]> in global|g:
                - flag <player> chat_channel:global
                - narrate "<green>Channel switched to <&l>Global<&r><green>."
        - else if <context.args.get[1]> in team|t:
                - flag <player> chat_channel:team
                - narrate "<green>Channel switched to <&l>Team<&r><green>."
        - else:
            - narrate "Invalid, error message here"
            - stop

chatting_channel_per_world:
    type: world
    debug: true
    events:
        on player chats:
            - if <player.has_flag[chat_channel].not>:
                - flag <player> chatting_channel:team
            - if <player.flag[chat_channel]> == global:
                - determine passively RECIPIENTS:<player.location.world.players>
                - determine FORMAT:chatting_channel_global
            - else:
                - determine passively RECIPIENTS:<player.location.world.players.filter_tag[<[filter_value].flag[<player.location.world.name>.team].if_null[null].equals[<player.flag[<player.location.world.name>.team].if_null[uuuuu]>]>]>
                - determine FORMAT:chatting_channel_team

chatting_channel_global:
    type: format
    format: <element[<light_purple><&lb>G<&rb>]><&r> <[name]><&co> <[text]>

chatting_channel_team:
    type: format
    format: <&6><element[<&lb>T<&rb>]><&r> <[name]><&co> <[text]>

chatting_channel_server:
    type: format
    format: <&4><element[<&lb>S<&rb>]><&r> <[name]><&co> <[text]>

chatting_channel_team_chat:
    type: command
    name: teamchat
    description: write something here
    usage: /teamchat
    aliases:
        - tc
        - t
        - team
        - teamc
        - chatteam
    script:
        - narrate "<context.args.separated_by[ ]>" format:chatting_channel_team targets:<player.location.world.players.filter_tag[<[filter_value].flag[<player.location.world.name>.team].if_null[null].equals[<player.flag[<player.location.world.name>.team].if_null[uuuuu]>]>]>

chatting_channel_global_chat:
    type: command
    name: globalchat
    description: write something here
    usage: /globalchat
    aliases:
        - gc
        - g
        - global
        - globalc
        - chatglobal
        - shout
    script:
        - narrate "<context.args.separated_by[ ]>" format:chatting_channel_global targets:<player.location.world.players>

chatting_channel_server_chat:
    type: command
    name: serverchat
    description: write something here
    usage: /serverchat
    aliases:
        - sc
        - s
        - server
        - serverc
        - chatserver
        - scream
    script:
        - narrate "<context.args.separated_by[ ]>" format:chatting_channel_server targets:<server.online_players>
        - determine FORMAT:chatting_channel_server
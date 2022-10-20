clear_command:
    type: command
    name: clear
    description: Clear your inventory.
    usage: /clear <&lt>player<&gt>
    aliases:
        - cl
    permission: ctf.command.clear
    tab completions:
        1: <server.online_players.parse[name]>
    script:
        - inventory clear d:<context.args.get[1].as[player].if_null[<player>].inventory>

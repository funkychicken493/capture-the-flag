#Simple command script for testing different sounds
sound_command:
    type: command
    name: sound
    description: Tool for testing sounds without typing out the ridiculous /playsound command.
    usage: /sound bukkitsoundkey pitch
    aliases:
        - testsound
        - soundtest
        - ts
    permission: ctf.command.sound
    tab completions:
        1: <server.sound_types>
        2: 0.5|1.0|2.0
    script:
        #Check if the inputted sound key is valid.
        - if <context.args.get[1].is_in[<server.sound_types>].not>:
            - narrate "<&c>Invalid sound name!"
            - stop
        #Check if the command has any arguments.
        - if <context.args.is_empty>:
            - narrate "<&c>/sound bukkitsoundkey pitch"
            - stop
        #Define the pitch if it isn't already defined.
        - define pitch <context.args.get[2].if_null[1]>
        #Play the sound.
        - playsound <player.location> sound:<context.args.get[1]> pitch:<[pitch]> sound_category:master volume:2
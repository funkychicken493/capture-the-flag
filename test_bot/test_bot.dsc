test_bot:
    type: world
    debug: false
    events:
        after server start:
            - ~discordconnect id:testbot tokenfile:scripts/test_bot/token.txt
        on reload scripts:
            - if <server.has_flag[bot.registered_commands.test].not>:
                - ~discordcommand id:testbot create name:test "description:A test command to make sure the bot works." enabled:true group:626443588439375872
                #group:<discord_group[626443588439375872]>
                - flag server bot.registered_commands.test:true
        after discord slash command for:testbot name:test:
            - define click_me "<discord_button.with[id].as[click_me].with[label].as[Click me!].with[style].as[success]>"
            - ~discordinteraction reply interaction:<context.interaction> "The bot works!" rows:<[click_me]>
        after discord button clicked id:click_me:
            - ~discordinteraction defer interaction:<context.interaction> ephemeral:true
            - ~discordinteraction reply interaction:<context.interaction> "You know, poking someone is really rude!"
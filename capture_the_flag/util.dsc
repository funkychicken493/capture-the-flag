reload_on_server_start:
    type: world
    debug: false
    events:
        after server start:
            - wait 5s
            - reload
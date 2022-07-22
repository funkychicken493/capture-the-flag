autosaver_world:
    type: world
    debug: false
    events:
        on delta time minutely every:10:
            - announce to_console Autosaving...
            - adjust server save
            - adjust server save_citizens
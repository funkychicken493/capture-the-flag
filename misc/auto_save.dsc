autosaver_world:
    type: world
    debug: false
    events:
        on delta time minutely every:5:
            - announce to_console Autosaving...
            - ~adjust server save
            - ~adjust server save_citizens
            - announce to_console "Autosave complete."
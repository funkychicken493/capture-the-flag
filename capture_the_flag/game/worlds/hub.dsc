#Events to stop destruction of the hub world by the player
hub_events:
    type: world
    debug: false
    events:
        after server start:
            - createworld hub
        on player damaged:
            - if <player.location.world> == <world[hub]>:
                - determine cancelled
        on player places block:
            - if <player.location.world> == <world[hub]>:
                - determine cancelled
        on player breaks block:
            - if <player.location.world> == <world[hub]>:
                - determine cancelled
        on !player spawns:
            - if <context.location.world> == <world[hub]>:
                - determine cancelled
        on entity changes food level:
            - if <context.entity.location.world> == <world[hub]>:
                - determine 20
        on player right clicks block:
            - if <player.location.world> == <world[hub]>:
                - determine cancelled
        on player dies:
            - if <player.location.world> == <world[hub]>:
                - determine passively cancelled
                - teleport <player> hub_spawn
#Hub World was created by ASlightlyOvergrownCactus / Overgrown_Cactus

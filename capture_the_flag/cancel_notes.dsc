#Entirely necessary event to stop any trap/note block from being tuned by a player.
cancel_notes:
    type: world
    debug: true
    events:
        after player right clicks note_block:
            - if <context.location.material.name> == note_block:
                #Hacky method to replace the note block's note value with the original note value.
                - adjustblock <context.location> note:<context.location.material.note.sub[1].min[24].max[0]>
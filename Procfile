# builds the js library
lib: make run

# serves up the html/js for testing
web: make wsrun

# runs a pub server
ws: macat -v --pub --bind="ws://127.0.0.1:3333/mysock" -D "hi from server" --interval 2
wsrep: macat -v --rep --bind="ws://127.0.0.1:3335/rep" -D "hi from rep" --interval 2

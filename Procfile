# builds the js library
lib: make run

# serves up the html/js for testing
web: make wsrun

# runs a pub server
ws: macat -v --pub --bind="ws://127.0.0.1:3333/mysock" -D "hi from server" --interval 2

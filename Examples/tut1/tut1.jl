# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 1 - Open a window


# load necessary GL/SDL routines

load("initGL.jl")
initGL()

# drawing routines

while true

    SwapAndClear()

    #check key presses
    while true
        poll = poll_event()
        @case poll begin
            int('q') : return # convert keys to corresponding ASCII codes
            SDL_EVENTS_DONE   : break
        end
    end

end

# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 3 - Draw a colored (rainbow) triangle and a colored (blue) square


# load necessary GL/SDL routines

load("initGL.jl")
initGL()

# initialze variables

# drawing routine

while true

    gltranslate(-0.2,0.0,-0.6)

    @with glprimitive(GL_POLYGON) begin
      glcolor(1.0,0,0)
      glvertex(0.0,0.2,0.0)
      glcolor(0,1.0,0)
      glvertex(-0.2,-0.2,0.0)
      glcolor(0,0,1.0)
      glvertex(0.2,-0.2,0.0)
    end

    gltranslate(0.8,0,0)

    glcolor(0.5,0.5,1.0)
    @with glprimitive(GL_QUADS) begin
        glvertex(-0.2,0.2,0.0)
        glvertex(0.2,0.2,0.0)
        glvertex(0.2,-0.2,0.0)
        glvertex(-0.2,-0.2,0.0)
    end

    SwapAndClear()

    # check key presses
    while true
        poll = poll_event()
        @case poll begin
            int('q') : return
            SDL_EVENTS_DONE   : break
        end
    end

end

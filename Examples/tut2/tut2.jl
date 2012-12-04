# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 2 - Draw a triangle and a square


# load necessary GL/SDL routines

load("initGL.jl")
initGL()

# drawing routines

while true

    glcolor(1.0,1.0,1.0)

    gltranslate(-0.4,0.0,-0.3)

    @with glprimitive(GL_POLYGON) begin
      glvertex(0.0,0.2,0.0)
      glvertex(-0.2,-0.2,0.0)
      glvertex(0.2,-0.2,0.0)
    end

    gltranslate(0.8,0.0,0.0)

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

# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 4 - Rotate colored (rainbow) triangle and colored (cyan) square


# load necessary GL/SDL routines

load("initGL.jl")
initGL()

# initialize variables

rtri  = 0.0
rquad = 0.0

# drawing routines

while true

    gltranslate(-0.3,0.0,-0.6)
    glrotate(rtri,0.0,1.0,0.0)

    @with glprimitive(GL_POLYGON) begin
      glcolor(1.0,0,0)
      glvertex(0.0,0.2,0.0)
      glcolor(0,1.0,0)
      glvertex(0.2,-0.2,0.0)
      glcolor(0,0,1.0)
      glvertex(-0.2,-0.2,0.0)
    end

    glloadidentity()

    gltranslate(0.3,0.0,-0.6)
    glrotate(rquad,1.0,0.0,0.0)

    glcolor(0.5,0.5,1.0)

    @with glprimitive(GL_QUADS) begin
        glvertex(-0.2,0.2,0.0)
        glvertex(0.2,0.2,0.0)
        glvertex(0.2,-0.2,0.0)
        glvertex(-0.2,-0.2,0.0)
    end

    rtri  +=0.2
    rquad -=0.2

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

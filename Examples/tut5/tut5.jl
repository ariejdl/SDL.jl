# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 5 - Rotate colored (rainbow) pyramid and colored (rainbow) cube


# load necessary GL/SDL routines

load("initGL.jl")
initGL()

# initialize variables

rpyr      = 0.0
rquad     = 0.0

pyr_size  = 0.2
cube_size = 0.2

# drawing routines

while true

    gltranslate(-0.3,0.0,-0.6)
    glrotate(rpyr,0.0,1.0,0.0)

    @with glprimitive(GL_POLYGON) begin
        # front face
        glcolor(1.0,0,0)
        glvertex(0.0,pyr_size,0.0)
        glcolor(0,1.0,0)
        glvertex(-pyr_size,-pyr_size,pyr_size)
        glcolor(0,0,1.0)
        glvertex(pyr_size,-pyr_size,pyr_size)

        # right face
        glcolor(1.0,0,0)
        glvertex(0.0,pyr_size,0.0)
        glcolor(0,0,1.0)
        glvertex(pyr_size,-pyr_size,pyr_size)
        glcolor(0,1.0,0)
        glvertex(pyr_size,-pyr_size,-pyr_size)

        # back face
        glcolor(1.0,0,0)
        glvertex(0.0,pyr_size,0.0)
        glcolor(0,1.0,0)
        glvertex(pyr_size,-pyr_size,-pyr_size)
        glcolor(0,0,1.0)
        glvertex(-pyr_size,-pyr_size,-pyr_size)

        # left face
        glcolor(1.0,0,0)
        glvertex(0.0,pyr_size,0.0)
        glcolor(0,0,1.0)
        glvertex(-pyr_size,-pyr_size,-pyr_size)
        glcolor(0,1.0,0)
        glvertex(-pyr_size,-pyr_size,pyr_size)
    end

    glloadidentity();				# make sure we're no longer rotated.
    gltranslate(0.3,0.0,-0.65)		# Move Right 3 Units, and back into the screen 7

    glrotate(rquad,1.0,1.0,1.0)		# Rotate The Cube On X, Y, and Z

    @with glprimitive(GL_QUADS) begin
        # top of cube
        glcolor(0.0,1.0,0.0)		 
        glvertex( cube_size, cube_size,-cube_size) 
        glvertex(-cube_size, cube_size,-cube_size) 
        glvertex(-cube_size, cube_size, cube_size) 
        glvertex( cube_size, cube_size, cube_size) 

        # bottom of cube
        glcolor(1.0,0.5,0.0)		 
        glvertex( cube_size,-cube_size, cube_size) 
        glvertex(-cube_size,-cube_size, cube_size) 
        glvertex(-cube_size,-cube_size,-cube_size) 
        glvertex( cube_size,-cube_size,-cube_size) 

        # front of cube
        glcolor(1.0,0.0,0.0)		 
        glvertex( cube_size, cube_size, cube_size) 
        glvertex(-cube_size, cube_size, cube_size) 
        glvertex(-cube_size,-cube_size, cube_size) 
        glvertex( cube_size,-cube_size, cube_size) 

        # back of cube.
        glcolor(1.0,1.0,0.0)		 
        glvertex( cube_size,-cube_size,-cube_size) 
        glvertex(-cube_size,-cube_size,-cube_size) 
        glvertex(-cube_size, cube_size,-cube_size) 
        glvertex( cube_size, cube_size,-cube_size) 

        # left of cube
        glcolor(0.0,0.0,1.0)		 
        glvertex(-cube_size, cube_size, cube_size) 
        glvertex(-cube_size, cube_size,-cube_size) 
        glvertex(-cube_size,-cube_size,-cube_size) 
        glvertex(-cube_size,-cube_size, cube_size) 

        # Right of cube
        glcolor(1.0,0.0,1.0)		 
        glvertex( cube_size, cube_size,-cube_size) 
        glvertex( cube_size, cube_size, cube_size) 
        glvertex( cube_size,-cube_size, cube_size) 
        glvertex( cube_size,-cube_size,-cube_size) 

    end

    rpyr  +=0.2
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

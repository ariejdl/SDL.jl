# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 5 - Rotate colored (rainbow) pyramid and colored (rainbow) cube
#
# Q - quit


# load necessary GL/SDL routines

using OpenGL
using SDL

# initialize variables

bpp                = 16
wintitle           = "NeHe Tut 5"
icontitle          = "NeHe Tut 5"
width              = 640
height             = 480

rpyr               = 0.0
rquad              = 0.0

pyr_size           = 1.0
cube_size          = 1.0

keystate_checked   = false
lastkeycheckTime   = 0
key_repeatinterval = 75 #ms

# open SDL window with an OpenGL context

sdl_init(SDL_INIT_VIDEO)
#videoInfo = sdl_getvideoinfo()
videoFlags = (SDL_OPENGL | SDL_GL_DOUBLEBUFFER | SDL_HWPALETTE | SDL_RESIZABLE)
#if videoInfo.hw_available
    videoFlags = (videoFlags | SDL_HWSURFACE)
#else
    #videoFlags = (videoFlags | SDL_SWSURFACE)
#end
#if videoInfo.blit_hw
    videoFlags = (videoFlags | SDL_HWACCEL)
#end
sdl_gl_setattribute(SDL_GL_DOUBLEBUFFER, 1)
sdl_setvideomode(width, height, bpp, videoFlags)
sdl_wm_setcaption(wintitle, icontitle)

glviewport(0, 0, width, height)
glclearcolor(0.0, 0.0, 0.0, 0.0)
glcleardepth(1.0)			 
gldepthfunc(GL_LESS)	 
glenable(GL_DEPTH_TEST)
glshademodel(GL_SMOOTH)

glmatrixmode(GL_PROJECTION)
glloadidentity()

gluperspective(45.0,width/height,0.1,100.0)

glmatrixmode(GL_MODELVIEW)

# main drawing loop

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    gltranslate(-1.5,0.0,-6.0)
    glrotate(rpyr,0.0,1.0,0.0)

    glbegin(GL_POLYGON)
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
    glend()

    glloadidentity()

    gltranslate(1.5,0.0,-7.0)
    glrotate(rquad,1.0,1.0,1.0)

    glcolor(0.5,0.5,1.0)
    glbegin(GL_QUADS)
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
    glend()

    rpyr  +=0.2
    rquad -=0.2					

    sdl_gl_swapbuffers()

    sdl_pumpevents()
    if sdl_getticks() - lastkeycheckTime >= key_repeatinterval
        keystate         = sdl_getkeystate()
        keystate_checked = true
        lastkeycheckTime = sdl_getticks()
    end

    # Sampling rates for event processing are so fast that a single key press
    # lasts through several iterations of this loop.  This means that one press
    # can be seen as 50 or more presses by the SDL event system.  To correct
    # for this, we only check keypresses every 75ms.

    if keystate_checked == true
        if keystate[SDLK_q] == true
            break
        end
        keystate_checked = false
    end
end

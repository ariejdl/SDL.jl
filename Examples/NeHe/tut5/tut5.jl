# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 5 - Rotate colored (rainbow) pyramid and colored (rainbow) cube
#
# Q - quit


# load necessary GL/SDL routines

global OpenGLver="1.0"
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

SDL_Init(SDL_INIT_VIDEO)
#videoInfo = SDL_GetVideoInfo()
videoFlags = (SDL_OPENGL | SDL_GL_DOUBLEBUFFER | SDL_HWPALETTE | SDL_RESIZABLE)
#if videoInfo.hw_available
    videoFlags = (videoFlags | SDL_HWSURFACE)
#else
    #videoFlags = (videoFlags | SDL_SWSURFACE)
#end
#if videoInfo.blit_hw
    videoFlags = (videoFlags | SDL_HWACCEL)
#end
SDL_gl_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
SDL_SetVideoMode(width, height, bpp, videoFlags)
SDL_wm_SetCaption(wintitle, icontitle)

glViewPort(0, 0, width, height)
glClearColor(0.0, 0.0, 0.0, 0.0)
glClearDepth(1.0)
glDepthFunc(GL_LESS)
glEnable(GL_DEPTH_TEST)
glShadeModel(GL_SMOOTH)

glMatrixMode(GL_PROJECTION)
glLoadIdentity()

gluPerspective(45.0,width/height,0.1,100.0)

glMatrixMode(GL_MODELVIEW)

# main drawing loop

while true
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()

    glTranslate(-1.5,0.0,-6.0)
    glRotate(rpyr,0.0,1.0,0.0)

    glBegin(GL_POLYGON)
        # front face
        glColor(1.0,0,0)
        glVertex(0.0,pyr_size,0.0)
        glColor(0,1.0,0)
        glVertex(-pyr_size,-pyr_size,pyr_size)
        glColor(0,0,1.0)
        glVertex(pyr_size,-pyr_size,pyr_size)

        # right face
        glColor(1.0,0,0)
        glVertex(0.0,pyr_size,0.0)
        glColor(0,0,1.0)
        glVertex(pyr_size,-pyr_size,pyr_size)
        glColor(0,1.0,0)
        glVertex(pyr_size,-pyr_size,-pyr_size)

        # back face
        glColor(1.0,0,0)
        glVertex(0.0,pyr_size,0.0)
        glColor(0,1.0,0)
        glVertex(pyr_size,-pyr_size,-pyr_size)
        glColor(0,0,1.0)
        glVertex(-pyr_size,-pyr_size,-pyr_size)

        # left face
        glColor(1.0,0,0)
        glVertex(0.0,pyr_size,0.0)
        glColor(0,0,1.0)
        glVertex(-pyr_size,-pyr_size,-pyr_size)
        glColor(0,1.0,0)
        glVertex(-pyr_size,-pyr_size,pyr_size)
    glEnd()

    glLoadIdentity()

    glTranslate(1.5,0.0,-7.0)
    glRotate(rquad,1.0,1.0,1.0)

    glColor(0.5,0.5,1.0)
    glBegin(GL_QUADS)
        # top of cube
        glColor(0.0,1.0,0.0)
        glVertex( cube_size, cube_size,-cube_size)
        glVertex(-cube_size, cube_size,-cube_size)
        glVertex(-cube_size, cube_size, cube_size)
        glVertex( cube_size, cube_size, cube_size)

        # bottom of cube
        glColor(1.0,0.5,0.0)
        glVertex( cube_size,-cube_size, cube_size)
        glVertex(-cube_size,-cube_size, cube_size)
        glVertex(-cube_size,-cube_size,-cube_size)
        glVertex( cube_size,-cube_size,-cube_size)

        # front of cube
        glColor(1.0,0.0,0.0)
        glVertex( cube_size, cube_size, cube_size)
        glVertex(-cube_size, cube_size, cube_size)
        glVertex(-cube_size,-cube_size, cube_size)
        glVertex( cube_size,-cube_size, cube_size)

        # back of cube.
        glColor(1.0,1.0,0.0)
        glVertex( cube_size,-cube_size,-cube_size)
        glVertex(-cube_size,-cube_size,-cube_size)
        glVertex(-cube_size, cube_size,-cube_size)
        glVertex( cube_size, cube_size,-cube_size)

        # left of cube
        glColor(0.0,0.0,1.0)
        glVertex(-cube_size, cube_size, cube_size)
        glVertex(-cube_size, cube_size,-cube_size)
        glVertex(-cube_size,-cube_size,-cube_size)
        glVertex(-cube_size,-cube_size, cube_size)

        # Right of cube
        glColor(1.0,0.0,1.0)
        glVertex( cube_size, cube_size,-cube_size)
        glVertex( cube_size, cube_size, cube_size)
        glVertex( cube_size,-cube_size, cube_size)
        glVertex( cube_size,-cube_size,-cube_size)
    glEnd()

    rpyr  +=0.2
    rquad -=0.2

    SDL_gl_SwapBuffers()

    SDL_PumpEvents()
    if SDL_GetTicks() - lastkeycheckTime >= key_repeatinterval
        keystate         = SDL_GetKeystate()
        keystate_checked = true
        lastkeycheckTime = SDL_GetTicks()
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

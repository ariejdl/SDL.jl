# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 4 - Rotate colored (rainbow) triangle and colored (cyan) square
#
# Q - quit


# load necessary GL/SDL routines

using OpenGL
@OpenGL.version "1.0"
@OpenGL.load
using SDL

# initialize variables

bpp                = 16
wintitle           = "NeHe Tut 4"
icontitle          = "NeHe Tut 4"
width              = 640
height             = 480

rtri               = 0.0
rquad              = 0.0

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
SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
SDL_SetVideoMode(width, height, bpp, videoFlags)
SDL_WM_SetCaption(wintitle, icontitle)

glViewport(0, 0, width, height)
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
    glRotate(rtri,0.0,1.0,0.0)

    glBegin(GL_POLYGON)
      glColor(1.0,0,0)
      glVertex(0.0,1.0,0.0)
      glColor(0,1.0,0)
      glVertex(1.0,-1.0,0.0)
      glColor(0,0,1.0)
      glVertex(-1.0,-1.0,0.0)
    glEnd()

    glLoadIdentity()

    glTranslate(1.5,0.0,-6.0)
    glRotate(rquad,1.0,0.0,0.0)

    glTranslate(0.8,0,0)

    glColor(0.5,0.5,1.0)
    glBegin(GL_QUADS)
        glVertex(-1.0,1.0,0.0)
        glVertex(1.0,1.0,0.0)
        glVertex(1.0,-1.0,0.0)
        glVertex(-1.0,-1.0,0.0)
    glEnd()

    rtri  +=0.2
    rquad -=0.2

    SDL_GL_SwapBuffers()

    SDL_PumpEvents()
    if SDL_GetTicks() - lastkeycheckTime >= key_repeatinterval
        keystate         = SDL_GetKeyState()
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

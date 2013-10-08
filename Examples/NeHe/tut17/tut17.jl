# Sun 30 Dec 2012 01:22:44 PM EST
#
# NeHe Tut 17 - 2D texture font
#
# Q - quit
# L - turn lights on/off
# F - change texture filter (linear, nearest, mipmap)
# PageUp/Down - move camera closer/further away
# Up/Down - increase/decrease x-rotation speed
# Left/Right - increase/decrease y-rotation speed

# TODO: This example runs, but it produces a very glitchy output.


# load necessary GL/SDL routines and image routines for loading textures

global OpenGLver="1.0"
using OpenGL
using SDL

# initialize variables

bpp                = 16
wintitle           = "NeHe Tut 17"
icontitle          = "NeHe Tut 17"
width              = 640
height             = 480

T0                 = 0
Frames             = 0

cnt1               = 0
cnt2               = 0

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
glDepthFunc(GL_LEQUAL)
glShadeModel(GL_SMOOTH)
glEnable(GL_DEPTH_TEST)

glMatrixMode(GL_PROJECTION)
glLoadIdentity()

gluPerspective(45.0,width/height,0.1,100.0)

glMatrixMode(GL_MODELVIEW)

### auxiliary functions

function glPrint(x::Integer, y::Integer, string::String, set::Integer)
    if set > 1
        set = 1
    end

    glBindTexture(GL_TEXTURE_2D, tex[1])
    glDisable(GL_DEPTH_TEST)

    glMatrixMode(GL_PROJECTION)
    glpushmatrix()

    glLoadIdentity()
    glOrtho(0, 640, 0, 480, -1, 1)

    glMatrixMode(GL_MODELVIEW)
    glPushMatrix()
    glLoadIdentity()

    glTranslate(x, y, 0)
    glListBase(uint32(base-32+(128*set)))
    glCallLists(strlen(string), GL_BYTE, string)

    glMatrixMode(GL_PROJECTION)
    glPopMatrix()

    glMatrixMode(GL_MODELVIEW)
    glPopMatrix()
end

### end of auxiliary functions

# load textures from images

tex       = Array(Uint32,2) # generating 2 textures

img, w, h = glimread(expanduser("~/.julia/SDL/Examples/NeHe/tut17/font.bmp"))

img, w, h = glimread(expanduser("~/.julia/SDL/Examples/NeHe/tut17/bumps.bmp"))

glGenTextures(2,tex)
glBindTexture(GL_TEXTURE_2D,tex[1])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexImage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img_font)

glBindTexture(GL_TEXTURE_2D,tex[2])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexImage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img_bumps)

# enable texture mapping & blending

glEnable(GL_TEXTURE_2D)
glBlendFunc(GL_SRC_ALPHA, GL_ONE)

# build the fonts

base = glGenLists(256)
glBindTexture(GL_TEXTURE_2D, tex[1])

for loop = 1:256
    cx = (loop%16)/16
    cy = (loop/16)/16

    glNewList(uint32(base+(loop-1)), GL_COMPILE)
        glBegin(GL_QUADS)
            glTexCoord(cx, 1-cy-0.0625)
            glVertex(0, 0)
            glTexCoord(cx+0.0625, 1-cy-0.0625)
            glVertex(16, 0)
            glTexCoord(cx+0.0625, 1-cy)
            glVertex(16, 16)
            glTexCoord(cx, 1-cy)
            glVertex(0, 16)
        glEnd()
        glTranslate(10, 0, 0)
    glEndlist()
end

# main drawing loop

while true
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()

    glBindTexture(GL_TEXTURE_2D,tex[2])

    glTranslate(0.0,0.0,-5.0)
    glRotate(45.0, 0.0, 0.0, 1.0)
    glRotate(cnt1*30.0, 1.0, 1.0, 0.0)

    glDisable(GL_BLEND)
    glColor(1.0, 1.0, 1.0)

    glBegin(GL_QUADS)
        glTexCoord(0.0, 0.0)
        glVertex(-1.0, 1.0)
        glTexCoord(1.0, 0.0)
        glVertex(1.0, 1.0)
        glTexCoord(1.0, 1.0)
        glVertex(1.0, -1.0)
        glTexCoord(0.0, 1.0)
        glVertex(-1.0, -1.0)
    glEnd()

    glRotate(90.0, 1.0, 1.0, 0.0)
    glBegin(GL_QUADS)
        glTexCoord(0.0, 0.0)
        glVertex(-1.0, 1.0)
        glTexCoord(1.0, 0.0)
        glVertex(1.0, 1.0)
        glTexCoord(1.0, 1.0)
        glVertex(1.0, -1.0)
        glTexCoord(0.0, 1.0)
        glVertex(-1.0, -1.0)
    glEnd()

    glEnable(GL_BLEND)
    glLoadIdentity()

    glColor(1.0cos(cnt1), 1.0sin(cnt2), 1.0-0.5cos(cnt1+cnt2))
    glPrint(int(280+250cos(cnt1)), int(235+200sin(cnt2)), "NeHe", 0)
    glColor(1.0sin(cnt2), 1.0-0.5cos(cnt1+cnt2), 1.0cos(cnt1))
    glPrint(int(280+230cos(cnt2)), int(235+200sin(cnt1)), "OpenGL", 1)

    glColor(0.0, 0.0, 1.0)
    glPrint(int(240+200cos((cnt2+cnt1)/5)), 2, "JuliaLang", 0)
    glColor(1.0, 1.0, 1.0)
    glPrint(int(242+200cos((cnt2+cnt1)/5)), 2, "JuliaLang", 0)

    cnt1 +=0.01
    cnt2 +=0.0081

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
            glDeleteLists(base,256)
            glDeleteTextures(2,tex)
            break
        end
        keystate_checked = false
    end
end

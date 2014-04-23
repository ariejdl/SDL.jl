# Sat 29 Dec 2012 11:48:33 PM EST
#
# NeHe Tut 12 - Display Lists
#
# Q - quit
# Up/Down - increase/decrease rotation of each cube about it's own x-axis
# Left/Right - increase/decrease rotation of each cube about it's own y-axis


# load necessary GL/SDL routines

using OpenGL
@OpenGL.version "1.0"
@OpenGL.load
using SDL

# initialize variables

bpp       = 16
wintitle  = "NeHe Tut 12"
icontitle = "NeHe Tut 12"
width     = 640
height    = 480

T0        = 0
Frames    = 0

xrot      = 0
yrot      = 0

boxcol    = [1.0 0.0 0.0;
             1.0 0.5 0.0;
             1.0 1.0 0.0;
             0.0 1.0 0.0;
             0.0 1.0 1.0]

topcol    = [0.5 0.0  0.0;
             0.5 0.25 0.0;
             0.5 0.5  0.0;
             0.0 0.5  0.0;
             0.0 0.5  0.5]

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
glClearColor(0.0, 0.0, 0.0, 0.5)
glClearDepth(1.0)
glDepthFunc(GL_LEQUAL)
glEnable(GL_DEPTH_TEST)
glShadeModel(GL_SMOOTH)
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

#enable simple lighting

glEnable(GL_LIGHT0)
glEnable(GL_LIGHTING)
glEnable(GL_COLOR_MATERIAL)

glMatrixMode(GL_PROJECTION)
glLoadIdentity()

gluPerspective(45.0,width/height,0.1,100.0)

glMatrixMode(GL_MODELVIEW)

# build the display lists

box = glGenLists(2)

glNewList(box, GL_COMPILE)
    glBegin(GL_QUADS)
        # Bottom Face
        glTexCoord(0.0, 1.0)
        glVertex(-1.0, -1.0, -1.0)
        glTexCoord(1.0, 1.0)
        glVertex(1.0, -1.0, -1.0)
        glTexCoord(1.0, 0.0)
        glVertex(1.0, -1.0,  1.0)
        glTexCoord(0.0, 0.0)
        glVertex(-1.0, -1.0,  1.0)

        # Front Face
        glTexCoord(1.0, 0.0)
        glVertex(-1.0, -1.0,  1.0)
        glTexCoord(0.0, 0.0)
        glVertex(1.0, -1.0,  1.0)
        glTexCoord(0.0, 1.0)
        glVertex(1.0,  1.0,  1.0)
        glTexCoord(1.0, 1.0)
        glVertex(-1.0,  1.0,  1.0)

        # Back Face
        glTexCoord(0.0, 0.0)
        glVertex(-1.0, -1.0, -1.0)
        glTexCoord(0.0, 1.0)
        glVertex(-1.0,  1.0, -1.0)
        glTexCoord(1.0, 1.0)
        glVertex(1.0,  1.0, -1.0)
        glTexCoord(1.0, 0.0)
        glVertex(1.0, -1.0, -1.0)

        # Right Face
        glTexCoord(0.0, 0.0)
        glVertex(1.0, -1.0, -1.0)
        glTexCoord(0.0, 1.0)
        glVertex(1.0,  1.0, -1.0)
        glTexCoord(1.0, 1.0)
        glVertex(1.0,  1.0,  1.0)
        glTexCoord(1.0, 0.0)
        glVertex(1.0, -1.0,  1.0)

        # Left Face
        glTexCoord(1.0, 0.0)
        glVertex(-1.0, -1.0, -1.0)
        glTexCoord(0.0, 0.0)
        glVertex(-1.0, -1.0,  1.0)
        glTexCoord(0.0, 1.0)
        glVertex(-1.0,  1.0,  1.0)
        glTexCoord(1.0, 1.0)
        glVertex(-1.0,  1.0, -1.0)
    glEnd()
glEndList()

top = uint32(box+1)

glNewList(top, GL_COMPILE)
    glBegin(GL_QUADS)
        # Top Face
        glTexCoord(1.0, 1.0)
        glVertex(-1.0, 1.0, -1.0)
        glTexCoord(1.0, 0.0)
        glVertex(-1.0, 1.0,  1.0)
        glTexCoord(0.0, 0.0)
        glVertex(1.0, 1.0,  1.0)
        glTexCoord(0.0, 1.0)
        glVertex(1.0, 1.0, -1.0)
    glEnd()
glEndList()

# load textures from images

tex   = Array(Uint32,1) # generating 1 texture

img, w, h = glimread(expanduser("~/.julia/SDL/Examples/NeHe/tut12/cube.bmp"))

glGenTextures(1,tex)
glBindTexture(GL_TEXTURE_2D,tex[1])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR_MIPMAP_NEAREST)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)
gluBuild2DMipmaps(GL_TEXTURE_2D, 3, w, h, GL_RGB, GL_UNSIGNED_BYTE, img)

# enable texture mapping

glEnable(GL_TEXTURE_2D)

# main drawing loop

while true
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    glBindTexture(GL_TEXTURE_2D, tex[1])

    for yloop = 1:5
	      for xloop = 1:yloop
            glLoadIdentity()

            glTranslate(1.4+2.8xloop-1.4yloop, ((6.0-yloop)*2.4)-7.0, -20.0)

            glRotate(45.0-(2.0yloop)+xrot, 1.0, 0.0, 0.0)
            glRotate(45.0+yrot, 0.0, 1.0, 0.0)

            glColor(boxcol[yloop,:])
            glCallList(box)

            glColor(topcol[yloop,:])
            glCallList(top)
        end
    end

    SDL_GL_SwapBuffers()

    Frames +=1
    t = SDL_GetTicks()
    if (t - T0) >= 5000
        seconds = (t - T0)/1000
        fps = Frames/seconds
        println("$Frames frames in $seconds seconds = $fps")
        T0 = t
        Frames = 0
    end

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
        elseif keystate[SDLK_LEFT] == true
            yrot -=0.2
        elseif keystate[SDLK_RIGHT] == true
            yrot +=0.2
        elseif keystate[SDLK_UP] == true
            xrot -=0.2
        elseif keystate[SDLK_DOWN] == true
            xrot +=0.2
        end
        keystate_checked = false
    end
end

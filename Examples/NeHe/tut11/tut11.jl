# Fri 28 Dec 2012 03:51:13 PM EST
#
# NeHe Tut 11 - Flag Effect (Waving Texture)
#
# Q - quit


# load necessary GL/SDL routines

global OpenGLver="1.0"
using OpenGL
using SDL

# initialize variables

bpp            = 16
wintitle       = "NeHe Tut 11"
icontitle      = "NeHe Tut 11"
width          = 640
height         = 480

points         = Array(Float64,(45,45,3))

for x=1:45
    for y=1:45
        points[x,y,1] = x/5-4.5
        points[x,y,2] = y/5-4.5
        points[x,y,3] = sin((((x/5)*40)/360)*2*pi)
    end
end

wiggle_count       = 0

xrot               = 0
yrot               = 0
zrot               = 0

T0                 = 0
Frames             = 0

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

glMatrixMode(GL_PROJECTION)
glLoadIdentity()

gluPerspective(45.0,width/height,0.1,100.0)

glMatrixMode(GL_MODELVIEW)

# load textures from images

tex   = Array(Uint32,1) # generating 1 texture

img, w, h = glimread(expanduser("~/.julia/SDL/Examples/NeHe/tut11/tim.bmp"))

glGenTextures(1,tex)
glBindTexture(GL_TEXTURE_2D,tex[1])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

# enable texture mapping

glEnable(GL_TEXTURE_2D)

# enable Polygon filling

glPolygonMode(GL_BACK, GL_FILL)
glPolygonMode(GL_FRONT, GL_LINE)

# main drawing loop

while true
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()

    glTranslate(0.0, 0.0, -12.0)

    glRotate(xrot,1.0,0.0,0.0)
    glRotate(yrot,0.0,1.0,0.0)
    glRotate(zrot,0.0,0.0,1.0)

    glBindTexture(GL_TEXTURE_2D,tex[1])

    glBegin(GL_QUADS)
        for x=1:44
            for y=1:44
                tex_x  = x/45
                tex_y  = y/45
                tex_xb = (x+1)/45
                tex_yb = (y+1)/45

                glTexCoord(tex_x, tex_y)
                glVertex(points[x,y,1],points[x,y,2],points[x,y,3])
                glTexCoord(tex_x, tex_yb)
                glVertex(points[x,y+1,1],points[x,y+1,2],points[x,y+1,3])
                glTexCoord(tex_xb, tex_yb)
                glVertex(points[x+1,y+1,1],points[x+1,y+1,2],points[x+1,y+1,3])
                glTexCoord(tex_xb, tex_y)
                glVertex(points[x+1,y,1],points[x+1,y,2],points[x+1,y,3])
            end
        end
    glEnd()

    if wiggle_count == 2
        for y=1:45
            hold = points[1,y,3]
            for x=1:44
                points[x,y,3] = points[x+1,y,3]
            end
            points[45,y,3] = hold
        end
        wiggle_count = 0
    end

    wiggle_count +=1

    Frames +=1
    t = SDL_GetTicks()
    if (t - T0) >= 5000
        seconds = (t - T0)/1000
        fps = Frames/seconds
        println("$Frames frames in $seconds seconds = $fps")
        T0 = t
        Frames = 0
    end

    xrot +=0.3
    yrot +=0.2
    zrot +=0.4

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

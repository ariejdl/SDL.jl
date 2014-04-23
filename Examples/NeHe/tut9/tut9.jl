# Tue 13 Nov 2012 04:13:36 PM EST
#
# NeHe Tut 9 - Make some colored stars and play w/ alpha blending a bit more
#
# Q - quit
# T - turn "twinkle" on/off
# PageUp/Down - move camera closer/further away
# Up/Down - increase/decrease tilt about x-axis


# load necessary GL/SDL routines

using OpenGL
@OpenGL.version "1.0"
@OpenGL.load
using SDL

# initialize variables

bpp       = 16
wintitle  = "NeHe Tut 9"
icontitle = "NeHe Tut 9"
width     = 640
height    = 480

STAR_NUM  = 50

type star
    r::Int
    g::Int
    b::Int
    dist::Float64
    angle::Float64
end

tempr = rand(1:256)
tempg = rand(1:256)
tempb = rand(1:256)

stars = [star(tempr,tempg,tempb,0.0,0.0)] # Julia doesn't like it when you try to initialize an empty array of
                                          # a composite type and try to fill it afterwards, so we
                                          # start with a 1-element vector and tack on values

for loop = 1:STAR_NUM-1
    tempr = rand(1:256)
    tempg = rand(1:256)
    tempb = rand(1:256)
    stars = push!(stars, star(tempr,tempg,tempb,loop/STAR_NUM*5.0,0.0))
end # I haven't found a better way to make an array of composite types

tilt               = 90.0
zoom               = -15.0
spin               = 0.0

twinkle            = false

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
glShadeModel(GL_SMOOTH)
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

glMatrixMode(GL_PROJECTION)
glLoadIdentity()

gluPerspective(45.0,width/height,0.1,100.0)

glMatrixMode(GL_MODELVIEW)

# load textures from images

tex   = Array(Uint32,1) # generating 1 textures

img, w, h = glimread(expanduser("~/.julia/SDL/Examples/NeHe/tut9/Star.bmp"))

glGenTextures(1,tex)
glBindTexture(GL_TEXTURE_2D,tex[1])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

# enable texture mapping and alpha blending

glEnable(GL_TEXTURE_2D)
glEnable(GL_BLEND)
glBlendFunc(GL_SRC_ALPHA, GL_ONE)

# main drawing loop

while true
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()

    glBindTexture(GL_TEXTURE_2D,tex[1])

    for loop = 1:STAR_NUM

        glLoadIdentity()

        glTranslate(0.0, 0.0, zoom)

        glRotate(tilt,1.0,0.0,0.0)
        glRotate(stars[loop].angle, 0.0, 1.0, 0.0)

        glTranslate(stars[loop].dist, 0.0, 0.0)

        glRotate(-stars[loop].angle, 0.0, 1.0, 0.0)
        glRotate(-tilt,1.0,0.0,0.0)

        if twinkle
            glColor4ub(stars[STAR_NUM - loop + 1].r,stars[STAR_NUM - loop + 1].g,stars[STAR_NUM - loop + 1].b,255)

            glBegin(GL_QUADS)
                glTexCoord(0.0, 0.0)
                glVertex(-1.0, -1.0, 0.0)
                glTexCoord(1.0, 0.0)
                glVertex(1.0, -1.0, 0.0)
                glTexCoord(1.0, 1.0)
                glVertex(1.0, 1.0, 0.0)
                glTexCoord(0.0, 1.0)
                glVertex(-1.0, 1.0, 0.0)
            glEnd()
        end

        # main star

        glRotate(spin, 0.0, 0.0, 1.0)
        glColor4ub(stars[loop].r, stars[loop].g, stars[loop].b, 255)

        glBegin(GL_QUADS)
            glTexCoord(0.0, 0.0)
            glVertex(-1.0, -1.0, 0.0)
            glTexCoord(1.0, 0.0)
            glVertex(1.0, -1.0, 0.0)
            glTexCoord(1.0, 1.0)
            glVertex(1.0, 1.0, 0.0)
            glTexCoord(0.0, 1.0)
            glVertex(-1.0, 1.0, 0.0)
        glEnd()

        spin              +=0.01
        stars[loop].angle +=loop/STAR_NUM
        stars[loop].dist  -=0.01

        if stars[loop].dist < 0.0
            stars[loop].dist  +=5.0
            stars[loop].r     = rand(1:256)
            stars[loop].g     = rand(1:256)
            stars[loop].b     = rand(1:256)
        end

    end

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
        elseif keystate[SDLK_t] == true
            println("Twinkle was: $twinkle")
            twinkle = (twinkle ? false : true)
            println("Twinkle is now: $twinkle")
        elseif keystate[SDLK_PAGEUP] == true
            zoom -= 0.02
        elseif keystate[SDLK_PAGEDOWN] == true
            zoom += 0.02
        elseif keystate[SDLK_UP] == true
            tilt -= 0.5
        elseif keystate[SDLK_DOWN] == true
            tilt += 0.5
        end
        keystate_checked = false
    end
end

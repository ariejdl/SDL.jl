# Tue 13 Nov 2012 04:13:36 PM EST
#
# NeHe Tut 10 - Move around in a 3D world
#
# NOTE: This example does not run slowly.  Rather, the key repeat rate limits
# the speed at which the "player's" position is updated, giving the illusion of
# a slow example.  Try lowering the key repeat interval to see it run at
# "normal" speed.
#
#
# Q - quit
# B - turn texture alpha-blending on/off
# L - turn lights on/off
# F - change texture filter (linear, nearest, mipmap)
# PageUp/Down - look up/down
# Up/Down - move forward/backward
# Left/Right - turn left/right


# load necessary GL/SDL routines

using OpenGL
@OpenGL.version "1.0"
@OpenGL.load
using SDL

# initialize variables

bpp                = 16
wintitle           = "NeHe Tut 10"
icontitle          = "NeHe Tut 10"
width              = 640
height             = 480

walkbias           = 0.0
walkbiasangle      = 0.0

lookupdown         = 0.0

xpos               = 0.0
zpos               = 0.0

yrot               = 0.0

LightAmbient       = [0.5f0, 0.5f0, 0.5f0, 1.0f0]
LightDiffuse       = [1.0f0, 1.0f0, 1.0f0, 1.0f0]
LightPosition      = [0.0f0, 0.0f0, 2.0f0, 1.0f0]

filter             = 3
light              = true
blend              = false

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

### auxiliary functions

# initialize global variables

global numtriangles = 0

function SetupWorld(world_map::String)

    global numtriangles

    filein       = open(world_map)
    world_data   = readlines(filein)

    numtriangles = parseint(chomp(split(world_data[1],' ')[2]))

    sector       = zeros(numtriangles,3,5)

    loop = 1
    vert = 1
    line = 1

    while line <= length(world_data)-2
        if world_data[2+line][1] != '/' && world_data[2+line][1] != '\n'
            while vert <= 3
                (x, y, z, u, v)      = split(chomp(world_data[2+line]),' ')
                x                    = parsefloat(x)
                y                    = parsefloat(y)
                z                    = parsefloat(z)
                u                    = parsefloat(u)
                v                    = parsefloat(v)
                sector[loop,vert,:]  = [x,y,z,u,v]
                vert                 += 1
                line                 += 1
            end
            vert = 1
            loop += 1
        else
            line += 1
        end
    end

    return sector

end

### end of auxiliary functions

# initialize sector1 with SetupWorld

sector1 = SetupWorld(expanduser("~/.julia/SDL/Examples/NeHe/tut10/world.txt"))

# load textures from images

tex   = Array(Uint32,3) # generating 3 textures

img, w, h = glimread(expanduser("~/.julia/SDL/Examples/NeHe/tut10/mud.bmp"))

glGenTextures(3,tex)
glBindTexture(GL_TEXTURE_2D,tex[1])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

glBindTexture(GL_TEXTURE_2D,tex[2])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

glBindTexture(GL_TEXTURE_2D,tex[3])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST)
glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

gluBuild2DMipmaps(GL_TEXTURE_2D, 3, w, h, GL_RGB, GL_UNSIGNED_BYTE, img)

# initialize lights

glLightfv(GL_LIGHT1, GL_AMBIENT, LightAmbient)
glLightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuse)
glLightfv(GL_LIGHT1, GL_POSITION, LightPosition)

glEnable(GL_LIGHT1)
glEnable(GL_LIGHTING)

# enable texture mapping and setup alpha blending

glEnable(GL_TEXTURE_2D)
glBlendFunc(GL_SRC_ALPHA, GL_ONE)

# main drawing loop

while true
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()

    xtrans = -xpos
    ztrans = -zpos
    ytrans = -walkbias-0.25
    sceneroty = 360.0-yrot

    glRotate(lookupdown, 1.0, 0.0, 0.0)
    glRotate(sceneroty, 0.0, 1.0, 0.0)
    glTranslate(xtrans, ytrans, ztrans)

    glBindTexture(GL_TEXTURE_2D,tex[filter])

    for face = 1:numtriangles
        glBegin(GL_TRIANGLES)
            glNormal(0.0, 0.0, 1.0)
            x_m = sector1[face,1,1]
            y_m = sector1[face,1,2]
            z_m = sector1[face,1,3]
            u_m = sector1[face,1,4]
            v_m = sector1[face,1,5]
            glTexCoord(u_m,v_m)
            glVertex(x_m,y_m,z_m)

            x_m = sector1[face,2,1]
            y_m = sector1[face,2,2]
            z_m = sector1[face,2,3]
            u_m = sector1[face,2,4]
            v_m = sector1[face,2,5]
            glTexCoord(u_m,v_m)
            glVertex(x_m,y_m,z_m)

            x_m = sector1[face,3,1]
            y_m = sector1[face,3,2]
            z_m = sector1[face,3,3]
            u_m = sector1[face,3,4]
            v_m = sector1[face,3,5]
            glTexCoord(u_m,v_m)
            glVertex(x_m,y_m,z_m)
        glEnd()
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
        elseif keystate[SDLK_b] == true
            println("Blend was: $blend")
            blend = (blend ? false : true)
            if blend
                glEnable(GL_BLEND)
                glDisable(GL_DEPTH_TEST)
            else
                glDisable(GL_BLEND)
                glEnable(GL_DEPTH_TEST)
            end
            println("Blend is now: $blend")
        elseif keystate[SDLK_l] == true
            println("Light was: $light")
            light = (light ? false : true)
            println("Light is now: $light")
            if light
                glEnable(GL_LIGHTING)
            else
                glDisable(GL_LIGHTING)
            end
        elseif keystate[SDLK_f] == true
            println("Filter was: $filter")
            filter +=1
            if filter > 3
                filter = 1
            end
            println("Filter is now: $filter")
        elseif keystate[SDLK_PAGEUP] == true
            lookupdown -=0.2
        elseif keystate[SDLK_PAGEDOWN] == true
            lookupdown +=1.0
        elseif keystate[SDLK_UP] == true
            xpos -=sin(degrees2radians(yrot))*0.05
            zpos -=cos(degrees2radians(yrot))*0.05
            walkbias +=10
            if walkbiasangle <= 359.0
                walkbiasangle =0.0
            else
                walkbiasangle +=10
            end
            walkbias = sin(degrees2radians(walkbiasangle))/20.0
        elseif keystate[SDLK_DOWN] == true
            xpos +=sin(degrees2radians(yrot))*0.05
            zpos +=cos(degrees2radians(yrot))*0.05
            walkbias -=10
            if walkbiasangle <= 1.0
                walkbiasangle =359.0
            else
                walkbiasangle -=10
            end
            walkbias = sin(degrees2radians(walkbiasangle))/20.0
        elseif keystate[SDLK_LEFT] == true
            yrot +=1.5
        elseif keystate[SDLK_RIGHT] == true
            yrot -=1.5
        end
        keystate_checked = false
    end
end

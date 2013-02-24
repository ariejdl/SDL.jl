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


# load necessary GL/SDL routines and image routines for loading textures

require("image")
global OpenGLver="2.1"
using OpenGL
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


### auxiliary functions

# initialize global variables

global numtriangles = 0

function SetupWorld(world_map::String)

    global numtriangles

    filein       = open(world_map)
    world_data   = readlines(filein)

    numtriangles = parse_int(chomp(split(world_data[1],' ')[2]))

    sector       = zeros(numtriangles,3,5)

    loop = 1
    vert = 1
    line = 1
    
    while line <= length(world_data)-2
        if world_data[2+line][1] != '/' && world_data[2+line][1] != '\n'
            while vert <= 3
                (x, y, z, u, v)      = split(chomp(world_data[2+line]),' ')
                x                    = parse_float(x)
                y                    = parse_float(y)
                z                    = parse_float(z)
                u                    = parse_float(u)
                v                    = parse_float(v)
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

img3D = imread(expanduser("~/.julia/SDL/Examples/NeHe/tut10/mud.bmp"))
w     = size(img3D,2)
h     = size(img3D,1)

img   = glimg(img3D) # see OpenGLAux.jl for description

glgentextures(3,tex)
glbindtexture(GL_TEXTURE_2D,tex[1])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

glbindtexture(GL_TEXTURE_2D,tex[2])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

glbindtexture(GL_TEXTURE_2D,tex[3])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST)
glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

glubuild2dmipmaps(GL_TEXTURE_2D, 3, w, h, GL_RGB, GL_UNSIGNED_BYTE, img)

# initialize lights

gllightfv(GL_LIGHT1, GL_AMBIENT, LightAmbient)
gllightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuse)
gllightfv(GL_LIGHT1, GL_POSITION, LightPosition)

glenable(GL_LIGHT1)
glenable(GL_LIGHTING)

# enable texture mapping and setup alpha blending

glenable(GL_TEXTURE_2D)
glblendfunc(GL_SRC_ALPHA, GL_ONE)

# main drawing loop

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    xtrans = -xpos
    ztrans = -zpos
    ytrans = -walkbias-0.25
    sceneroty = 360.0-yrot

    glrotate(lookupdown, 1.0, 0.0, 0.0)
    glrotate(sceneroty, 0.0, 1.0, 0.0)
    gltranslate(xtrans, ytrans, ztrans)

    glbindtexture(GL_TEXTURE_2D,tex[filter])

    for face = 1:numtriangles
        glbegin(GL_TRIANGLES)
            glnormal(0.0, 0.0, 1.0)
            x_m = sector1[face,1,1]
            y_m = sector1[face,1,2]
            z_m = sector1[face,1,3]
            u_m = sector1[face,1,4]
            v_m = sector1[face,1,5]
            gltexcoord(u_m,v_m) 
            glvertex(x_m,y_m,z_m)

            x_m = sector1[face,2,1]
            y_m = sector1[face,2,2]
            z_m = sector1[face,2,3]
            u_m = sector1[face,2,4]
            v_m = sector1[face,2,5]
            gltexcoord(u_m,v_m) 
            glvertex(x_m,y_m,z_m)

            x_m = sector1[face,3,1]
            y_m = sector1[face,3,2]
            z_m = sector1[face,3,3]
            u_m = sector1[face,3,4]
            v_m = sector1[face,3,5]
            gltexcoord(u_m,v_m)
            glvertex(x_m,y_m,z_m)
        glend()
    end

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
        elseif keystate[SDLK_b] == true
            println("Blend was: $blend")
            blend = (blend ? false : true)
            if blend
                glenable(GL_BLEND)
                gldisable(GL_DEPTH_TEST)
            else
                gldisable(GL_BLEND)
                glenable(GL_DEPTH_TEST)
            end
            println("Blend is now: $blend")
        elseif keystate[SDLK_l] == true
            println("Light was: $light")
            light = (light ? false : true)
            println("Light is now: $light")
            if light
                glenable(GL_LIGHTING)
            else
                gldisable(GL_LIGHTING)
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

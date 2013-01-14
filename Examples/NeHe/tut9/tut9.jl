# Tue 13 Nov 2012 04:13:36 PM EST 
#
# NeHe Tut 9 - Make some colored stars and play w/ alpha blending a bit more
#
# Q - quit
# T - turn "twinkle" on/off
# PageUp/Down - move camera closer/further away
# Up/Down - increase/decrease tilt about x-axis


# load necessary GL/SDL routines and image routines for loading textures

require("image")
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

tempr = randi(256)
tempg = randi(256) 
tempb = randi(256) 

stars = [star(tempr,tempg,tempb,0.0,0.0)] # Julia doesn't like it when you try to initialize an empty array of
                                          # a composite type and try to fill it afterwards, so we
                                          # start with a 1-element vector and tack on values

for loop = 1:STAR_NUM-1
    tempr = randi(256)
    tempg = randi(256)
    tempb = randi(256)
    stars = push!(stars, star(tempr,tempg,tempb,loop/STAR_NUM*5.0,0.0))
end # I haven't found a better way to make an array of composite types

tilt             = 90.0
zoom             = -15.0
spin             = 0.0

twinkle          = false

keystate_checked = false
lastkeycheckTime = 0
key_repeatrate   = 75

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
glshademodel(GL_SMOOTH)
glhint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

glmatrixmode(GL_PROJECTION)
glloadidentity()

gluperspective(45.0,width/height,0.1,100.0)

glmatrixmode(GL_MODELVIEW)

# load textures from images

tex   = Array(Uint32,1) # generating 1 textures

img3D = imread(expanduser("~/.julia/SDL/Examples/tut9/Star.bmp"))
w     = size(img3D,2)
h     = size(img3D,1)

img   = glimg(img3D) # see OpenGLAux.jl for description

glgentextures(1,tex)
glbindtexture(GL_TEXTURE_2D,tex[1])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

# enable texture mapping and alpha blending

glenable(GL_TEXTURE_2D)
glenable(GL_BLEND)
glblendfunc(GL_SRC_ALPHA, GL_ONE)

# drawing routines

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    glbindtexture(GL_TEXTURE_2D,tex[1])

    for loop = 1:STAR_NUM

        glloadidentity()

        gltranslate(0.0, 0.0, zoom)

        glrotate(tilt,1.0,0.0,0.0)
        glrotate(stars[loop].angle, 0.0, 1.0, 0.0)

        gltranslate(stars[loop].dist, 0.0, 0.0)

        glrotate(-stars[loop].angle, 0.0, 1.0, 0.0)
        glrotate(-tilt,1.0,0.0,0.0)

        if twinkle
            glcolor4ub(stars[STAR_NUM - loop + 1].r,stars[STAR_NUM - loop + 1].g,stars[STAR_NUM - loop + 1].b,255)

            glbegin(GL_QUADS)
                gltexcoord(0.0, 0.0)
                glvertex(-1.0, -1.0, 0.0)
                gltexcoord(1.0, 0.0)
                glvertex(1.0, -1.0, 0.0)
                gltexcoord(1.0, 1.0)
                glvertex(1.0, 1.0, 0.0)
                gltexcoord(0.0, 1.0)
                glvertex(-1.0, 1.0, 0.0)
            glend()
        end

        # main star

        glrotate(spin, 0.0, 0.0, 1.0)
        glcolor4ub(stars[loop].r, stars[loop].g, stars[loop].b, 255)

        glbegin(GL_QUADS)
            gltexcoord(0.0, 0.0)
            glvertex(-1.0, -1.0, 0.0)
            gltexcoord(1.0, 0.0)
            glvertex(1.0, -1.0, 0.0)
            gltexcoord(1.0, 1.0)
            glvertex(1.0, 1.0, 0.0)
            gltexcoord(0.0, 1.0)
            glvertex(-1.0, 1.0, 0.0)
        glend()

        spin              +=0.01
        stars[loop].angle +=loop/STAR_NUM
        stars[loop].dist  -=0.01

        if stars[loop].dist < 0.0
            stars[loop].dist  +=5.0
            stars[loop].r     = randi(256)
            stars[loop].g     = randi(256)
            stars[loop].b     = randi(256)
        end

    end

    sdl_gl_swapbuffers()

    sdl_pumpevents()
    if sdl_getticks() - lastkeycheckTime >= key_repeatrate
        keystate         = sdl_getkeystate()
        keystate_checked = true
        lastkeychecktime = sdl_getticks()
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

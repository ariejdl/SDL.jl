# Tue 13 Nov 2012 04:13:36 PM EST 
#
# NeHe Tut 8 - Implement lights and rotate an alpha-blended, textured cube


# load necessary GL/SDL routines

load("image")

require("SDL")
using SDL

# initialize variables

bpp            = 16
wintitle       = "NeHe Tut 8"
icontitle      = "NeHe Tut 8"
width          = 640
height         = 480

light          = true
blend          = true
filter         = 3

xrot           = 0.0
yrot           = 0.0
xspeed         = 0.0
yspeed         = 0.0

z              = -5.0

cube_size      = 1.0

LightAmbient   = [0.5f0, 0.5f0, 0.5f0, 1.0f0]
LightDiffuse   = [1.0f0, 1.0f0, 1.0f0, 1.0f0]
LightPosition  = [0.0f0, 0.0f0, 2.0f0, 1.0f0]

saved_keystate = false

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

function cube(size)  # the cube function now includes surface normal specification for proper lighting
  glbegin(GL_QUADS)
    # Front Face
    glnormal(0.0,0.0,1.0)
    gltexcoord(0.0, 0.0)
    glvertex(-size, -size, size)
    gltexcoord(1.0, 0.0)
    glvertex(size, -size, size)
    gltexcoord(1.0, 1.0)
    glvertex(size, size, size)
    gltexcoord(0.0, 1.0)
    glvertex(-size, size, size)

    # Back Face
    glnormal(0.0,0.0,-1.0)
    gltexcoord(1.0, 0.0)
    glvertex(-size, -size, -size)
    gltexcoord(1.0, 1.0)
    glvertex(-size, size, -size)
    gltexcoord(0.0, 1.0)
    glvertex(size, size, -size)
    gltexcoord(0.0, 0.0)
    glvertex(size, -size, -size)

    # Top Face
    glnormal(0.0,1.0,0.0)
    gltexcoord(0.0, 1.0)
    glvertex(-size, size, -size)
    gltexcoord(0.0, 0.0)
    glvertex(-size, size, size)
    gltexcoord(1.0, 0.0)
    glvertex(size, size, size)
    gltexcoord(1.0, 1.0)
    glvertex(size, size, -size)

    # Bottom Face
    glnormal(0.0,-1.0,0.0)
    gltexcoord(1.0, 1.0)
    glvertex(-size, -size, -size)
    gltexcoord(0.0, 1.0)
    glvertex(size, -size, -size)
    gltexcoord(0.0, 0.0)
    glvertex(size, -size, size)
    gltexcoord(1.0, 0.0)
    glvertex(-size, -size, size)

    # Right Face
    glnormal(1.0,0.0,0.0)
    gltexcoord(1.0, 0.0)
    glvertex(size, -size, -size)
    gltexcoord(1.0, 1.0)
    glvertex(size, size, -size)
    gltexcoord(0.0, 1.0)
    glvertex(size, size, size)
    gltexcoord(0.0, 0.0)
    glvertex(size, -size, size)

    # Left Face
    glnormal(-1.0,0.0,0.0)
    gltexcoord(0.0, 0.0)
    glvertex(-size, -size, -size)
    gltexcoord(1.0, 0.0)
    glvertex(-size, -size, size)
    gltexcoord(1.0, 1.0)
    glvertex(-size, size, size)
    gltexcoord(0.0, 1.0)
    glvertex(-size, size, -size)
  glend()
end

### end of auxiliary functions

# load textures from images

tex   = Array(Uint32,3) # generating 3 textures

img3D = imread(path_expand("~/.julia/SDL/Examples/tut8/glass.bmp"))
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

# enable texture mapping

glenable(GL_TEXTURE_2D)
glenable(GL_LIGHTING)
glenable(GL_BLEND)

# enable alpha blending for textures

glblendfunc(GL_SRC_ALPHA, GL_ONE)
glcolor(1.0, 1.0, 1.0, 0.5)

# drawing routines

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    gltranslate(0.0, 0.0, z)

    glrotate(xrot,1.0,0.0,0.0)
    glrotate(yrot,0.0,1.0,0.0)

    glbindtexture(GL_TEXTURE_2D,tex[filter])
    cube(cube_size)

    xrot +=xspeed
    yrot +=yspeed

    sdl_gl_swapbuffers()

    sdl_pumpevents()
    keystate = sdl_getkeystate()

    # Julia is so fast that a single key press lasts through several iterations
    # of this loop.  This means that one press is seen as 50 or more presses by
    # the SDL event system, which can make the demo very bewildering.  To
    # correct this, we only check keypresses when the keyboard state has
    # changed.  An unfortunate down-side, for instance, is that the "UP" key
    # cannot be held to make "xspeed" increase continuosly.  One must press the
    # "UP" button over and over to increase "xspeed" in discrete steps.

    if saved_keystate == false
        prev_keystate = keystate
        saved_keystate = true
    end

    if keystate != prev_keystate
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
            filter += 1
            if filter > 3
                filter = 1
            end
            println("Filter is now: $filter")
        elseif keystate[SDLK_PAGEUP] == true
            z -= 0.02
        elseif keystate[SDLK_PAGEDOWN] == true
            z += 0.02
        elseif keystate[SDLK_UP] == true
            xspeed -= 0.01
        elseif keystate[SDLK_DOWN] == true
            xspeed += 0.01
        elseif keystate[SDLK_LEFT] == true
            yspeed -= 0.01
        elseif keystate[SDLK_RIGHT] == true
            yspeed += 0.01
        end
        prev_keystate = keystate
    end
end

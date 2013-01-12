# Sun 30 Dec 2012 01:22:44 PM EST
#
# NeHe Tut 17 - 2D texture font


# load necessary GL/SDL routines

load("image")

require("SDL")
using SDL

# initialize variables

bpp              = 16
wintitle         = "NeHe Tut 17"
icontitle        = "NeHe Tut 17"
width            = 640
height           = 480

T0               = 0
Frames           = 0

cnt1             = 0
cnt2             = 0

keystate_checked = false
lastkeycheckTime = 0
key_duration     = 75

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
gldepthfunc(GL_LEQUAL)	 
glshademodel(GL_SMOOTH)
glenable(GL_DEPTH_TEST)

glmatrixmode(GL_PROJECTION)
glloadidentity()

gluperspective(45.0,width/height,0.1,100.0)

glmatrixmode(GL_MODELVIEW)

### auxiliary functions

function glprint(x::Integer, y::Integer, string::String, set::Integer)
    if set > 1
        set = 1
    end

    glbindtexture(GL_TEXTURE_2D, tex[1])
    gldisable(GL_DEPTH_TEST)

    glmatrixmode(GL_PROJECTION)
    glpushmatrix()

    glloadidentity()
    glortho(0, 640, 0, 480, -1, 1)

    glmatrixmode(GL_MODELVIEW)
    glpushmatrix()
    glloadidentity()

    gltranslate(x, y, 0)
    gllistbase(uint32(base-32+(128*set)))
    glcalllists(strlen(string), GL_BYTE, string)
    
    glmatrixmode(GL_PROJECTION)
    glpopmatrix()
    
    glmatrixmode(GL_MODELVIEW)
    glpopmatrix()
end

### end of auxiliary functions

# load textures from images

tex       = Array(Uint32,2) # generating 2 textures

img3D     = imread(path_expand("~/.julia/SDL/Examples/tut17/font.bmp"))
w         = size(img3D,2)
h         = size(img3D,1)

img_font  = glimg(img3D) # see OpenGLAux.jl for description

img3D     = imread(path_expand("~/.julia/SDL/Examples/tut17/bumps.bmp"))
w         = size(img3D,2)
h         = size(img3D,1)

img_bumps = glimg(img3D) # see OpenGLAux.jl for description

glgentextures(2,tex)
glbindtexture(GL_TEXTURE_2D,tex[1])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img_font)

glbindtexture(GL_TEXTURE_2D,tex[2])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img_bumps)

# enable texture mapping & blending

glenable(GL_TEXTURE_2D)
glblendfunc(GL_SRC_ALPHA, GL_ONE)

# build the fonts

base = glgenlists(256)
glbindtexture(GL_TEXTURE_2D, tex[1])

for loop = 1:256
    cx = (loop%16)/16
    cy = (loop/16)/16

    glnewlist(uint32(base+(loop-1)), GL_COMPILE)
        glbegin(GL_QUADS)
            gltexcoord(cx, 1-cy-0.0625)
            glvertex(0, 0)
            gltexcoord(cx+0.0625, 1-cy-0.0625)
            glvertex(16, 0)
            gltexcoord(cx+0.0625, 1-cy)
            glvertex(16, 16)
            gltexcoord(cx, 1-cy)
            glvertex(0, 16)
        glend()
        gltranslate(10, 0, 0)
    glendlist()
end

# drawing routines

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    glbindtexture(GL_TEXTURE_2D,tex[2])

    gltranslate(0.0,0.0,-5.0)
    glrotate(45.0, 0.0, 0.0, 1.0)
    glrotate(cnt1*30.0, 1.0, 1.0, 0.0)

    gldisable(GL_BLEND)
    glcolor(1.0, 1.0, 1.0)
    
    glbegin(GL_QUADS)
        gltexcoord(0.0, 0.0)
        glvertex(-1.0, 1.0)
        gltexcoord(1.0, 0.0)
        glvertex(1.0, 1.0)
        gltexcoord(1.0, 1.0)
        glvertex(1.0, -1.0)
        gltexcoord(0.0, 1.0)
        glvertex(-1.0, -1.0)
    glend()

    glrotate(90.0, 1.0, 1.0, 0.0)
    glbegin(GL_QUADS)
        gltexcoord(0.0, 0.0)
        glvertex(-1.0, 1.0)
        gltexcoord(1.0, 0.0)
        glvertex(1.0, 1.0)
        gltexcoord(1.0, 1.0)
        glvertex(1.0, -1.0)
        gltexcoord(0.0, 1.0)
        glvertex(-1.0, -1.0)
    glend()

    glenable(GL_BLEND)
    glloadidentity()

    glcolor(1.0cos(cnt1), 1.0sin(cnt2), 1.0-0.5cos(cnt1+cnt2))
    glprint(int(280+250cos(cnt1)), int(235+200sin(cnt2)), "NeHe", 0)
    glcolor(1.0sin(cnt2), 1.0-0.5cos(cnt1+cnt2), 1.0cos(cnt1))
    glprint(int(280+230cos(cnt2)), int(235+200sin(cnt1)), "OpenGL", 1)

    glcolor(0.0, 0.0, 1.0)
    glprint(int(240+200cos((cnt2+cnt1)/5)), 2, "JuliaLang", 0)
    glcolor(1.0, 1.0, 1.0)
    glprint(int(242+200cos((cnt2+cnt1)/5)), 2, "JuliaLang", 0)

    cnt1 +=0.01
    cnt2 +=0.0081

    sdl_gl_swapbuffers()

    sdl_pumpevents()
    if sdl_getticks() - lastkeycheckTime >= key_duration
        keystate         = sdl_getkeystate()
        keystate_checked = true
        lastkeychecktime = sdl_getticks()
    end

    # julia is so fast that a single key press lasts through several iterations
    # of this loop.  this means that one press can be seen as 50 or more
    # presses by the sdl event system, which makes the demo very bewildering.
    # to correct for this, we only check keypresses every 100ms.

    if keystate_checked == true
        if keystate[SDLK_q] == true
            gldeletelists(base,256)
            gldeletetextures(2,tex)
            break
        end
        keystate_checked = false
    end
end

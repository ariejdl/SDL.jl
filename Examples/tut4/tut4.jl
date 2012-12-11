# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 4 - Rotate colored (rainbow) triangle and colored (cyan) square


# load necessary GL/SDL routines

require("SDL")
using SDL

# initialize variables

bpp       = 16
wintitle  = "NeHe Tut 4"
icontitle = "NeHe Tut 4"
width     = 640
height    = 480

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

# initialize variables

rtri  = 0.0
rquad = 0.0

# drawing routines

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    gltranslate(-1.5,0.0,-6.0)
    glrotate(rtri,0.0,1.0,0.0)

    glbegin(GL_POLYGON)
      glcolor(1.0,0,0)
      glvertex(0.0,1.0,0.0)
      glcolor(0,1.0,0)
      glvertex(1.0,-1.0,0.0)
      glcolor(0,0,1.0)
      glvertex(-1.0,-1.0,0.0)
    glend()

    glloadidentity()

    gltranslate(1.5,0.0,-6.0)
    glrotate(rquad,1.0,0.0,0.0)

    gltranslate(0.8,0,0)

    glcolor(0.5,0.5,1.0)
    glbegin(GL_QUADS)
        glvertex(-1.0,1.0,0.0)
        glvertex(1.0,1.0,0.0)
        glvertex(1.0,-1.0,0.0)
        glvertex(-1.0,-1.0,0.0)
    glend()

    rtri  +=0.2
    rquad -=0.2

    sdl_gl_swapbuffers()
end

# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 2 - Draw a triangle and a square


# load necessary GL/SDL routines

require("SDL")
using SDL

# initialize variables

bpp       = 16
wintitle  = "NeHe Tut 2"
icontitle = "NeHe Tut 2"
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

# drawing routines

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    glcolor(1.0,1.0,1.0)

    gltranslate(-1.5,0.0,-6.0)

    glbegin(GL_POLYGON)
      glvertex(0.0,1.0,0.0)
      glvertex(1.0,-1.0,0.0)
      glvertex(-1.0,-1.0,0.0)
    glend()

    gltranslate(3.0,0.0,0.0)

    glbegin(GL_QUADS)
        glvertex(-1.0,1.0,0.0)
        glvertex(1.0,1.0,0.0)
        glvertex(1.0,-1.0,0.0)
        glvertex(-1.0,-1.0,0.0)
    glend()

    sdl_gl_swapbuffers()
end

# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 3 - Draw a colored (rainbow) triangle and a colored (blue) square


# load necessary GL/SDL routines

require("SDL")
using SDL

# initialize variables

bpp            = 16
wintitle       = "NeHe Tut 3"
icontitle      = "NeHe Tut 3"
width          = 640
height         = 480

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

# drawing routine

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    gltranslate(-1.5,0.0,-6.0)

    glbegin(GL_POLYGON)
      glcolor(1.0,0,0)
      glvertex(0.0,1.0,0.0)
      glcolor(0,1.0,0)
      glvertex(1.0,-1.0,0.0)
      glcolor(0,0,1.0)
      glvertex(-1.0,-1.0,0.0)
    glend()

    gltranslate(3.0,0,0)

    glcolor(0.5,0.5,1.0)
    glbegin(GL_QUADS)
        glvertex(-1.0,1.0,0.0)
        glvertex(1.0,1.0,0.0)
        glvertex(1.0,-1.0,0.0)
        glvertex(-1.0,-1.0,0.0)
    glend()

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
        end
        prev_keystate = keystate
    end
end

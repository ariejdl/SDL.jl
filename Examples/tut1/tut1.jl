# Tue 23 Oct 2012 07:10:59 PM EDT
#
# NeHe Tut 1 - Open a window


# load necessary GL/SDL routines

require("SDL")
using SDL

# initialize variables

bpp            = 16
wintitle       = "NeHe Tut 1"
icontitle      = "NeHe Tut 1"
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

# drawing routines

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

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

# Sat 29 Dec 2012 11:48:33 PM EST
#
# NeHe Tut 12 - Display Lists
#
# Q - quit
# Up/Down - increase/decrease rotation of each cube about it's own x-axis
# Left/Right - increase/decrease rotation of each cube about it's own y-axis


# load necessary GL/SDL routines and image routines for loading textures  

require("image")
using OpenGL
using SDL

# initialize variables

bpp       = 16
wintitle  = "NeHe Tut 12"
icontitle = "NeHe Tut 12"
width     = 640
height    = 480

T0        = 0
Frames    = 0

xrot      = 0
yrot      = 0

boxcol    = [1.0 0.0 0.0;
             1.0 0.5 0.0;
             1.0 1.0 0.0;
             0.0 1.0 0.0;
             0.0 1.0 1.0]

topcol    = [0.5 0.0  0.0;
             0.5 0.25 0.0;
             0.5 0.5  0.0;
             0.0 0.5  0.0;
             0.0 0.5  0.5]

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
glclearcolor(0.0, 0.0, 0.0, 0.5)
glcleardepth(1.0)			 
gldepthfunc(GL_LEQUAL)	 
glenable(GL_DEPTH_TEST)
glshademodel(GL_SMOOTH)
glhint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

#enable simple lighting

glenable(GL_LIGHT0)         
glenable(GL_LIGHTING)
glenable(GL_COLOR_MATERIAL)

glmatrixmode(GL_PROJECTION)
glloadidentity()

gluperspective(45.0,width/height,0.1,100.0)

glmatrixmode(GL_MODELVIEW)

# build the display lists

box = glgenlists(2)

glnewlist(box, GL_COMPILE)
    glbegin(GL_QUADS)
        # Bottom Face
        gltexcoord(0.0, 1.0)
        glvertex(-1.0, -1.0, -1.0)
        gltexcoord(1.0, 1.0)
        glvertex(1.0, -1.0, -1.0)
        gltexcoord(1.0, 0.0)
        glvertex(1.0, -1.0,  1.0)
        gltexcoord(0.0, 0.0)
        glvertex(-1.0, -1.0,  1.0)

        # Front Face
        gltexcoord(1.0, 0.0)
        glvertex(-1.0, -1.0,  1.0)
        gltexcoord(0.0, 0.0)
        glvertex(1.0, -1.0,  1.0)
        gltexcoord(0.0, 1.0)
        glvertex(1.0,  1.0,  1.0)
        gltexcoord(1.0, 1.0)
        glvertex(-1.0,  1.0,  1.0)

        # Back Face
        gltexcoord(0.0, 0.0)
        glvertex(-1.0, -1.0, -1.0)
        gltexcoord(0.0, 1.0)
        glvertex(-1.0,  1.0, -1.0)
        gltexcoord(1.0, 1.0)
        glvertex(1.0,  1.0, -1.0)
        gltexcoord(1.0, 0.0)
        glvertex(1.0, -1.0, -1.0)

        # Right Face
        gltexcoord(0.0, 0.0)
        glvertex(1.0, -1.0, -1.0)
        gltexcoord(0.0, 1.0)
        glvertex(1.0,  1.0, -1.0)
        gltexcoord(1.0, 1.0)
        glvertex(1.0,  1.0,  1.0)
        gltexcoord(1.0, 0.0)
        glvertex(1.0, -1.0,  1.0)

        # Left Face
        gltexcoord(1.0, 0.0)
        glvertex(-1.0, -1.0, -1.0)
        gltexcoord(0.0, 0.0)
        glvertex(-1.0, -1.0,  1.0)
        gltexcoord(0.0, 1.0)
        glvertex(-1.0,  1.0,  1.0)
        gltexcoord(1.0, 1.0)
        glvertex(-1.0,  1.0, -1.0)
    glend()
glendlist()

top = uint32(box+1)

glnewlist(top, GL_COMPILE)
    glbegin(GL_QUADS)
        # Top Face
        gltexcoord(1.0, 1.0)
        glvertex(-1.0, 1.0, -1.0)
        gltexcoord(1.0, 0.0)
        glvertex(-1.0, 1.0,  1.0)
        gltexcoord(0.0, 0.0)
        glvertex(1.0, 1.0,  1.0)
        gltexcoord(0.0, 1.0)
        glvertex(1.0, 1.0, -1.0)
    glend()
glendlist()

# load textures from images

tex   = Array(Uint32,1) # generating 1 texture

img3D = imread(expanduser("~/.julia/SDL/Examples/NeHe/tut12/cube.bmp"))
w     = size(img3D,2)
h     = size(img3D,1)

img   = glimg(img3D) # see OpenGLAux.jl for description

glgentextures(1,tex)
glbindtexture(GL_TEXTURE_2D,tex[1])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR_MIPMAP_NEAREST)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)
glubuild2dmipmaps(GL_TEXTURE_2D, 3, w, h, GL_RGB, GL_UNSIGNED_BYTE, img)

# enable texture mapping

glenable(GL_TEXTURE_2D)

# main drawing loop

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    glbindtexture(GL_TEXTURE_2D, tex[1])

    for yloop = 1:5
	      for xloop = 1:yloop
            glloadidentity()

            gltranslate(1.4+2.8xloop-1.4yloop, ((6.0-yloop)*2.4)-7.0, -20.0)

            glrotate(45.0-(2.0yloop)+xrot, 1.0, 0.0, 0.0)
            glrotate(45.0+yrot, 0.0, 1.0, 0.0)

            glcolor(boxcol[yloop,:])
            glcalllist(box)         
            
            glcolor(topcol[yloop,:])
            glcalllist(top)        
        end
    end

    sdl_gl_swapbuffers()

    Frames +=1
    t = sdl_getticks()
    if (t - T0) >= 5000
        seconds = (t - T0)/1000
        fps = Frames/seconds
        println("$Frames frames in $seconds seconds = $fps")
        T0 = t
        Frames = 0
    end

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
        elseif keystate[SDLK_LEFT] == true
            yrot -=0.2
        elseif keystate[SDLK_RIGHT] == true
            yrot +=0.2
        elseif keystate[SDLK_UP] == true
            xrot -=0.2
        elseif keystate[SDLK_DOWN] == true
            xrot +=0.2
        end
        keystate_checked = false
    end
end

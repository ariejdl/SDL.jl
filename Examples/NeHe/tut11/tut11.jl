# Fri 28 Dec 2012 03:51:13 PM EST
#
# NeHe Tut 11 - Flag Effect (Waving Texture)
#
# Q - quit


# load necessary GL/SDL routines and image routines for loading textures

require("image")
using OpenGL
using SDL

# initialize variables

bpp            = 16
wintitle       = "NeHe Tut 11"
icontitle      = "NeHe Tut 11"
width          = 640
height         = 480

points         = Array(Float64,(45,45,3))

for x=1:45
    for y=1:45
        points[x,y,1] = x/5-4.5
        points[x,y,2] = y/5-4.5
        points[x,y,3] = sin((((x/5)*40)/360)*2*pi)
    end
end

wiggle_count       = 0

xrot               = 0
yrot               = 0
zrot               = 0

T0                 = 0
Frames             = 0

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

glmatrixmode(GL_PROJECTION)
glloadidentity()

gluperspective(45.0,width/height,0.1,100.0)

glmatrixmode(GL_MODELVIEW)

# load textures from images

tex   = Array(Uint32,1) # generating 1 texture

img3D = imread(expanduser("~/.julia/SDL/Examples/NeHe/tut11/tim.bmp"))
w     = size(img3D,2)
h     = size(img3D,1)

img   = glimg(img3D) # see OpenGLAux.jl for description

glgentextures(1,tex)
glbindtexture(GL_TEXTURE_2D,tex[1])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

# enable texture mapping

glenable(GL_TEXTURE_2D)

# enable Polygon filling

glpolygonmode(GL_BACK, GL_FILL)
glpolygonmode(GL_FRONT, GL_LINE)

# main drawing loop

while true
    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    gltranslate(0.0, 0.0, -12.0)

    glrotate(xrot,1.0,0.0,0.0)
    glrotate(yrot,0.0,1.0,0.0)
    glrotate(zrot,0.0,0.0,1.0)

    glbindtexture(GL_TEXTURE_2D,tex[1])

    glbegin(GL_QUADS)
        for x=1:44
            for y=1:44
                tex_x  = x/45
                tex_y  = y/45
                tex_xb = (x+1)/45
                tex_yb = (y+1)/45

                gltexcoord(tex_x, tex_y)
                glvertex(points[x,y,1],points[x,y,2],points[x,y,3])
                gltexcoord(tex_x, tex_yb)
                glvertex(points[x,y+1,1],points[x,y+1,2],points[x,y+1,3])
                gltexcoord(tex_xb, tex_yb)
                glvertex(points[x+1,y+1,1],points[x+1,y+1,2],points[x+1,y+1,3])
                gltexcoord(tex_xb, tex_y)
                glvertex(points[x+1,y,1],points[x+1,y,2],points[x+1,y,3])
            end
        end
    glend()

    if wiggle_count == 2
        for y=1:45
            hold = points[1,y,3]
            for x=1:44
                points[x,y,3] = points[x+1,y,3]
            end
            points[45,y,3] = hold
        end
        wiggle_count = 0
    end

    wiggle_count +=1

    Frames +=1
    t = sdl_getticks()
    if (t - T0) >= 5000
        seconds = (t - T0)/1000
        fps = Frames/seconds
        println("$Frames frames in $seconds seconds = $fps")
        T0 = t
        Frames = 0
    end

    xrot +=0.3
    yrot +=0.2
    zrot +=0.4

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
        end
        keystate_checked = false
    end
end

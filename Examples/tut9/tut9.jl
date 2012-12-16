# Tue 13 Nov 2012 04:13:36 PM EST 
#
# NeHe Tut 9 - Make some colored stars and play w/ alpha blending a bit more


# load necessary GL/SDL routines

load("image")

require("SDL")
using SDL

# initialize variables

bpp       = 16
wintitle  = "NeHe Tut 9"
icontitle = "NeHe Tut 9"
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

const STAR_NUM      = 50
const max_star_dist = 0.3
const star_size     = 1.0

type star
    r::Int  
    g::Int
    b::Int
    dist::Float64
    angle::Float64
end

tempr = convert(Int,round(rand()*256))
tempg = convert(Int,round(rand()*256))
tempb = convert(Int,round(rand()*256))

stars = [star(tempr,tempg,tempb,0*1.0/STAR_NUM*max_star_dist,0.0)] # Julia doesn't like it when you try to initialize an empty array of
                                                         # a composite type and try to fill it afterwards, so we start with a scalar
                                                         # and tack on values

for loop = 1:STAR_NUM-1
    tempr = convert(Int,round(rand()*256))
    tempg = convert(Int,round(rand()*256))
    tempb = convert(Int,round(rand()*256))
    stars = [stars star(tempr,tempg,tempb,loop*1.0/STAR_NUM*max_star_dist,0.0)]
end # I haven't found a better way to make an array of composite types

tilt    = 90.0
zoom    = -15.0
spin    = 0.0

twinkle = false

# load textures from images

tex   = Array(Uint8,1) # generating 1 textures

img3D = imread(path_expand("~/.julia/SDL/Examples/tut9/Star.bmp"))
w     = size(img3D,2)
h     = size(img3D,1)

img   = glimg(img3D) # see OpenGLAux.jl for description

glgentextures(1,tex)
glbindtexture(GL_TEXTURE_2D,tex[1])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glteximage2d(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

# enable texture mapping and alpha blending

glblendfunc(GL_SRC_ALPHA, GL_ONE)
glenable(GL_TEXTURE_2D)
glenable(GL_BLEND)

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
                glvertex(-star_size, -star_size, 0.0)
                gltexcoord(1.0, 0.0)
                glvertex(star_size, -star_size, 0.0)
                gltexcoord(1.0, 1.0)
                glvertex(star_size, star_size, 0.0)
            glend()

        end

        # main star

        glrotate(spin, 0.0, 0.0, 1.0)
        glcolor4ub(stars[loop].r, stars[loop].g, stars[loop].b, 255)

        glbegin(GL_QUADS)
            gltexcoord(0.0, 0.0)
            glvertex(-star_size, -star_size, 0.0)
            gltexcoord(1.0, 0.0)
            glvertex(star_size, -star_size, 0.0)
            gltexcoord(1.0, 1.0)
            glvertex(star_size, star_size, 0.0)
            gltexcoord(0.0, 1.0)
            glvertex(-star_size, star_size, 0.0)
        glend()

        spin              += 0.01
        stars[loop].angle += loop * 1.0/STAR_NUM * 1.0
        stars[loop].dist  -= 0.01

        if stars[loop].dist < 0.0
            stars[loop].dist  += max_star_dist
            stars[loop].r     = convert(Int,round(rand()*256))
            stars[loop].g     = convert(Int,round(rand()*256))
            stars[loop].b     = convert(Int,round(rand()*256))
        end

    end

    sdl_gl_swapbuffers()
end

# Tue 13 Nov 2012 04:13:36 PM EST 
#
# NeHe Tut 10 - Move around in a 3D world


# load necessary GL/SDL routines

load("image")

require("SDL")
using SDL

# initialize variables

bpp       = 16
wintitle  = "NeHe Tut 10"
icontitle = "NeHe Tut 10"
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

# initialize global variables

global numtriangles = 0

### auxiliary functions

function SetupWorld(world_map::String)

    global numtriangles

    filein       = open(world_map)
    world_data   = readlines(filein)

    numtriangles = parse_int(chomp(split(world_data[1],' ')[2]))

    sector       = zeros(numtriangles,3,5)

    loop = 1
    vert = 1
    line = 1
    
    while line <= length(world_data)-2
        if world_data[2+line][1] != '/' && world_data[2+line][1] != '\n'
            while vert <= 3
                (x, y, z, u, v)      = split(chomp(world_data[2+line]),' ')
                x                    = parse_float(x)
                y                    = parse_float(y)
                z                    = parse_float(z)
                u                    = parse_float(u)
                v                    = parse_float(v)
                sector[loop,vert,:]  = [x,y,z,u,v]
                vert                 += 1
                line                 += 1
            end
            vert = 1
            loop += 1
        else
            line += 1
        end
    end

    return sector

end

### end of auxiliary functions

# initialize variables

walkbias      = 0.0
walkbiasangle = 0.0

lookupdown    = 0.0

xpos          = 0.0
zpos          = 0.0

yrot          = 0.0

LightAmbient  = [0.5, 0.5, 0.5, 1.0]
LightDiffuse  = [1.0, 1.0, 1.0, 1.0]
LightPosition = [0.0, 0.0, 2.0, 1.0]

filter        = 1
light         = true
blend         = true

x_m           = 0.0
y_m           = 0.0
z_m           = 0.0
u_m           = 0.0
v_m           = 0.0
xtrans        = 0.0
ytrans        = 0.0
ztrans        = 0.0
sceneroty     = 0.0

# initialize sector1 with SetupWorld

sector1 = SetupWorld("world.txt")

# load textures from images

tex = Array(Uint8,3) # generating 3 textures
img = imread("mud.bmp")
glgentextures(3,tex)

glbindtexture(GL_TEXTURE_2D,tex[1])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
glteximage2d(GL_TEXTURE_2D, 0, 3, size(img,1), size(img,2), 0, GL_RGB, GL_UNSIGNED_BYTE, img)

glbindtexture(GL_TEXTURE_2D,tex[2])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glteximage2d(GL_TEXTURE_2D, 0, 3, size(img,1), size(img,2), 0, GL_RGB, GL_UNSIGNED_BYTE, img)

glbindtexture(GL_TEXTURE_2D,tex[3])
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
gltexparameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST)
glteximage2d(GL_TEXTURE_2D, 0, 3, size(img,1), size(img,2), 0, GL_RGB, GL_UNSIGNED_BYTE, img)

glubuild2dmipmaps(GL_TEXTURE_2D, 3, size(img,1), size(img,2), GL_RGB, GL_UNSIGNED_BYTE, img)

# initialize lights

gllightfv(GL_LIGHT1, GL_AMBIENT, LightAmbient)
gllightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuse)
gllightfv(GL_LIGHT1, GL_POSITION, LightPosition)

glenable(GL_LIGHT1)

# enable texture mapping and alpha blending

glenable(GL_TEXTURE_2D)
glenable(GL_BLEND)
glblendfunc(GL_SRC_ALPHA, GL_ONE)

# drawing routines

while true
    xtrans = -xpos
    ztrans = -zpos
    ytrans = -walkbias-0.25
    sceneroty = 360.0 - yrot

    glclear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glloadidentity()

    xtrans = -xpos
    ztrans = -zpos
    ytrans = -walkbias-0.25
    sceneroty = 360.0 - yrot

    glrotate(lookupdown, 1.0, 0.0, 0.0)
    glrotate(sceneroty, 0.0, 1.0, 0.0)
    gltranslate(xtrans, ytrans, ztrans)

    if filter == 0
        glbindtexture(GL_TEXTURE_2D,tex[1])
    elseif filter == 1
        glbindtexture(GL_TEXTURE_2D,tex[2])
    elseif filter == 2
        glbindtexture(GL_TEXTURE_2D,tex[3])
    end

    for face = 1:numtriangles
        glbegin(GL_TRIANGLES)
            glnormal(0.0, 0.0, 1.0)
            x_m = sector1[face,1,1]
            y_m = sector1[face,1,2]
            z_m = sector1[face,1,3]
            u_m = sector1[face,1,4]
            v_m = sector1[face,1,5]
            gltexcoord(u_m,v_m) 
            glvertex(x_m,y_m,z_m)

            x_m = sector1[face,2,1]
            y_m = sector1[face,2,2]
            z_m = sector1[face,2,3]
            u_m = sector1[face,2,4]
            v_m = sector1[face,2,5]
            gltexcoord(u_m,v_m) 
            glvertex(x_m,y_m,z_m)

            x_m = sector1[face,3,1]
            y_m = sector1[face,3,2]
            z_m = sector1[face,3,3]
            u_m = sector1[face,3,4]
            v_m = sector1[face,3,5]
            gltexcoord(u_m,v_m)
            glvertex(x_m,y_m,z_m)
        glend()
    end

    sdl_gl_swapbuffers()

    # check key presses
    #while true
        #poll = poll_event()
        #@case poll begin
            #int('q') : return
            #SDL_EVENTS_DONE   : break
        #end

        #println("Blend was: $blend")
        #blend = @case poll begin
            #int('b') : (blend ? false : true)
            #default : blend
        #end
        #println("Blend is now: $blend")
        #if !blend
            #glenable(GL_BLEND)
            #gldisable(GL_DEPTH_TEST)
        #else
            #gldisable(GL_BLEND)
            #glenable(GL_DEPTH_TEST)
        #end

        #println("Light was: $light")
        #light = @case poll begin
            #int('l') : (light ? false : true)
            #default : light
        #end                                      
        #println("Light is now: $light")
        #if !light
            #gldisable(GL_LIGHTING)
        #else
            #glenable(GL_LIGHTING)
        #end

        #println("Filter was: $filter")
        #filter += @case poll begin
            #int('f') : 1
            #default : 0
        #end
        #if filter > 2
            #filter = 0
        #end
        #println("Filter is now: $filter")

        #lookupdown += @case poll begin
            #int('w') : -0.2
            #int('s') : 1.0
            #default : 0.0
        #end

        #xpos += @case poll begin
            #SDLK_UP : -sin(degrees2radians(yrot))*0.05
            #SDLK_DOWN : sin(degrees2radians(yrot))*0.05
            #default : 0.0
        #end

        #zpos += @case poll begin
            #SDLK_UP : -cos(degrees2radians(yrot))*0.05
            #SDLK_DOWN : cos(degrees2radians(yrot))*0.05
            #default : 0.0
        #end

        #walkbiasangle += @case poll begin
            #SDLK_UP : 10
            #SDLK_DOWN : 10
            #default : 0.0
        #end
        #if walkbiasangle <= 1.0
            #walkbiasangle = 359.0
        #elseif walkbiasangle >= 359.0
            #walkbiasangle = 0.0
        #end
        #walkbiasangle = sin(degrees2radians(walkbiasangle))/20.0

        #yrot += @case poll begin
            #SDLK_LEFT : 1.5
            #SDLK_RIGHT : -1.5
            #default : 0.0
        #end
    #end
end

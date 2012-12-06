# Tue 13 Nov 2012 04:13:36 PM EST 
#
# NeHe Tut 8 - Implement lights and rotate an alpha-blended, textured cube


# load necessary GL/SDL routines

load("initGL.jl")
initGL()

### auxiliary functions

function cube(size)  # the cube function now includes surface normal specification for proper lighting
  @with glprimitive(GL_QUADS) begin
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
  end
end

### end of auxiliary functions

# initialize variables

light         = false
blend         = false
filter        = 0

xrot          = 0.0
yrot          = 0.0
xspeed        = 0.0
yspeed        = 0.0

z             = 0.8

cube_size     = 0.2

LightAmbient  = [0.5, 0.5, 0.5, 1.0]
LightDiffuse  = [1.0, 1.0, 1.0, 1.0]
LightPosition = [0.0, 0.0, 2.0, 1.0]

# load textures from images

tex1 = SDLIMGLoad("glass.bmp",1) # nearest filtering
tex2 = SDLIMGLoad("glass.bmp",2) # linear filtering
tex3 = SDLIMGLoad("glass.bmp",3) # mipmap filtering

# initialize lights

gllightfv(GL_LIGHT1, GL_AMBIENT, LightAmbient)
gllightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuse)
gllightfv(GL_LIGHT1, GL_POSITION, LightPosition)

glenable(GL_LIGHT1)

# enable texture mapping

glenable(GL_TEXTURE_2D)

# enable alpha blending for textures

glblendfunc(GL_SRC_ALPHA, GL_ONE)
glcolor(1.0, 1.0, 1.0, 0.5)

# drawing routines

while true

    gltranslate(0.0, 0.0, z)

    glrotate(xrot,1.0,0.0,0.0)
    glrotate(yrot,0.0,1.0,0.0)

    if filter == 0
        glbindtexture(GL_TEXTURE_2D,tex1)
    elseif filter == 1
        glbindtexture(GL_TEXTURE_2D,tex2)
    elseif filter == 2
        glbindtexture(GL_TEXTURE_2D,tex3)
    end
    cube(cube_size)

    xrot +=xspeed
    yrot +=yspeed

    SwapAndClear()

    # check key presses
    while true
        poll = poll_event()
        @case poll begin
            int('q') : return
            SDL_EVENTS_DONE   : break
        end

        println("Blend was: $blend")
        blend = @case poll begin
            int('b') : (blend ? false : true)
            default : blend
        end
        println("Blend is now: $blend")
        if !blend
            glenable(GL_BLEND)
            gldisable(GL_DEPTH_TEST)
        else
            gldisable(GL_BLEND)
            glenable(GL_DEPTH_TEST)
        end

        println("Light was: $light")
        light = @case poll begin
            int('l') : (light ? false : true)
            default : light
        end
        println("Light is now: $light")
        if !light
            gldisable(GL_LIGHTING)
        else
            glenable(GL_LIGHTING)
        end

        println("Filter was: $filter")
        filter += @case poll begin
            int('f') : 1
            default : 0
        end
        if filter > 2
            filter = 0
        end
        println("Filter is now: $filter")

        z += @case poll begin
            SDLK_PAGEUP : -0.02
            SDLK_PAGEDOWN : 0.02
            default : 0.0
        end

        xspeed += @case poll begin
            SDLK_UP : -0.01
            SDLK_DOWN : 0.01
            default : 0.0
        end

        yspeed += @case poll begin
            SDLK_LEFT : -0.01
            SDLK_RIGHT : 0.01
            default : 0.0
        end
    end

end
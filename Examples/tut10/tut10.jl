# Tue 13 Nov 2012 04:13:36 PM EST 
#
# NeHe Tut 10 - Move around in a 3D world


# load necessary GL/SDL routines

load("initGL.jl")
initGL()

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
                sector[loop,vert,:]  = [x,y,z,u,v].*0.25
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

tex1 = SDLIMGLoad("mud.bmp",1)
tex2 = SDLIMGLoad("mud.bmp",2)
tex3 = SDLIMGLoad("mud.bmp",3)

# initialize lights

gllightfv(GL_LIGHT1, GL_AMBIENT, LightAmbient)
gllightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuse)
gllightfv(GL_LIGHT1, GL_POSITION, LightPosition)

glenable(GL_LIGHT1)

# enable texture mapping and alpha blending

glenable({GL_TEXTURE_2D, GL_BLEND})
glblendfunc(GL_SRC_ALPHA, GL_ONE)

# drawing routines

while true

    xtrans = -xpos
    ztrans = -zpos
    ytrans = -walkbias-0.25
    sceneroty = 360.0 - yrot

    glrotate(lookupdown, 1.0, 0.0, 0.0)
    glrotate(sceneroty, 0.0, 1.0, 0.0)
    gltranslate(xtrans, ytrans, ztrans)

    if filter == 0
        glbindtexture(GL_TEXTURE_2D,tex1)
    elseif filter == 1
        glbindtexture(GL_TEXTURE_2D,tex2)
    elseif filter == 2
        glbindtexture(GL_TEXTURE_2D,tex3)
    end

    for face = 1:numtriangles
        @with glprimitive(GL_TRIANGLES) begin
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
        end
    end

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

        lookupdown += @case poll begin
            int('w') : -0.2
            int('s') : 1.0
            default : 0.0
        end

        xpos += @case poll begin
            SDLK_UP : -sin(degrees2radians(yrot))*0.05
            SDLK_DOWN : sin(degrees2radians(yrot))*0.05
            default : 0.0
        end

        zpos += @case poll begin
            SDLK_UP : -cos(degrees2radians(yrot))*0.05
            SDLK_DOWN : cos(degrees2radians(yrot))*0.05
            default : 0.0
        end

        walkbiasangle += @case poll begin
            SDLK_UP : 10
            SDLK_DOWN : 10
            default : 0.0
        end
        if walkbiasangle <= 1.0
            walkbiasangle = 359.0
        elseif walkbiasangle >= 359.0
            walkbiasangle = 0.0
        end
        walkbiasangle = sin(degrees2radians(walkbiasangle))/20.0

        yrot += @case poll begin
            SDLK_LEFT : 1.5
            SDLK_RIGHT : -1.5
            default : 0.0
        end
    end

end

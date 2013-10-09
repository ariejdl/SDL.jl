# Sun 30 Dec 2012 04:11:02 PM EST
#
# NeHe Tut 18 - Make quadrics with GLU commands (builds on tut7)
#
# Q - quit
# L - turn lights on/off
# F - change texture filter (linear, nearest, mipmap)
# PageUp/Down - move camera closer/further away
# Up/Down - increase/decrease x-rotation speed
# Left/Right - increase/decrease y-rotation speed
# Space - change the currently rendered object (cube, cylinder, sphere, tapered cylinder, disc, animated disk)


# load necessary GL/SDL routines

global OpenGLver="1.0"
using OpenGL
using SDL

# initialize variables

bpp                = 16
wintitle           = "NeHe Tut 18"
icontitle          = "NeHe Tut 18"
width              = 640
height             = 480

filter             = 3
light              = true
blend              = false

part1              = 0
part2              = 0
p1                 = 0
p2                 = 1

object             = 0

xrot               = 0.0
yrot               = 0.0
xspeed             = 0.0
yspeed             = 0.0

z                  = -5.0

cube_size          = 1.0

LightAmbient       = [0.5f0, 0.5f0, 0.5f0, 1.0f0]
LightDiffuse       = [1.0f0, 1.0f0, 1.0f0, 1.0f0]
LightPosition      = [0.0f0, 0.0f0, 2.0f0, 1.0f0]

keystate_checked   = false
lastkeycheckTime   = 0
key_repeatinterval = 75 #ms

# open SDL window with an OpenGL context

SDL_Init(SDL_INIT_VIDEO)
#videoInfo = SDL_GetVideoInfo()
videoFlags = (SDL_OPENGL | SDL_GL_DOUBLEBUFFER | SDL_HWPALETTE | SDL_RESIZABLE)
#if videoInfo.hw_available
    videoFlags = (videoFlags | SDL_HWSURFACE)
#else
    #videoFlags = (videoFlags | SDL_SWSURFACE)
#end
#if videoInfo.blit_hw
    videoFlags = (videoFlags | SDL_HWACCEL)
#end
SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1)
SDL_SetVideoMode(width, height, bpp, videoFlags)
SDL_WM_SetCaption(wintitle, icontitle)

glViewport(0, 0, width, height)
glClearColor(0.0, 0.0, 0.0, 0.0)
glClearDepth(1.0)
glDepthFunc(GL_LEQUAL)
glEnable(GL_DEPTH_TEST)
glShadeModel(GL_SMOOTH)
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)

glMatrixMode(GL_PROJECTION)
glLoadIdentity()

gluPerspective(45.0,width/height,0.1,100.0)

glMatrixMode(GL_MODELVIEW)

### auxiliary functions

function cube(size)  # the cube function now includes surface normal specification for proper lighting
  glBegin(GL_QUADS)
    # Front Face
    glNormal(0.0,0.0,1.0)
    glTexCoord(0.0, 0.0)
    glVertex(-size, -size, size)
    glTexCoord(1.0, 0.0)
    glVertex(size, -size, size)
    glTexCoord(1.0, 1.0)
    glVertex(size, size, size)
    glTexCoord(0.0, 1.0)
    glVertex(-size, size, size)

    # Back Face
    glNormal(0.0,0.0,-1.0)
    glTexCoord(1.0, 0.0)
    glVertex(-size, -size, -size)
    glTexCoord(1.0, 1.0)
    glVertex(-size, size, -size)
    glTexCoord(0.0, 1.0)
    glVertex(size, size, -size)
    glTexCoord(0.0, 0.0)
    glVertex(size, -size, -size)

    # Top Face
    glNormal(0.0,1.0,0.0)
    glTexCoord(0.0, 1.0)
    glVertex(-size, size, -size)
    glTexCoord(0.0, 0.0)
    glVertex(-size, size, size)
    glTexCoord(1.0, 0.0)
    glVertex(size, size, size)
    glTexCoord(1.0, 1.0)
    glVertex(size, size, -size)

    # Bottom Face
    glNormal(0.0,-1.0,0.0)
    glTexCoord(1.0, 1.0)
    glVertex(-size, -size, -size)
    glTexCoord(0.0, 1.0)
    glVertex(size, -size, -size)
    glTexCoord(0.0, 0.0)
    glVertex(size, -size, size)
    glTexCoord(1.0, 0.0)
    glVertex(-size, -size, size)

    # Right Face
    glNormal(1.0,0.0,0.0)
    glTexCoord(1.0, 0.0)
    glVertex(size, -size, -size)
    glTexCoord(1.0, 1.0)
    glVertex(size, size, -size)
    glTexCoord(0.0, 1.0)
    glVertex(size, size, size)
    glTexCoord(0.0, 0.0)
    glVertex(size, -size, size)

    # Left Face
    glNormal(-1.0,0.0,0.0)
    glTexCoord(0.0, 0.0)
    glVertex(-size, -size, -size)
    glTexCoord(1.0, 0.0)
    glVertex(-size, -size, size)
    glTexCoord(1.0, 1.0)
    glVertex(-size, size, size)
    glTexCoord(0.0, 1.0)
    glVertex(-size, size, -size)
  glEnd()
end

### end of auxiliary functions

# load textures from images

tex   = Array(Uint32,3) # generating 3 textures

img, w, h = glimread(expanduser("~/.julia/SDL/Examples/NeHe/tut18/crate.bmp"))

glGenTextures(3,tex)
glBindTexture(GL_TEXTURE_2D,tex[1])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

glBindTexture(GL_TEXTURE_2D,tex[2])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

glBindTexture(GL_TEXTURE_2D,tex[3])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_NEAREST)
glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

gluBuild2DMipmaps(GL_TEXTURE_2D, 3, w, h, GL_RGB, GL_UNSIGNED_BYTE, img)

# initialize lights

glLightfv(GL_LIGHT1, GL_AMBIENT, LightAmbient)
glLightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuse)
glLightfv(GL_LIGHT1, GL_POSITION, LightPosition)

glEnable(GL_LIGHT1)
glEnable(GL_LIGHTING)

# enable texture mapping & blending

glEnable(GL_TEXTURE_2D)
glBlendFunc(GL_SRC_ALPHA, GL_ONE)
glColor(1.0, 1.0, 1.0, 0.5)

# intialize quadric info

quadratic = gluNewQuadric()

gluQuadricNormals(quadratic, GLU_SMOOTH)
gluQuadricTexture(quadratic, GL_TRUE)

# main drawing loop

while true
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()

    glTranslate(0.0,0.0,z)

    glRotate(xrot,1.0,0.0,0.0)
    glRotate(yrot,0.0,1.0,0.0)

    glBindTexture(GL_TEXTURE_2D,tex[filter])

    if object == 0
        cube(cube_size)
    elseif object == 1
        glTranslate(0.0, 0.0, -1.5)
        gluCylinder(quadratic, 1.0, 1.0, 3.0, 32, 32)
    elseif object == 2
        gluDisk(quadratic, 0.5, 1.5, 32, 32)
    elseif object == 3
        gluSphere(quadratic, 1.3, 32, 32)
    elseif object == 4
        glTranslate(0.0, 0.0, -1.5)
        gluCylinder(quadratic, 1.0, 0.2, 3.0, 32, 32)
    elseif object == 5
        part1 +=p1
        part2 +=p2

        if part1 > 359
            p1    = 0
            part1 = 0
            p2    = 1
            part2 = 0
        end

        if part2 > 359
            p1 = 1
            p2 = 0
        end
        gluPartialDisk(quadratic,0.5,1.5,32,32,part1,part2-part1)
    end

    xrot +=xspeed
    yrot +=yspeed

    SDL_GL_SwapBuffers()

    SDL_PumpEvents()
    if SDL_GetTicks() - lastkeycheckTime >= key_repeatinterval
        keystate         = SDL_GetKeyState()
        keystate_checked = true
        lastkeycheckTime = SDL_GetTicks()
    end

    # Sampling rates for event processing are so fast that a single key press
    # lasts through several iterations of this loop.  This means that one press
    # can be seen as 50 or more presses by the SDL event system.  To correct
    # for this, we only check keypresses every 75ms.

    if keystate_checked == true
        if keystate[SDLK_q] == true
            break
        elseif keystate[SDLK_SPACE] == true
            object +=1
            if object > 5
                object = 0
            end
        elseif keystate[SDLK_b] == true
            println("Blend was: $blend")
            blend = (blend ? false : true)
            if blend
                glEnable(GL_BLEND)
                glDisable(GL_DEPTH_TEST)
            else
                glDisable(GL_BLEND)
                glEnable(GL_DEPTH_TEST)
            end
            println("Blend is now: $blend")
        elseif keystate[SDLK_l] == true
            println("Light was: $light")
            light = (light ? false : true)
            println("Light is now: $light")
            if light
                glEnable(GL_LIGHTING)
            else
                glDisable(GL_LIGHTING)
            end
        elseif keystate[SDLK_f] == true
            println("Filter was: $filter")
            filter += 1
            if filter > 3
                filter = 1
            end
            println("Filter is now: $filter")
        elseif keystate[SDLK_PAGEUP] == true
            z -= 0.02
        elseif keystate[SDLK_PAGEDOWN] == true
            z += 0.02
        elseif keystate[SDLK_UP] == true
            xspeed -= 0.01
        elseif keystate[SDLK_DOWN] == true
            xspeed += 0.01
        elseif keystate[SDLK_LEFT] == true
            yspeed -= 0.01
        elseif keystate[SDLK_RIGHT] == true
            yspeed += 0.01
        end
        keystate_checked = false
    end
end

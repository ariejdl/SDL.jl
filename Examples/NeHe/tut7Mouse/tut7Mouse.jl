# Thu 08 Nov 2012 05:07:44 PM EST
#
# NeHe Tut 7 Mouse - Implement lights and rotate a textured cube with the mouse
#
# Q - quit
# L - turn lights on/off
# F - change texture filter (linear, nearest, mipmap)
# Hold left mouse button and move mouse up/down or /left/right - increase/decrease x-rotation speed or y-rotation speed
# Hold middle mouse button and move mouse up/down - move camera closer/further away from cube


# load necessary GL/SDL routines

global OpenGLver="1.0"
using OpenGL
using SDL

# initialize variables

bpp                = 16
wintitle           = "NeHe Tut 7"
icontitle          = "NeHe Tut 7"
width              = 640
height             = 480

filter             = 3
light              = true

xrot               = 0.0
yrot               = 0.0
xspeed             = 0.0
yspeed             = 0.0
x_thresh           = 1
y_thresh           = 1

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
glDepthFunc(GL_LESS)
glEnable(GL_DEPTH_TEST)
glShadeModel(GL_SMOOTH)

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

img, w, h = glimread(expanduser("~/.julia/SDL/Examples/NeHe/tut7/crate.bmp")) # see OpenGLAux.jl for description

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

# enable texture mapping

glEnable(GL_TEXTURE_2D)

# main drawing loop

while true
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()

    glTranslate(0.0,0.0,z)

    glRotate(xrot,1.0,0.0,0.0)
    glRotate(yrot,0.0,1.0,0.0)

    glBindTexture(GL_TEXTURE_2D,tex[filter])
    cube(cube_size)

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
        end
        keystate_checked = false
    end

    (mouse_x, mouse_y, button) = SDL_GetMouseState()
    println("Mouse moved at ($mouse_x, $mouse_y).")

    if button == SDL_BUTTON_LEFT
        println("Left button pressed at ($mouse_x, $mouse_y).")
        if (mouse_x - prev_x) > x_thresh
            yspeed -= 0.01
        elseif (mouse_x - prev_x) < -x_thresh
            yspeed += 0.01
        end

        if (mouse_y - prev_y) > y_thresh
            xspeed -= 0.01
        elseif (mouse_y - prev_y) < -y_thresh
            xspeed += 0.01
        end
    elseif button == SDL_BUTTON_MIDDLE
        println("Middle button pressed at ($mouse_x, $mouse_y).")
        if (mouse_y - prev_y) > y_thresh
            z -= 0.02
        elseif (mouse_y - prev_y) < -y_thresh
            z += 0.02
        end
    elseif button == SDL_BUTTON_RIGHT
        println("Right button pressed at ($mouse_x, $mouse_y).")
    end

    prev_y = mouse_y
    prev_x = mouse_x

    (rel_mouse_x, rel_mouse_y, rel_button) = SDL_GetRelativeMouseState()
    println("Mouse moved (relative) at ($rel_mouse_x, $rel_mouse_y).")
end

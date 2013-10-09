# Sun 30 Dec 2012 09:44:00 PM EST
#
# NeHe Tut 19 - Particle engine (triangle strips)
#
# Q - quit
# L - turn lights on/off
# F - change texture filter (linear, nearest, mipmap)
# PageUp/Down - move camera closer/further away
# Up/Down - increase/decrease x-rotation speed
# Left/Right - increase/decrease y-rotation speed
# Home/End - increase/decrease the amount of "friction" on particles
# Enter - turn rainbow effect on/off
# Space - step through colors for rainbow effect


# load necessary GL/SDL routines

global OpenGLver="1.0"
using OpenGL
using SDL

# initialize variables

bpp       = 16
wintitle  = "NeHe Tut 19"
icontitle = "NeHe Tut 19"
width     = 640
height    = 480

colors = [1.0  0.5  0.5;
          1.0  0.75 0.5;
          1.0  1.0  0.5;
          0.75 1.0  0.5;
          0.5  1.0  0.5;
          0.5  1.0  0.75;
          0.5  1.0  1.0;
          0.5  0.75 1.0;
          0.5  0.5  1.0;
          0.75 0.5  1.0;
          1.0  0.5  1.0;
          1.0  0.5  0.75]

rainbow       = true
slowdown      = 2.0
xspeed        = 0
yspeed        = 0
zoom          = -40.0
color         = 1
delay         = 0

MAX_PARTICLES = 1000

type particle
    active::Bool
    life::Float64
    fade::Float64
    red::Float64
    green::Float64
    blue::Float64
    xPos::Float64
    yPos::Float64
    zPos::Float64
    xSpeed::Float64
    ySpeed::Float64
    zSpeed::Float64
    xGrav::Float64
    yGrav::Float64
    zGrav::Float64
end

particles = [particle(true,                   # Julia doesn't like it when you try to initialize an empty array of
                      1.0,                    # a composite type and try to fill it afterwards, so we
                      rand(1:100)/1000+0.003,  # start with a 1-element vector and tack on values
                      colors[1,1],
                      colors[1,2],
                      colors[1,3],
                      0.0,
                      0.0,
                      0.0,
                      (rand(1:50)-26.0)*10.0,
                      (rand(1:50)-26.0)*10.0,
                      (rand(1:50)-26.0)*10.0,
                      0.0,
                      -0.8,
                      0.0)]

for loop = 2:MAX_PARTICLES
    active = true
    life   = 1.0
    fade   = rand(1:100)/1000+0.003
    red    = colors[loop%size(colors,1)+1,1]
    green  = colors[loop%size(colors,1)+1,2]
    blue   = colors[loop%size(colors,1)+1,3]
    xPos   = 0.0
    yPos   = 0.0
    zPos   = 0.0
    xSpeed = (rand(1:50)-26.0)*10.0
    ySpeed = (rand(1:50)-26.0)*10.0
    zSpeed = (rand(1:50)-26.0)*10.0
    xGrav  = 0.0
    yGrav  = -0.8
    zGrav  = 0.0
    particles = push!(particles, particle(active,life,fade,red,green,blue,xPos,yPos,zPos,xSpeed,ySpeed,zSpeed,xGrav,yGrav,zGrav))
end

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
glDisable(GL_DEPTH_TEST)
glShadeModel(GL_SMOOTH)
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST)
glHint(GL_POINT_SMOOTH_HINT, GL_NICEST)

glMatrixMode(GL_PROJECTION)
glLoadIdentity()

gluPerspective(45.0,width/height,0.1,200.0)

glMatrixMode(GL_MODELVIEW)

# load textures from images

tex   = Array(Uint32,1) # generating 1 texture

img, w, h = glimread(expanduser("~/.julia/SDL/Examples/NeHe/tut19/Particle.bmp"))

glGenTextures(1,tex)
glBindTexture(GL_TEXTURE_2D,tex[1])
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
glTexImage2D(GL_TEXTURE_2D, 0, 3, w, h, 0, GL_RGB, GL_UNSIGNED_BYTE, img)

# enable texture mapping & blending

glEnable(GL_TEXTURE_2D)
glEnable(GL_BLEND)
glBlendFunc(GL_SRC_ALPHA, GL_ONE)
glColor(1.0, 1.0, 1.0, 0.5)

glBindTexture(GL_TEXTURE_2D,tex[1])

# main drawing loop

while true
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glLoadIdentity()

    for loop = 1:MAX_PARTICLES
        if particles[loop].active
            x = particles[loop].xPos
            y = particles[loop].yPos
            z = particles[loop].zPos+zoom
            glColor(particles[loop].red, particles[loop].green, particles[loop].blue, particles[loop].life)
            glBegin(GL_TRIANGLE_STRIP)
                glTexCoord(1, 1)
                glVertex(x+0.5, y+0.5, z)
                glTexCoord(0, 1)
                glVertex(x-0.5, y+0.5, z)
                glTexCoord(1, 0)
                glVertex(x+0.5, y-0.5, z)
                glTexCoord(0, 0)
                glVertex(x-0.5, y-0.5, z)
            glEnd()
            particles[loop].xPos   += particles[loop].xSpeed/(slowdown*1000)
            particles[loop].yPos   += particles[loop].ySpeed/(slowdown*1000)
            particles[loop].zPos   += particles[loop].zSpeed/(slowdown*1000)
            particles[loop].xSpeed += particles[loop].xGrav
            particles[loop].ySpeed += particles[loop].yGrav
            particles[loop].zSpeed += particles[loop].zGrav
            particles[loop].life   -= particles[loop].fade
            if particles[loop].life < 0.0
                particles[loop].life   = 1.0
                particles[loop].fade   = (rand(1:100))/1000+0.003
                particles[loop].xPos   = 0.0
                particles[loop].yPos   = 0.0
                particles[loop].zPos   = 0.0
                particles[loop].xSpeed = xspeed+rand(1:60)-32.0
                particles[loop].ySpeed = yspeed+rand(1:60)-30.0
                particles[loop].zSpeed = rand(1:60)-30.0
                particles[loop].red    = colors[color,1]
                particles[loop].green  = colors[color,2]
                particles[loop].blue   = colors[color,3]
            end
            if saved_keystate == true
                if keystate[SDLK_8] == true && particles[loop].yGrav < 1.5
                    particles[loop].yGrav +=0.01
                elseif keystate[SDLK_2] == true && particles[loop].yGrav > -1.5
                    particles[loop].yGrav -=0.01
                elseif keystate[SDLK_4] == true && particles[loop].xGrav < 1.5
                    particles[loop].xGrav +=0.01
                elseif keystate[SDLK_6] == true && particles[loop].xGrav > -1.5
                    particles[loop].xGrav -=0.01
                elseif keystate[SDLK_TAB] == true
                    particles[loop].xPos   = 0.0
                    particles[loop].yPos   = 0.0
                    particles[loop].zPos   = 0.0
                    particles[loop].xSpeed = (rand(1:52)-26.0)*10
                    particles[loop].ySpeed = (rand(1:50)-25.0)*10
                    particles[loop].zSpeed = (rand(1:50)-25.0)*10
                end
            end
        end
    end

    delay +=1

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
        elseif keystate[SDLK_HOME] == true
            slowdown -=0.01
        elseif keystate[SDLK_END] == true
            slowdown +=0.01
        elseif keystate[SDLK_PAGEUP] == true
            zoom +=0.1
        elseif keystate[SDLK_PAGEDOWN] == true
            zoom -=0.1
        elseif keystate[SDLK_UP] == true
            yspeed +=1.0
        elseif keystate[SDLK_DOWN] == true
            yspeed -=1.0
        elseif keystate[SDLK_LEFT] == true
            xspeed +=1.0
        elseif keystate[SDLK_RIGHT] == true
            xspeed -=1.0
        elseif keystate[SDLK_RETURN] == true
            rainbow = (rainbow ? false : true)
        elseif keystate[SDLK_SPACE] == true || (rainbow && delay > 25)
            delay = 0
            color +=1
            if color > 12
                color = 1
            end
        end
        keystate_checked = false
    end
end

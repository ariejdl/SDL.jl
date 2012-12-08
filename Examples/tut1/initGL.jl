require("SDL")
using SDL

function initSDL(w,h,wintitle,icontitle)
    sdl_init(SDL_INIT_VIDEO)
    sdl_setvideomode(w, h, 0, SDL_OPENGL)
    sdl_WM_setcaption(wintitle, C_NULL)
end

function initGL(w,h,wintitle,icontitle)
  initSDL(w,h,wintitle,icontitle) # don't remove this. it opens a window and sets up an SDL context
  glviewport(0, 0, w, h)
  glclearcolor(0.0, 0.0, 0.0, 0.0)
  glcleardepth(1.0)			 
  gldepthfunc(GL_LESS)	 
  glenable(GL_DEPTH_TEST)
  glshademodel(GL_SMOOTH)

  glmatrixmode(GL_PROJECTION)
  glloadidentity()

  gluperspective(45.0,w/h,0.1,100.0)

  glmatrixmode(GL_MODELVIEW)
  sdl_gl_swapbuffers()
end

initGL() = initGL(640,640,"Blank","Blank")
initGL(w,h) = initGL(w,h,"Blank","Blank")

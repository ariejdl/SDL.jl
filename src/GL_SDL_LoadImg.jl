#  Jasper den Ouden 16-08-2012
# Placed in public domain.

module GL_SDL_LoadImg
#Loading images int GL and/or SDL.

import GetC.@get_c_fun
using  OpenGL

export sdl_free_surface, sdl_load_img, SDLIMGLoad

#----no more module stuff.

sdl_lib = dlopen("libSDL")

#@get_c_fun sdl_lib sdl_free_surface SDL_FreeSurface(ptr::Ptr)::Void
@get_c_fun sdl_lib sdl_free_surface SDL_FreeSurface(ptr::Ptr)::Void

sdl_img_lib = dlopen("libSDL_image")
function IMG_Load(file::String)
  return ccall(dlsym(sdl_img_lib, :IMG_Load), Ptr,(Ptr{Uint8},), 
               bytestring(file))
end

gl_sdl_load_img_lib = dlopen("sdl/gl_sdl_load_img.so")

@get_c_fun gl_sdl_load_img_lib auto gl_sdl_load_img(index::GLuint, 
                                                    surface::Ptr,
                                                    format::GLenum, 
                                                    w::Int32,h::Int32,filter::Int32)::GLuint

function SDLIMGLoad(surf::Ptr, format::Integer, w::Integer,h::Integer, 
                         prepare::Bool,filter::Integer)
  if prepare
    glenable({GL_TEXTURE_2D, GL_BLEND})
  end
  val = ccall(dlsym(gl_sdl_load_img_lib, :gl_sdl_load_img),
              GLuint, (Ptr,GLenum,GLint,GLint,GLint), 
              surf, convert(GLenum, format), w,h,filter)
  if prepare
    gldisable({GL_TEXTURE_2D, GL_BLEND})
  end
  return val
end
#Cant use @get_c_fun due to it not supporting String conversion yet.
function SDLIMGLoad(file::String, format::Integer, w::Integer,h::Integer,
                         prepare::Bool,filter::Integer)
  surf = IMG_Load(file)
  val = SDLIMGLoad(surf, format, w,h, prepare,filter)
  sdl_free_surface(surf)
  return val
end

SDLIMGLoad(img, format::Integer, w::Integer,h::Integer,filter::Integer) = #!
    SDLIMGLoad(img, format, w,h, true,filter)

SDLIMGLoad(img, format::Integer,filter::Integer) = #!
    SDLIMGLoad(img, format, -1,-1, filter)
SDLIMGLoad(img, filter::Integer) = #!
    SDLIMGLoad(img, -1, -1,-1, filter)
SDLIMGLoad(img) = #!
    SDLIMGLoad(img, -1,2)

@get_c_fun gl_sdl_load_img_lib auto sdl_surface_w(surf::Ptr)::Int32
@get_c_fun gl_sdl_load_img_lib auto sdl_surface_h(surf::Ptr)::Int32

# NOTE: DOESN'T WORK
#@get_c_fun gl_sdl_load_img_lib auto combine_w_alpha(surf::Ptr,alpha::Ptr,way::Uint32)::Ptr

end #module GL_SDL_LoadImg

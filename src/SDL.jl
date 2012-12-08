#  Jasper den Ouden 02-08-2012
# Placed in public domain.

require("GetC")

module SDL

import GetC.@get_c_fun
using  OpenGL

export mouse_x,mouse_y, poll_event,flush_events

export SDL_ID_FAILED, SDL_MOUSEMOTION, SDL_MOUSE_LEFT, 
       SDL_MOUSE_RIGHT, SDL_MOUSE_MIDDLE

#non-asci keys.
export SDLK_PAUSE, SDLK_ESCAPE,
       SDLK_KP0, SDLK_KP1, SDLK_KP2, SDLK_KP3, SDLK_KP4, SDLK_KP5, SDLK_KP6,
       SDLK_KP7, SDLK_KP8, SDLK_KP9, 
       SDLK_KP_PERIOD, SDLK_KP_DIVIDE, SDLK_KP_MINUS, SDLK_KP_PLUS, 
       SDLK_KP_ENTER, SDLK_KP_EQUALS, 
       SDLK_UP, SDLK_DOWN, SDLK_RIGHT, SDLK_LEFT,
       SDLK_INSERT, SDLK_HOME, SDLK_END,
       SDLK_PAGEUP, SDLK_PAGEDOWN, 
       SDLK_F1, SDLK_F2, SDLK_F3, SDLK_F4, SDLK_F5, SDLK_F6, SDLK_F7, SDLK_F8,
       SDLK_F9, SDLK_F10, SDLK_F11, SDLK_F12, SDLK_F13, SDLK_F14, SDLK_F15, 
       SDLK_NUMLOCK, SDLK_CAPSLOCK, SDLK_SCROLLOCK, SDLK_RSHIFT, SDLK_LSHIFT,
       SDLK_RCTRL, SDLK_LCTRL, SDLK_RALT, SDLK_LALT, SDLK_RMETA, SDLK_LMETA, 
       SDLK_LSUPER, SDLK_RSUPER, SDLK_MODE, SDLK_HELP, SDLK_PRINT, 
       SDLK_SYSREQ, SDLK_BREAK, SDLK_MENU, SDLK_POWER, SDLK_EURO, SDL_QUIT, 
       SDL_VIDEORESIZE, SDL_VIDEOEXPOSE, SDL_SYSWMEVENT, SDL_EVENTS_DONE

export sdl_free_surface, IMG_Load, poll_event, mouse_x(), mouse_y()

sdl = dlopen("libSDL")

abstract SDL

type SDL_Rect <: SDL
    x::Int16
    y::Int16
    w::Uint16
    h::Uint16
end

type SDL_Color <: SDL
    r::Uint8
    g::Uint8
    b::Uint8
    unused::Uint8
end

type SDL_Palette <: SDL
    ncolors::Int32
    colors::SDL_Color
end

type SDL_PixelFormat <: SDL
    palette::SDL_Palette
    BitsPerPixel::Uint8
    BytesPerPixel::Uint8
    Rloss::Uint8
    Gloss::Uint8
    Bloss::Uint8
    Aloss::Uint8
    Rshift::Uint8
    Gshift::Uint8
    Bshift::Uint8
    Ashift::Uint8
    Rmask::Uint32
    Gmask::Uint32
    Bmask::Uint32
    Amask::Uint32
    colorkey::Uint32
    alpha::Uint8
end

type private_hwdata <: SDL

end

type SDL_BlitMap <: SDL

end

type SDL_Surface <: SDL
    flags::Uint32
    format::SDL_PixelFormat
    w::Int32
    h::Int32
    pitch::Uint16
    pixels::Array(Uint8,w,h)
    offset::Int32
    hwdata::private_hwdata
    clip_rect::SDL_Rect
    unused1::Uint32
    locked::Uint32
    map::SDL_BlitMap
    format_version::Uint32
    refcount::Int32
end

typedef struct SDL_ActiveEvent {
	Uint8 type;	/**< SDL_ACTIVEEVENT */
	Uint8 gain;	/**< Whether given states were gained or lost (1/0) */
	Uint8 state;	/**< A mask of the focus states */
} SDL_ActiveEvent;

/** Keyboard event structure */
typedef struct SDL_KeyboardEvent {
	Uint8 type;	/**< SDL_KEYDOWN or SDL_KEYUP */
	Uint8 which;	/**< The keyboard device index */
	Uint8 state;	/**< SDL_PRESSED or SDL_RELEASED */
	SDL_keysym keysym;
} SDL_KeyboardEvent;

/** Mouse motion event structure */
typedef struct SDL_MouseMotionEvent {
	Uint8 type;	/**< SDL_MOUSEMOTION */
	Uint8 which;	/**< The mouse device index */
	Uint8 state;	/**< The current button state */
	Uint16 x, y;	/**< The X/Y coordinates of the mouse */
	Sint16 xrel;	/**< The relative motion in the X direction */
	Sint16 yrel;	/**< The relative motion in the Y direction */
} SDL_MouseMotionEvent;

/** Mouse button event structure */
typedef struct SDL_MouseButtonEvent {
	Uint8 type;	/**< SDL_MOUSEBUTTONDOWN or SDL_MOUSEBUTTONUP */
	Uint8 which;	/**< The mouse device index */
	Uint8 button;	/**< The mouse button index */
	Uint8 state;	/**< SDL_PRESSED or SDL_RELEASED */
	Uint16 x, y;	/**< The X/Y coordinates of the mouse at press time */
} SDL_MouseButtonEvent;

/** Joystick axis motion event structure */
typedef struct SDL_JoyAxisEvent {
	Uint8 type;	/**< SDL_JOYAXISMOTION */
	Uint8 which;	/**< The joystick device index */
	Uint8 axis;	/**< The joystick axis index */
	Sint16 value;	/**< The axis value (range: -32768 to 32767) */
} SDL_JoyAxisEvent;

/** Joystick trackball motion event structure */
typedef struct SDL_JoyBallEvent {
	Uint8 type;	/**< SDL_JOYBALLMOTION */
	Uint8 which;	/**< The joystick device index */
	Uint8 ball;	/**< The joystick trackball index */
	Sint16 xrel;	/**< The relative motion in the X direction */
	Sint16 yrel;	/**< The relative motion in the Y direction */
} SDL_JoyBallEvent;

/** Joystick hat position change event structure */
typedef struct SDL_JoyHatEvent {
	Uint8 type;	/**< SDL_JOYHATMOTION */
	Uint8 which;	/**< The joystick device index */
	Uint8 hat;	/**< The joystick hat index */
	Uint8 value;	/**< The hat position value:
			 *   SDL_HAT_LEFTUP   SDL_HAT_UP       SDL_HAT_RIGHTUP
			 *   SDL_HAT_LEFT     SDL_HAT_CENTERED SDL_HAT_RIGHT
			 *   SDL_HAT_LEFTDOWN SDL_HAT_DOWN     SDL_HAT_RIGHTDOWN
			 *  Note that zero means the POV is centered.
			 */
} SDL_JoyHatEvent;

/** Joystick button event structure */
typedef struct SDL_JoyButtonEvent {
	Uint8 type;	/**< SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP */
	Uint8 which;	/**< The joystick device index */
	Uint8 button;	/**< The joystick button index */
	Uint8 state;	/**< SDL_PRESSED or SDL_RELEASED */
} SDL_JoyButtonEvent;

/** The "window resized" event
 *  When you get this event, you are responsible for setting a new video
 *  mode with the new width and height.
 */
typedef struct SDL_ResizeEvent {
	Uint8 type;	/**< SDL_VIDEORESIZE */
	int w;		/**< New width */
	int h;		/**< New height */
} SDL_ResizeEvent;

/** The "screen redraw" event */
typedef struct SDL_ExposeEvent {
	Uint8 type;	/**< SDL_VIDEOEXPOSE */
} SDL_ExposeEvent;

/** The "quit requested" event */
typedef struct SDL_QuitEvent {
	Uint8 type;	/**< SDL_QUIT */
} SDL_QuitEvent;

type SDL_UserEvent <: SDL
	etype::Uint8	/**< SDL_USEREVENT through SDL_NUMEVENTS-1 */
	code::Uint32	/**< User defined event code */
	data1::Ptr	/**< User defined data pointer */
	data2::Ptr	/**< User defined data pointer */
end

type SDL_SysWMEvent <: SDL
	etype::Uint8
	msg::SDL_SysWMmsg
end

type SDL_Event <: SDL
    etype::Uint8
    active::SDL_ActiveEvent
    key::SDL_KeyboardEvent
    motion::SDL_MouseMotionEvent
    button::SDL_MouseButtonEvent
    jaxis::SDL_JoyAxisEvent
    jball::SDL_JoyBallEvent
    jhat::SDL_JoyHatEvent
    jbutton::SDL_JoyButtonEvent
    resize::SDL_ResizeEvent
    expose::SDL_ExposeEvent
    quit::SDL_QuitEvent
    user::SDL_UserEvent
    syswm::SDL_SysWMEvent
end

@get_c_fun sdl sdl_free_surface SDL_FreeSurface(ptr::Ptr)::Void
@get_c_fun sdl sdl_gl_swapbuffers SDL_GL_SwapBuffers()::Void
@get_c_fun sdl sdl_init SDL_Init()::Int32
@get_c_fun sdl sdl_setvideomode SDL_SetVideoMode(width::Int32,height::Int32,bpp::Int32,flags::Uint32)::SDL_Surface
@get_c_fun sdl sdl_wm_setcaption SDL_WM_SetCaption(title::Ptr{Uint8},icon::Ptr{Uint8})::Int32
@get_c_fun sdl sdl_pollevent SDL_PollEvent(event::SDL_Event)::Int32

sdl_img = dlopen("libSDL_image")

function IMG_Load(file::String)
  return ccall(dlsym(sdl_img_lib, :IMG_Load), Ptr,(Ptr{Uint8},), bytestring(file))
end

function flush_events(quit_exit_p::Bool)
    while true
        pol = poll_event()
        if pol == SDL_EVENTS_DONE
            return
        end
        if pol == SDL_QUIT && quit_exit_p
            exit()
        end
    end
end
flush_events() = flush_events(true)

const SDL_SWSURFACE     = 0x00000000
const SDL_HWSURFACE     = 0x00000001
const SDL_ASYNCBLIT     = 0x00000004
const SDL_ANYFORMAT     = 0x10000000
const SDL_HWPALETTE     = 0x20000000
const SDL_DOUBLEBUF     = 0x40000000
const SDL_FULLSCREEN    = 0x80000000
const SDL_OPENGL        = 0x00000002
const SDL_OPENGLBLIT    = 0x0000000A
const SDL_RESIZABLE     = 0x00000010
const SDL_NOFRAME       = 0x00000020
const SDL_HWACCEL       = 0x00000100
const SDL_SRCCOLORKEY   = 0x00001000
const SDL_RLEACCELOK    = 0x00002000
const SDL_RLEACCEL      = 0x00004000
const SDL_SRCALPHA      = 0x00010000
const SDL_PREALLOC      = 0x01000000
const SDL_ID_FAILED     = 1024
const SDL_MOUSEMOTION   = 1028
const SDL_BUTTON_LEFT   = 1025
const SDL_BUTTON_RIGHT  = 1026
const SDL_BUTTON_MIDDLE = 1027
const SDLK_PAUSE        = 1029
const SDLK_ESCAPE       = 1040
const SDLK_KP0          = 1030
const SDLK_KP1          = 1031
const SDLK_KP2          = 1032
const SDLK_KP3          = 1033
const SDLK_KP4          = 1034
const SDLK_KP5          = 1035
const SDLK_KP6          = 1036
const SDLK_KP7          = 1037
const SDLK_KP8          = 1038;
const SDLK_KP9          = 1039
const SDLK_KP_PERIOD    = 1041
const SDLK_KP_DIVIDE    = 1042
const SDLK_KP_MINUS     = 1043
const SDLK_KP_PLUS      = 1044;
const SDLK_KP_ENTER     = 1045
const SDLK_KP_EQUALS    = 1046
const SDLK_UP           = 1047
const SDLK_DOWN         = 1048
const SDLK_RIGHT        = 1049
const SDLK_LEFT         = 1050
const SDLK_INSERT       = 1051
const SDLK_HOME         = 1052
const SDLK_END          = 1053
const SDLK_PAGEUP       = 1054
const SDLK_PAGEDOWN     = 1055
const SDLK_F1           = 1056
const SDLK_F2           = 1057
const SDLK_F3           = 1058
const SDLK_F4           = 1059
const SDLK_F5           = 1060
const SDLK_F6           = 1061
const SDLK_F7           = 1062
const SDLK_F8           = 1063
const SDLK_F9           = 1064
const SDLK_F10          = 1065
const SDLK_F11          = 1066
const SDLK_F12          = 1067
const SDLK_F13          = 1068
const SDLK_F14          = 1069
const SDLK_F15          = 1070
const SDLK_NUMLOCK      = 1071
const SDLK_CAPSLOCK     = 1072
const SDLK_SCROLLOCK    = 1073
const SDLK_RSHIFT       = 1074
const SDLK_LSHIFT       = 1075
const SDLK_RCTRL        = 1076
const SDLK_LCTRL        = 1077
const SDLK_RALT         = 1078
const SDLK_LALT         = 1079
const SDLK_RMETA        = 1080
const SDLK_LMETA        = 1081
const SDLK_LSUPER       = 1082
const SDLK_RSUPER       = 1083
const SDLK_MODE         = 1084
const SDLK_HELP         = 1085
const SDLK_PRINT        = 1086
const SDLK_SYSREQ       = 1087
const SDLK_BREAK        = 1088
const SDLK_MENU         = 1089
const SDLK_POWER        = 1090
const SDLK_EURO         = 1091
const SDL_QUIT          = 1100
const SDL_VIDEORESIZE   = 1101
const SDL_VIDEOEXPOSE   = 1102
const SDL_SYSWMEVENT    = 1103
const SDL_EVENTS_DONE   = 0

export SDL_SWSURFACE  
export SDL_HWSURFACE  
export SDL_ASYNCBLIT  
export SDL_ANYFORMAT  
export SDL_HWPALETTE  
export SDL_DOUBLEBUF  
export SDL_FULLSCREEN 
export SDL_OPENGL     
export SDL_OPENGLBLIT 
export SDL_RESIZABLE  
export SDL_NOFRAME    
export SDL_HWACCEL    
export SDL_SRCCOLORKEY
export SDL_RLEACCELOK 
export SDL_RLEACCEL   
export SDL_SRCALPHA   
export SDL_PREALLOC   

end #module SDL

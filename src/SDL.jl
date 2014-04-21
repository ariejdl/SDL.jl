#  Jasper den Ouden 02-08-2012
# Placed in public domain.

module SDL

include("../deps/deps.jl")

import GetC.@getCFun

#TODO: read struct info from SDL_GetVideoInfo into this composite type
#type SDL_VideoInfo 
	#hw_available::Uint32 #:1
	#wm_available::Uint32 #:1
	#UnusedBits1::Uint32  #:6
	#UnusedBits2::Uint32  #:1
	#blit_hw::Uint32      #:1
	#blit_hw_CC::Uint32   #:1
	#blit_hw_A::Uint32    #:1
	#blit_sw::Uint32      #:1
	#blit_sw_CC::Uint32   #:1
	#blit_sw_A::Uint32    #:1
	#blit_fill::Uint32    #:1
	#UnusedBits3::Uint32  #:16
	#video_mem::Uint32
	#vfmt::Ptr{Void}
	#current_w::Int32
	#current_h::Int32
#end

@getCFun libSDL SDL_FreeSurface SDL_FreeSurface(ptr::Ptr{Void})::Void
export SDL_FreeSurface
@getCFun libSDL SDL_GL_SwapBuffers SDL_GL_SwapBuffers()::Void
export SDL_GL_SwapBuffers
@getCFun libSDL SDL_Init SDL_Init(flags::Uint32)::Int32
export SDL_Init
@getCFun libSDL SDL_SetVideoMode SDL_SetVideoMode(width::Int32,height::Int32,bpp::Int32,flags::Uint32)::Ptr{Void}
export SDL_SetVideoMode
@getCFun libSDL SDL_GetVideoInfo SDL_GetVideoInfo()::Ptr{Void}
export SDL_GetVideoInfo
@getCFun libSDL SDL_WM_SetCaption SDL_WM_SetCaption(title::Ptr{Uint8},icon::Ptr{Uint8})::Int32
export SDL_WM_SetCaption
@getCFun libSDL SDL_GL_SetAttribute SDL_GL_SetAttribute(attr::Uint32,value::Int32)::Void
export SDL_GL_SetAttribute
@getCFun libSDL SDL_Quit SDL_Quit()::Void
export SDL_Quit

#TODO: The C function returns a Uint32. While the un-commented code returns an intuitive
#number, I'm not comfortable with specifying an invalid return type. 
#@getCFun libSDL SDL_GetTicks SDL_GetTicks()::Uint32
#export SDL_GetTicks
@getCFun libSDL SDL_GetTicks SDL_GetTicks()::Int32
export SDL_GetTicks

#TODO: read up on the event system in SDL
#type SDL_Event
    #etype::Uint8
    #active::Ptr{Void}
    #key::Ptr{Void}
    #motion::Ptr{Void}
    #button::Ptr{Void}
    #jaxis::Ptr{Void}
    #jball::Ptr{Void}
    #jhat::Ptr{Void}
    #jbutton::Ptr{Void}
    #resize::Ptr{Void}
    #expose::Ptr{Void}
    #quit::Ptr{Void}
    #user::Ptr{Void}
    #syswm::Ptr{Void}
#end
#export SDL_Event

#function SDL_PollEvent(Event::SDL_Event)
    #iostr = IOString()
    #pack(iostr, Event)
    #errnum = ccall((:SDL_PollEvent, libSDL), Int32, (Ptr{Void},), iostr.data)
    #Event2 = unpack(iostr, Event)
    #return Event.etype
#end
#export SDL_PollEvent

@getCFun libSDL SDL_PumpEvents SDL_PumpEvents()::Void
export SDL_PumpEvents
@getCFun libSDL SDL_EnableKeyRepeat SDL_EnableKeyRepeat(delay::Int32,interval::Int32)::Int32
export SDL_EnableKeyRepeat

function SDL_GetKeyState()
    numkeys = Array(Int32,1)
    keystate = ccall((:SDL_GetKeyState, libSDL), Ptr{Uint8}, (Ptr{Int32}, ), numkeys)
    keystate = bool(pointer_to_array(keystate, (int(1),int(numkeys[1]))))
    return keystate[2:end] #TODO: find a better way to solve the off-by-one indexing issue
end
export SDL_GetKeyState

function SDL_GetMouseState()
    x = Array(Int32,1)
    y = Array(Int32,1)
    button = ccall((:SDL_GetMouseState, libSDL), Uint8, (Ptr{Int32}, Ptr{Int32}), x, y)
    return int(x[1]), int(y[1]), button
end
export SDL_GetMouseState

function SDL_GetRelativeMouseState()
    x = Array(Int32,1)
    y = Array(Int32,1)
    button = ccall((:SDL_GetRelativeMouseState, libSDL), Uint8, (Ptr{Int32}, Ptr{Int32}), x, y)
    return int(x[1]), int(y[1]), button
end
export SDL_GetRelativeMouseState

@getCFun libSDL SDL_JoystickEventState SDL_JoystickEventState(state::Int32)::Int32
export SDL_JoystickEventState
@getCFun libSDL SDL_JoystickOpen SDL_JoystickOpen(index::Int32)::Ptr{Void}
export SDL_JoystickOpen
@getCFun libSDL SDL_JoystickGetButton SDL_JoystickGetButton(joystick::Ptr{Void},button::Int32)::Uint8
export SDL_JoystickGetButton
@getCFun libSDL SDL_JoystickGetAxis SDL_JoystickGetAxis(joystick::Ptr{Void},axis::Int32)::Int16
export SDL_JoystickGetAxis

const SDL_INIT_VIDEO              = 0x00000020
const SDL_SWSURFACE               = 0x00000000
const SDL_HWSURFACE               = 0x00000001
const SDL_ASYNCBLIT               = 0x00000004
const SDL_ANYFORMAT               = 0x10000000
const SDL_HWPALETTE               = 0x20000000
const SDL_DOUBLEBUF               = 0x40000000
const SDL_FULLSCREEN              = 0x80000000
const SDL_OPENGL                  = 0x00000002
const SDL_OPENGLBLIT              = 0x0000000A
const SDL_RESIZABLE               = 0x00000010
const SDL_NOFRAME                 = 0x00000020
const SDL_HWACCEL                 = 0x00000100
const SDL_SRCCOLORKEY             = 0x00001000
const SDL_RLEACCELOK              = 0x00002000
const SDL_RLEACCEL                = 0x00004000
const SDL_SRCALPHA                = 0x00010000
const SDL_PREALLOC                = 0x01000000
const SDL_GL_RED_SIZE             = 1
const SDL_GL_GREEN_SIZE           = 2
const SDL_GL_BLUE_SIZE            = 3
const SDL_GL_ALPHA_SIZE           = 4
const SDL_GL_BUFFER_SIZE          = 5
const SDL_GL_DOUBLEBUFFER         = 6
const SDL_GL_DEPTH_SIZE           = 7
const SDL_GL_STENCIL_SIZE         = 8
const SDL_GL_ACCUM_RED_SIZE       = 9
const SDL_GL_ACCUM_GREEN_SIZE     = 10
const SDL_GL_ACCUM_BLUE_SIZE      = 11
const SDL_GL_ACCUM_ALPHA_SIZE     = 12
const SDL_GL_STEREO               = 13
const SDL_GL_MULTISAMPLEBUFFERS   = 14
const SDL_GL_MULTISAMPLESAMPLES   = 15
const SDL_GL_ACCELERATED_VISUAL   = 16
const SDL_GL_SWAP_CONTROL         = 17
const SDL_NOEVENT                 = 0
const SDL_ACTIVEEVENT             = 1
const SDL_KEYDOWN                 = 2
const SDL_KEYUP                   = 3
const SDL_MOUSEMOTION             = 4
const SDL_MOUSEBUTTONDOWN         = 5
const SDL_MOUSEBUTTONUP           = 6
const SDL_JOYAXISMOTION           = 7
const SDL_JOYBALLMOTION           = 8
const SDL_JOYHATMOTION            = 9
const SDL_JOYBUTTONDOWN           = 10
const SDL_JOYBUTTONUP             = 11
const SDL_QUIT                    = 12
const SDL_SYSWMEVENT              = 13
const SDL_EVENT_RESERVEDA         = 14
const SDL_EVENT_RESERVEDB         = 15
const SDL_VIDEORESIZE             = 16
const SDL_VIDEOEXPOSE             = 17
const SDL_EVENT_RESERVED2         = 18
const SDL_EVENT_RESERVED3         = 19
const SDL_EVENT_RESERVED4         = 20
const SDL_EVENT_RESERVED5         = 21
const SDL_EVENT_RESERVED6         = 22
const SDL_EVENT_RESERVED7         = 23
const SDL_USEREVENT               = 24
const SDL_NUMEVENTS               = 32
const SDL_BUTTON_LEFT             = 1
const SDL_BUTTON_MIDDLE           = 2
const SDL_BUTTON_RIGHT            = 3
const SDLK_UNKNOWN                = 0
const SDLK_FIRST                  = 0
const SDLK_BACKSPACE              = 8
const SDLK_TAB                    = 9
const SDLK_CLEAR                  = 12
const SDLK_RETURN                 = 13
const SDLK_PAUSE                  = 19
const SDLK_ESCAPE                 = 27
const SDLK_SPACE                  = 32
const SDLK_EXCLAIM                = 33
const SDLK_QUOTEDBL               = 34
const SDLK_HASH                   = 35
const SDLK_DOLLAR                 = 36
const SDLK_AMPERSAND              = 38
const SDLK_QUOTE                  = 39
const SDLK_LEFTPAREN              = 40
const SDLK_RIGHTPAREN             = 41
const SDLK_ASTERISK               = 42
const SDLK_PLUS                   = 43
const SDLK_COMMA                  = 44
const SDLK_MINUS                  = 45
const SDLK_PERIOD                 = 46
const SDLK_SLASH                  = 47
const SDLK_0                      = 48
const SDLK_1                      = 49
const SDLK_2                      = 50
const SDLK_3                      = 51
const SDLK_4                      = 52
const SDLK_5                      = 53
const SDLK_6                      = 54
const SDLK_7                      = 55
const SDLK_8                      = 56
const SDLK_9                      = 57
const SDLK_COLON                  = 58
const SDLK_SEMICOLON              = 59
const SDLK_LESS                   = 60
const SDLK_EQUALS                 = 61
const SDLK_GREATER                = 62
const SDLK_QUESTION               = 63
const SDLK_AT                     = 64
const SDLK_LEFTBRACKET            = 91
const SDLK_BACKSLASH              = 92
const SDLK_RIGHTBRACKET           = 93
const SDLK_CARET                  = 94
const SDLK_UNDERSCORE             = 95
const SDLK_BACKQUOTE              = 96
const SDLK_a                      = 97
const SDLK_b                      = 98
const SDLK_c                      = 99
const SDLK_d                      = 100
const SDLK_e                      = 101
const SDLK_f                      = 102
const SDLK_g                      = 103
const SDLK_h                      = 104
const SDLK_i                      = 105
const SDLK_j                      = 106
const SDLK_k                      = 107
const SDLK_l                      = 108
const SDLK_m                      = 109
const SDLK_n                      = 110
const SDLK_o                      = 111
const SDLK_p                      = 112
const SDLK_q                      = 113
const SDLK_r                      = 114
const SDLK_s                      = 115
const SDLK_t                      = 116
const SDLK_u                      = 117
const SDLK_v                      = 118
const SDLK_w                      = 119
const SDLK_x                      = 120
const SDLK_y                      = 121
const SDLK_z                      = 122
const SDLK_DELETE                 = 127
const SDLK_WORLD_0                = 160
const SDLK_WORLD_1                = 161
const SDLK_WORLD_2                = 162
const SDLK_WORLD_3                = 163
const SDLK_WORLD_4                = 164
const SDLK_WORLD_5                = 165
const SDLK_WORLD_6                = 166
const SDLK_WORLD_7                = 167
const SDLK_WORLD_8                = 168
const SDLK_WORLD_9                = 169
const SDLK_WORLD_10               = 170
const SDLK_WORLD_11               = 171
const SDLK_WORLD_12               = 172
const SDLK_WORLD_13               = 173
const SDLK_WORLD_14               = 174
const SDLK_WORLD_15               = 175
const SDLK_WORLD_16               = 176
const SDLK_WORLD_17               = 177
const SDLK_WORLD_18               = 178
const SDLK_WORLD_19               = 179
const SDLK_WORLD_20               = 180
const SDLK_WORLD_21               = 181
const SDLK_WORLD_22               = 182
const SDLK_WORLD_23               = 183
const SDLK_WORLD_24               = 184
const SDLK_WORLD_25               = 185
const SDLK_WORLD_26               = 186
const SDLK_WORLD_27               = 187
const SDLK_WORLD_28               = 188
const SDLK_WORLD_29               = 189
const SDLK_WORLD_30               = 190
const SDLK_WORLD_31               = 191
const SDLK_WORLD_32               = 192
const SDLK_WORLD_33               = 193
const SDLK_WORLD_34               = 194
const SDLK_WORLD_35               = 195
const SDLK_WORLD_36               = 196
const SDLK_WORLD_37               = 197
const SDLK_WORLD_38               = 198
const SDLK_WORLD_39               = 199
const SDLK_WORLD_40               = 200
const SDLK_WORLD_41               = 201
const SDLK_WORLD_42               = 202
const SDLK_WORLD_43               = 203
const SDLK_WORLD_44               = 204
const SDLK_WORLD_45               = 205
const SDLK_WORLD_46               = 206
const SDLK_WORLD_47               = 207
const SDLK_WORLD_48               = 208
const SDLK_WORLD_49               = 209
const SDLK_WORLD_50               = 210
const SDLK_WORLD_51               = 211
const SDLK_WORLD_52               = 212
const SDLK_WORLD_53               = 213
const SDLK_WORLD_54               = 214
const SDLK_WORLD_55               = 215
const SDLK_WORLD_56               = 216
const SDLK_WORLD_57               = 217
const SDLK_WORLD_58               = 218
const SDLK_WORLD_59               = 219
const SDLK_WORLD_60               = 220
const SDLK_WORLD_61               = 221
const SDLK_WORLD_62               = 222
const SDLK_WORLD_63               = 223
const SDLK_WORLD_64               = 224
const SDLK_WORLD_65               = 225
const SDLK_WORLD_66               = 226
const SDLK_WORLD_67               = 227
const SDLK_WORLD_68               = 228
const SDLK_WORLD_69               = 229
const SDLK_WORLD_70               = 230
const SDLK_WORLD_71               = 231
const SDLK_WORLD_72               = 232
const SDLK_WORLD_73               = 233
const SDLK_WORLD_74               = 234
const SDLK_WORLD_75               = 235
const SDLK_WORLD_76               = 236
const SDLK_WORLD_77               = 237
const SDLK_WORLD_78               = 238
const SDLK_WORLD_79               = 239
const SDLK_WORLD_80               = 240
const SDLK_WORLD_81               = 241
const SDLK_WORLD_82               = 242
const SDLK_WORLD_83               = 243
const SDLK_WORLD_84               = 244
const SDLK_WORLD_85               = 245
const SDLK_WORLD_86               = 246
const SDLK_WORLD_87               = 247
const SDLK_WORLD_88               = 248
const SDLK_WORLD_89               = 249
const SDLK_WORLD_90               = 250
const SDLK_WORLD_91               = 251
const SDLK_WORLD_92               = 252
const SDLK_WORLD_93               = 253
const SDLK_WORLD_94               = 254
const SDLK_WORLD_95               = 255
const SDLK_KP0                    = 256
const SDLK_KP1                    = 257
const SDLK_KP2                    = 258
const SDLK_KP3                    = 259
const SDLK_KP4                    = 260
const SDLK_KP5                    = 261
const SDLK_KP6                    = 262
const SDLK_KP7                    = 263
const SDLK_KP8                    = 264
const SDLK_KP9                    = 265
const SDLK_KP_PERIOD              = 266
const SDLK_KP_DIVIDE              = 267
const SDLK_KP_MULTIPLY            = 268
const SDLK_KP_MINUS               = 269
const SDLK_KP_PLUS                = 270
const SDLK_KP_ENTER               = 271
const SDLK_KP_EQUALS              = 272
const SDLK_UP                     = 273
const SDLK_DOWN                   = 274
const SDLK_RIGHT                  = 275
const SDLK_LEFT                   = 276
const SDLK_INSERT                 = 277
const SDLK_HOME                   = 278
const SDLK_END                    = 279
const SDLK_PAGEUP                 = 280
const SDLK_PAGEDOWN               = 281
const SDLK_F1                     = 282
const SDLK_F2                     = 283
const SDLK_F3                     = 284
const SDLK_F4                     = 285
const SDLK_F5                     = 286
const SDLK_F6                     = 287
const SDLK_F7                     = 288
const SDLK_F8                     = 289
const SDLK_F9                     = 290
const SDLK_F10                    = 291
const SDLK_F11                    = 292
const SDLK_F12                    = 293
const SDLK_F13                    = 294
const SDLK_F14                    = 295
const SDLK_F15                    = 296
const SDLK_NUMLOCK                = 300
const SDLK_CAPSLOCK               = 301
const SDLK_SCROLLOCK              = 302
const SDLK_RSHIFT                 = 303
const SDLK_LSHIFT                 = 304
const SDLK_RCTRL                  = 305
const SDLK_LCTRL                  = 306
const SDLK_RALT                   = 307
const SDLK_LALT                   = 308
const SDLK_RMETA                  = 309
const SDLK_LMETA                  = 310
const SDLK_LSUPER                 = 311
const SDLK_RSUPER                 = 312
const SDLK_MODE                   = 313
const SDLK_COMPOSE                = 315
const SDLK_HELP                   = 315
const SDLK_PRINT                  = 316
const SDLK_SYSREQ                 = 317
const SDLK_BREAK                  = 318
const SDLK_MENU                   = 319
const SDLK_POWER                  = 320
const SDLK_EURO                   = 321
const SDLK_UNDO                   = 322
const SDL_DEFAULT_REPEAT_DELAY    = 500
const SDL_DEFAULT_REPEAT_INTERVAL = 30
export SDL_INIT_VIDEO
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
export SDL_GL_RED_SIZE           
export SDL_GL_GREEN_SIZE         
export SDL_GL_BLUE_SIZE          
export SDL_GL_ALPHA_SIZE         
export SDL_GL_BUFFER_SIZE        
export SDL_GL_DOUBLEBUFFER       
export SDL_GL_DEPTH_SIZE         
export SDL_GL_STENCIL_SIZE       
export SDL_GL_ACCUM_RED_SIZE     
export SDL_GL_ACCUM_GREEN_SIZE   
export SDL_GL_ACCUM_BLUE_SIZE    
export SDL_GL_ACCUM_ALPHA_SIZE   
export SDL_GL_STEREO             
export SDL_GL_MULTISAMPLEBUFFERS 
export SDL_GL_MULTISAMPLESAMPLES 
export SDL_GL_ACCELERATED_VISUAL 
export SDL_GL_SWAP_CONTROL       
export SDL_NOEVENT         
export SDL_ACTIVEEVENT     
export SDL_KEYDOWN         
export SDL_KEYUP           
export SDL_MOUSEMOTION     
export SDL_MOUSEBUTTONDOWN 
export SDL_MOUSEBUTTONUP   
export SDL_JOYAXISMOTION   
export SDL_JOYBALLMOTION   
export SDL_JOYHATMOTION    
export SDL_JOYBUTTONDOWN   
export SDL_JOYBUTTONUP     
export SDL_QUIT            
export SDL_SYSWMEVENT      
export SDL_EVENT_RESERVEDA 
export SDL_EVENT_RESERVEDB 
export SDL_VIDEORESIZE     
export SDL_VIDEOEXPOSE     
export SDL_EVENT_RESERVED2 
export SDL_EVENT_RESERVED3 
export SDL_EVENT_RESERVED4 
export SDL_EVENT_RESERVED5 
export SDL_EVENT_RESERVED6 
export SDL_EVENT_RESERVED7 
export SDL_USEREVENT       
export SDL_NUMEVENTS       
export SDL_BUTTON_LEFT  
export SDL_BUTTON_RIGHT 
export SDL_BUTTON_MIDDLE
export SDLK_UNKNOWN      
export SDLK_FIRST        
export SDLK_BACKSPACE    
export SDLK_TAB          
export SDLK_CLEAR        
export SDLK_RETURN       
export SDLK_PAUSE        
export SDLK_ESCAPE       
export SDLK_SPACE        
export SDLK_EXCLAIM      
export SDLK_QUOTEDBL     
export SDLK_HASH         
export SDLK_DOLLAR       
export SDLK_AMPERSAND    
export SDLK_QUOTE        
export SDLK_LEFTPAREN    
export SDLK_RIGHTPAREN   
export SDLK_ASTERISK     
export SDLK_PLUS         
export SDLK_COMMA        
export SDLK_MINUS        
export SDLK_PERIOD       
export SDLK_SLASH        
export SDLK_0            
export SDLK_1            
export SDLK_2            
export SDLK_3            
export SDLK_4            
export SDLK_5            
export SDLK_6            
export SDLK_7            
export SDLK_8            
export SDLK_9            
export SDLK_COLON        
export SDLK_SEMICOLON    
export SDLK_LESS         
export SDLK_EQUALS       
export SDLK_GREATER      
export SDLK_QUESTION     
export SDLK_AT           
export SDLK_LEFTBRACKET  
export SDLK_BACKSLASH    
export SDLK_RIGHTBRACKET 
export SDLK_CARET        
export SDLK_UNDERSCORE   
export SDLK_BACKQUOTE    
export SDLK_a            
export SDLK_b            
export SDLK_c            
export SDLK_d           
export SDLK_e           
export SDLK_f           
export SDLK_g           
export SDLK_h           
export SDLK_i           
export SDLK_j           
export SDLK_k           
export SDLK_l           
export SDLK_m           
export SDLK_n           
export SDLK_o           
export SDLK_p           
export SDLK_q           
export SDLK_r           
export SDLK_s           
export SDLK_t           
export SDLK_u           
export SDLK_v           
export SDLK_w           
export SDLK_x           
export SDLK_y           
export SDLK_z           
export SDLK_DELETE      
export SDLK_WORLD_0     
export SDLK_WORLD_1     
export SDLK_WORLD_2     
export SDLK_WORLD_3     
export SDLK_WORLD_4     
export SDLK_WORLD_5     
export SDLK_WORLD_6     
export SDLK_WORLD_7     
export SDLK_WORLD_8     
export SDLK_WORLD_9     
export SDLK_WORLD_10    
export SDLK_WORLD_11    
export SDLK_WORLD_12    
export SDLK_WORLD_13    
export SDLK_WORLD_14    
export SDLK_WORLD_15    
export SDLK_WORLD_16    
export SDLK_WORLD_17    
export SDLK_WORLD_18    
export SDLK_WORLD_19    
export SDLK_WORLD_20    
export SDLK_WORLD_21    
export SDLK_WORLD_22    
export SDLK_WORLD_23    
export SDLK_WORLD_24    
export SDLK_WORLD_25    
export SDLK_WORLD_26    
export SDLK_WORLD_27    
export SDLK_WORLD_28    
export SDLK_WORLD_29    
export SDLK_WORLD_30    
export SDLK_WORLD_31    
export SDLK_WORLD_32    
export SDLK_WORLD_33    
export SDLK_WORLD_34    
export SDLK_WORLD_35    
export SDLK_WORLD_36    
export SDLK_WORLD_37    
export SDLK_WORLD_38    
export SDLK_WORLD_39    
export SDLK_WORLD_40    
export SDLK_WORLD_41    
export SDLK_WORLD_42    
export SDLK_WORLD_43    
export SDLK_WORLD_44    
export SDLK_WORLD_45    
export SDLK_WORLD_46    
export SDLK_WORLD_47    
export SDLK_WORLD_48    
export SDLK_WORLD_49    
export SDLK_WORLD_50    
export SDLK_WORLD_51    
export SDLK_WORLD_52    
export SDLK_WORLD_53    
export SDLK_WORLD_54    
export SDLK_WORLD_55    
export SDLK_WORLD_56    
export SDLK_WORLD_57    
export SDLK_WORLD_58    
export SDLK_WORLD_59    
export SDLK_WORLD_60    
export SDLK_WORLD_61    
export SDLK_WORLD_62    
export SDLK_WORLD_63    
export SDLK_WORLD_64    
export SDLK_WORLD_65    
export SDLK_WORLD_66    
export SDLK_WORLD_67    
export SDLK_WORLD_68    
export SDLK_WORLD_69    
export SDLK_WORLD_70    
export SDLK_WORLD_71    
export SDLK_WORLD_72    
export SDLK_WORLD_73    
export SDLK_WORLD_74    
export SDLK_WORLD_75    
export SDLK_WORLD_76    
export SDLK_WORLD_77    
export SDLK_WORLD_78    
export SDLK_WORLD_79    
export SDLK_WORLD_80    
export SDLK_WORLD_81    
export SDLK_WORLD_82    
export SDLK_WORLD_83    
export SDLK_WORLD_84    
export SDLK_WORLD_85    
export SDLK_WORLD_86    
export SDLK_WORLD_87    
export SDLK_WORLD_88    
export SDLK_WORLD_89    
export SDLK_WORLD_90    
export SDLK_WORLD_91    
export SDLK_WORLD_92    
export SDLK_WORLD_93    
export SDLK_WORLD_94    
export SDLK_WORLD_95    
export SDLK_KP0         
export SDLK_KP1         
export SDLK_KP2         
export SDLK_KP3         
export SDLK_KP4         
export SDLK_KP5         
export SDLK_KP6         
export SDLK_KP7         
export SDLK_KP8         
export SDLK_KP9         
export SDLK_KP_PERIOD   
export SDLK_KP_DIVIDE   
export SDLK_KP_MULTIPLY 
export SDLK_KP_MINUS    
export SDLK_KP_PLUS     
export SDLK_KP_ENTER    
export SDLK_KP_EQUALS   
export SDLK_UP          
export SDLK_DOWN        
export SDLK_RIGHT       
export SDLK_LEFT        
export SDLK_INSERT      
export SDLK_HOME        
export SDLK_END         
export SDLK_PAGEUP      
export SDLK_PAGEDOWN    
export SDLK_F1          
export SDLK_F2          
export SDLK_F3          
export SDLK_F4          
export SDLK_F5          
export SDLK_F6          
export SDLK_F7          
export SDLK_F8          
export SDLK_F9          
export SDLK_F10         
export SDLK_F11         
export SDLK_F12         
export SDLK_F13         
export SDLK_F14         
export SDLK_F15         
export SDLK_NUMLOCK     
export SDLK_CAPSLOCK    
export SDLK_SCROLLOCK   
export SDLK_RSHIFT      
export SDLK_LSHIFT      
export SDLK_RCTRL       
export SDLK_LCTRL       
export SDLK_RALT        
export SDLK_LALT        
export SDLK_RMETA       
export SDLK_LMETA       
export SDLK_LSUPER      
export SDLK_RSUPER      
export SDLK_MODE        
export SDLK_COMPOSE     
export SDLK_HELP        
export SDLK_PRINT       
export SDLK_SYSREQ      
export SDLK_BREAK       
export SDLK_MENU        
export SDLK_POWER       
export SDLK_EURO        
export SDLK_UNDO        
export SDL_DEFAULT_REPEAT_DELAY
export SDL_DEFAULT_REPEAT_INTERVAL

end

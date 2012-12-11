This package is intended to be a fully fledged Julia interface to the SDL
implementation on your machine.

NOTE: Keyboard/mouse routines have not been implemented yet!

Many SDL functions are working, but many (specifically those that process
keyboard and mouse input) are still not fully working.  (You can edit the
method signatures by hand, but it is a painful process.  Jasper's FFI will soon
handle this automatically!)

#TODO

+ Fix performance hiccups
+ FFI the whole library
+ Implement mouse/keyboard routines
+ Find a way to close an SDL instance without quitting the Julia REPL that
	created it

#Usage notes

PLEASE NOTE: When used in a Julia file, all of the function names are written in
lowercase. For example:

C - Julia comparisons

+ SDL_Init -												 sdl_init
+ SDL_GetVideoInfo - 								 sdl_getvideoinfo
+ SDL_GL_SwapBuffers - 							 sdl_gl_swapbuffers

See the "Examples" directory for translations of the first ten NeHe tutorials
into Julia-SDL.

At the moment, this has only been tested on a 2010 Macbook running Linux
(Fedora 17) and a custom built PC desktop running Linux (Fedora 17). Have fun!

#Credit

The VAST majority of work was done by Jasper den Ouden
(https://github.com/o-jasper).  Without his FFI, C header parser, original
examples, and responses to my questions, I would never have been able to put
this into a Julia package.  All credit goes to him.

We'd also like to thank the developers of the free/open-source SDL API
(http://www.libsdl.org). It is a simple, yet powerful, way to develop a
wide-range of multimedia applications and has found it's way into many
operating environments.

Thanks to the Julia team (http://julialang.org) for making Julia, a programming
language that many have been longing for, whether they knew about it or not.
The "Octave-for-C-programmers," as I like to think of it, is an incredibly fast
and powerful programming language that is a welcome breath of fresh air in the
technical and numerical programming communities.

--rennis250 & o-jasper (2012, GPL until further notice)

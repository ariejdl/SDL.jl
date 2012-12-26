This package is intended to be a fully fledged Julia (http://www.julialang.org)
interface to the SDL implementation on your machine.

NOTE: It is recommended that you use the proprietary drivers for your graphics
card.  Open-source drivers produce poor performance and have caused X11 to
crash before. 

Many SDL functions are working, but many are still not fully working. (You can
edit the method signatures by hand, but it is a painful process.  Jasper's FFI
(https://github.com/o-jasper/julia-ffi.git) will soon handle this
automatically!)

#Usage notes

PLEASE NOTE: When used in a Julia file, all of the function names are written in
lowercase. For example:

In C-SDL code, one would write,

```c
SDL_Init
SDL_GetVideoInfo
SDL_GL_SwapBuffers
```

In Julia-SDL code, one would write:

```julia
sdl_init
sdl_getvideoinfo
sdl_gl_swapbuffers
```

See the Examples directory for translations of the first ten NeHe tutorials
into Julia-SDL.

Have fun!

#Credit

The VAST majority of work was done by Jasper den Ouden
(https://github.com/o-jasper).  Without his FFI, C header parser, original
examples, and responses to my questions, I would never have been able to put
this into a Julia package.  All credit goes to him.

We'd also like to thank the developers of the free/open-source SDL API
(http://www.libsdl.org). It is a simple, yet powerful, way to develop a
wide-range of multimedia applications and has found it's way into many
operating environments.

Thanks to NeHe Productions (http://nehe.gamedev.net) for making their excellent
tutorials, which served as a wonderful test-bed for this interface. 

Thanks to the Julia team (http://julialang.org) for making Julia, a programming
language that many have been longing for, whether they knew about it or not.
The "Octave-for-C-programmers," as one could think of it, is an incredibly fast
and powerful programming language that is a welcome breath of fresh air in the
technical and numerical programming communities.

--rennis250 & o-jasper

This package is intended to be a fully fledged
[Julia](http://www.julialang.org) interface to the SDL implementation on your
machine.

Many of the commonly used SDL functions are working, but most of the less
commonly used functions are still not fully working. (You can edit the method
signatures by hand, but it is a painful process.  [Jasper's
FFI](https://github.com/o-jasper/julia-ffi.git) will soon handle this
automatically!)

#Installation

```julia
Pkg.add("SDL")
```

You will also need to install the [SDL libraries](http://www.libsdl.org) for
your system.

On Ubuntu, install the following:

	libsdl-1.2debian
	libsdl-1.2debian-alsa
	libsdl-image1.2
	libsdl-mixer1.2
	libsdl-net1.2

On Fedora, install the following:

	SDL
	SDL_mixer
	SDL_sound
	SDL_image
	SDL_net

While a small subset of the functions from these packages have been
implemented, the hope is to fully implement all of them eventually, so you
might as well install the necessary packages and be prepared for future
updates.  If you're paranoid about having unused packages on your system, then
just install the following for the moment:

Ubuntu:

	libsdl-1.2debian

Fedora:

	SDL

The internet and the SDL website seem to have instructions for Windows and Mac
OS X, which (as always) have a more detailed (and frustrating) install process.
I suppose [Homebrew](http://mxcl.github.com/homebrew/) (the recommended choice
from what I hear) or [MacPorts](https://www.macports.org) will be helpful for
Mac users.

#Usage notes

Press 'q' in any of the NeHe examples to quit.

See the Examples/NeHe directory for translations of sixteen NeHe tutorials into
Julia-SDL.  Controls are listed in the opening comments of each example.  

Mouse and joystick versions of tutorial 7 can be found in the Examples/NeHe
directory.  The joystick version is currently untested.

(At the moment, NeHe tutorial 17 will run, but produces a glicthy output.  I've
yet to figure that out.  It may be a while before I return to it, since fonts
in 3D applications aren't terribly interesting to me.)

To try a NeHe example (e.g. tutorial 2), do

```julia
require("SDL/Examples/NeHe/tut2/tut2.jl")
```

#Loading and using images as OpenGL textures

NOTE: Examples with images will not work, unless you have ImageMagick installed on
your system, since imread depends on it.

1. Load the image using glimread.  This is a wrapper around imread for Tim Holy's Images.jl package.  It parses the Image data returned by imread into a format that OpenGL prefers.
2. Continue with the typical OpenGL image/texture process.
3. See Examples 6 or greater in the Examples/NeHe directory for the relevant
	 code
	 
#SDL Event Processing

Event processing does not follow the conventional C-SDL scheme of calling
SDL_PollEvents() and friends.  The Julia version of this function is still in
the works, since it requires some nimble processing/passing of nested structs.  

To do event processing in Julia-SDL, one must call SDL_PumpEvents() during
every iteration of the main draw loop and, optionally, parse events at given
intervals.

For instance, to do keyboard event processing, use code like the following:

```julia
# main drawing loop

while true

	# drawing routines (clear screen, swap buffers, etc.)

	SDL_PumpEvents()
	if SDL_GetTicks() - lastkeycheckTime >= key_repeatinterval
			keystate         = sdl_GetKeyState()
			keystate_checked = true
			lastkeycheckTime = SDL_GetTicks()
	end
			
	if keystate_checked == true
			if keystate[SDLK_q] == true
					break
			end
			keystate_checked = false
	end

end
```

If you are doing keyboard event processing, then the following variables should
be initialized before the main draw loop starts.

```julia
keystate_checked   = false
lastkeycheckTime   = 0
key_repeatinterval = 75 #ms
```

Set key_repeatintreval to your desired keyboard repeat interval in
milliseconds.  I recommend a repeat interval in the range of 50-80ms, but use
whatever works for your application.

Every one of the SDL NeHe examples has keyboard event processing code, so you
can find more elaborate examples of event processing (including mouse and
joystick processing) there.

#Credit

All of the original, foundational work was done by [Jasper den
Ouden](https://github.com/o-jasper).  He produced the original
Julia-SDL files and wrote the necessary code for integrating them
into the Julia environment.  Without his FFI, C header parser, original
examples, and responses to my questions, I would never have been able to
put this into a Julia package.  All credit goes to him.

Thanks to [Martin
Giesel](http://poseidon.sunyopt.edu/Zaidi/lab_people/bPost%20Docs/giesel/page.html)
for testing all of the Examples.  He found a number of bugs that prevented the
package from running on 32-bits systems and provided some additional
installation instructions for Ubuntu.

Thanks to [Iain Dunning](https://github.com/IainNZ) for suggesting that this be
a pure SDL package, for testing more SDL functions, and for making headway on
Windows. 

Thanks to [NeHe Productions](http://nehe.gamedev.net) for making their
excellent tutorials, which served as a wonderful test-bed for this interface. 

We'd also like to thank the developers of the free/open-source [SDL API
](http://www.libsdl.org). It is a simple, yet powerful, way to develop a
wide-range of multimedia applications and has found it's way into many
operating environments.

Thanks to the [Julia team](http://julialang.org) for making Julia, a
programming language that many have been longing for, whether they knew about
it or not. The "Octave-for-C-programmers," as one could think of it, is an
incredibly fast and powerful programming language that is a welcome breath of
fresh air in the technical and numerical programming communities.

Have fun!
--rennis250 & o-jasper

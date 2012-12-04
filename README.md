This package is intended to be a fully fledged Julia interface to the SDL
implementation on your machine.

The VAST majority of work was done by Jasper den Ouden (@o-jasper).  Without
his FFI, C header parser, original examples, and responses to my questions, I
would never have been able to put this into a Julia package.  All credit goes
to him.

Many SDL functions are working, but many (specifically those that expect
arrays) are still not fully working.  (You can edit the method signatures by
hand, but it is a painful process.  Jasper's FFI will soon handle this
automatically!)

See the "Examples" directory for translations of the first ten NeHe tutorials
into Julia-SDL.

At the moment, this has only been tested on a 2010 Macbook running Linux
(Fedora 17) and a custom built PC desktop running Linux (Fedora 17). Have fun!

--rennis250

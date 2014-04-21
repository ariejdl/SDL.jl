using BinDeps

@BinDeps.setup

libSDL = library_dependency("libSDL", aliases = ["libSDL", "SDL"])
SDLgfx = library_dependency("libSDL_gfx", aliases = ["libSDL_gfx"], depends = [libSDL], os = :Unix)
SDLimage = library_dependency("libSDL_image", aliases = ["libSDL_image"], depends = [libSDL], os = :Unix)
SDLmixer = library_dependency("libSDL_mixer", aliases = ["libSDL_mixer"], depends = [libSDL], os = :Unix)
SDLttf = library_dependency("libSDL_ttf", aliases = ["libSDL_ttf"], depends = [libSDL], os = :Unix)

@windows_only begin
	using WinRPM
	provides(WinRPM.RPM, "libSDL", libSDL, os = :Windows)
end

@osx_only begin
	if Pkg.installed("Homebrew") === nothing
		error("Hombrew package not installed, please run Pkg.add(\"Homebrew\")")
	end
	using Homebrew
	provides(Homebrew.HB, "sdl", libSDL, os = :Darwin)
	provides(Homebrew.HB, "sdl_gfx", SDLgfx, os = :Darwin)
	provides(Homebrew.HB, "sdl_image", SDLimage, os = :Darwin)
	provides(Homebrew.HB, "sdl_mixer", SDLmixer, os = :Darwin)
	provides(Homebrew.HB, "sdl_ttf", SDLttf, os = :Darwin)
end

@linux_only begin
    provides(AptGet,
	    	{"libsdl1.2-dev" => libSDL,
	    	 "libsdl-gfx1.2-dev" => SDLgfx,
	    	 "libsdl-image1.2-dev" => SDLimage,
	    	 "libsdl-mixer1.2-dev" => SDLmixer,
	    	 "libsdl-ttf2.0-dev" => SDLttf})

    provides(Yum,
    		{"SDL-devel" => libSDL,
    		 "SDL_gfx-devel" => SDLgfx,
    		 "SDL_image-devel" => SDLimage,
    		 "SDL_mixer-devel" => SDLmixer,
    		 "SDL_ttf-devel" => SDLttf})
end

@BinDeps.install [:libSDL => :libSDL]

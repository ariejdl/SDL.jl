using BinDeps

@BinDeps.setup

deps = [ libSDL = library_dependency("SDL", aliases = ["libSDL", "SDL"])
	      SDLgfx = library_dependency("SDL_gfx", aliases = ["libSDL_gfx"], depends = [libSDL], os = :Unix)
	      SDLimage = library_dependency("SDL_image", aliases = ["libSDL_image"], depends = [libSDL], os = :Unix)
	      SDLmixer = library_dependency("SDL_mixer", aliases = ["libSDL_mixer"], depends = [libSDL], os = :Unix) 
	      SDLttf = library_dependency("SDL_ttf", aliases = ["libSDL_ttf"], depends = [libSDL], os = :Unix) ]

@windows_only begin
	using WinRPM
	provides(WinRPM.RPM, "SDL", libSDL, os = :Windows)
end

@osx_only begin
	if Pkg.installed("Homebrew") === nothing
		error("Hombrew package not installed, please run Pkg.add(\"Homebrew\")")
	end
	using Homebrew
	provides ( Homebrew.HB, "sdl", libSDL, os = :Darwin )
	provides ( Homebrew.HB, "sdl_gfx", SDLgfx, os = :Darwin )
	provides ( Homebrew.HB, "sdl_image", SDLimage, os = :Darwin )
	provides ( Homebrew.HB, "sdl_mixer", SDLmixer, os = :Darwin )
	provides ( Homebrew.HB, "sdl_ttf", SDLttf, os = :Darwin )
end

provides(AptGet,
		{"libsdl1.2-dev" => libSDL,
		 "libsdl-gfx1.2-dev" => SDLgfx,
		 "libsdl-image1.2-dev" => SDLimage,
		 "libsdl-mixer1.2-dev" => SDLmixer,
		 "libsdl-ttf2.0-dev" => SDLttf})

provides(Yum,
		{"SDL-devel" => libSDL,
		 "SDL_gfx-devel" =>, SDLgfx,
		 "SDL_image-devel" => SDLimage,
		 "SDL_mixer-devel" => SDLmixer,
		 "SDL_ttf-devel" => SDLttf})

@BinDeps.install [:libSDL => :SDL, :SDLgfx => :SDL_gfx, :SDLimage => :SDL_image, :SDLmixer => :SDL_mixer, :SDLttf => :SDL_ttf]
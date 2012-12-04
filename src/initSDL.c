//  Jasper den Ouden 02-08-2012
// Placed in public domain.

#include <stdio.h>
#include <stdlib.h>

#include <GL/gl.h>
#include <SDL/SDL.h>

short screen_bpp = 16;

SDL_Surface *surface;
int videoFlags=0;

int initSDL(int screen_width,int screen_height,char* wintitle, char* icontitle)
{
  //  SDL_Event event;
  const SDL_VideoInfo *videoInfo;
  if ( SDL_Init( SDL_INIT_VIDEO ) < 0 )
    { fprintf( stderr, "Video initialization failed: %s\n",
	       SDL_GetError() ); }
  videoInfo = SDL_GetVideoInfo();
  if ( !videoInfo )
    { fprintf( stderr, "Video query failed: %s\n", SDL_GetError() ); }
  // the flags to pass to SDL_SetVideoMode.
  videoFlags  = SDL_OPENGL          // Enable OpenGL in SDL.
              | SDL_GL_DOUBLEBUFFER // Enable double buffering.
              | SDL_HWPALETTE       // Store the palette in hardware.
              | SDL_RESIZABLE;      // Enable window resizing.
// Check stuff.
  if ( videoInfo->hw_available )
    videoFlags |= SDL_HWSURFACE;
  else
    videoFlags |= SDL_SWSURFACE;
  if ( videoInfo->blit_hw )
    videoFlags |= SDL_HWACCEL;
  SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );
  surface = SDL_SetVideoMode( screen_width, screen_height, screen_bpp,
			      videoFlags );
// Verify there is a surface.
  if ( !surface )
    { fprintf( stderr,  "Video mode set failed: %s\n", SDL_GetError() ); }
}

int SwapAndClear()
{
  SDL_GL_SwapBuffers();
  glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
  glLoadIdentity(); 
}

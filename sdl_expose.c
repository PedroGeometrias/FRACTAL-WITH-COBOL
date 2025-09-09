#define SDL_MAIN_HANDLED
#include <SDL2/SDL.h>
#include <SDL2/SDL_render.h>
#include <stdio.h>
#include <stdlib.h>

// SDL specific init and cleaning
int create_window(SDL_Renderer **renderer, SDL_Window **window, int width, int height){
    if(SDL_InitSubSystem(SDL_INIT_VIDEO)){
        fprintf(stderr,"Error initializing SDL: %s\n", SDL_GetError());
        SDL_Quit();
        return EXIT_FAILURE;
    }
    SDL_Window *wind = SDL_CreateWindow("BURNING SHIP FRACTAL ON COBOL!!!!!!", 
                                        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
                                        width, height, 0);
    if(!wind){
        fprintf(stderr,"Error initializing window: %s\n", SDL_GetError());
        SDL_Quit();
        return EXIT_FAILURE;
    }

    SDL_Renderer *rend = SDL_CreateRenderer(wind, -1, 
                                           SDL_RENDERER_ACCELERATED
                                           ); 

    if(!rend){
        fprintf(stderr,"Error initializing renderer: %s\n", SDL_GetError());
        SDL_DestroyWindow(wind);
        SDL_Quit();
        return EXIT_FAILURE;
    }
    *window = wind; 
    *renderer = rend;
    return EXIT_SUCCESS;
}

void quit_SDL(SDL_Renderer *rend, SDL_Window *window){
    if(rend){
        SDL_DestroyRenderer(rend);
    }
    if(window){
        SDL_DestroyWindow(window);
    }
    SDL_Quit();
}

// drawing
void sdl_set_draw_color_px(SDL_Renderer *ren, int r, int g, int b, int a) {
    SDL_SetRenderDrawColor(ren, r, g, b, a);
}

void sdl_draw_point(SDL_Renderer *ren, int x, int y) {
    SDL_RenderDrawPoint(ren, x, y);
}

void render_clear(SDL_Renderer *rend){
    SDL_RenderClear(rend);
}

void sdl_present(SDL_Renderer *rend){
    SDL_RenderPresent(rend);
}

// control
int sdl_poll_quit(void){
    SDL_Event e;
    while (SDL_PollEvent(&e)) {
        if (e.type == SDL_QUIT) return 1;
        if (e.type == SDL_KEYDOWN && e.key.keysym.sym == SDLK_ESCAPE) return 1;
    }
    return 0;
}

void sdl_delay(void){
    SDL_Delay(16);
}

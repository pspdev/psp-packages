#include <SDL2/SDL.h>
#include <SDL2/SDL_mixer.h>

// Define MIN macro
#define MIN(X, Y) (((X) < (Y)) ? (X) : (Y))

// Define screen dimensions
#define SCREEN_WIDTH    480
#define SCREEN_HEIGHT   272

// audio file path
#define MUSIC_PATH "ms0:/MUSIC/test.ogg" // ogg/mp3 file format

int main(int argc, char **argv) {
    (void)argc;
    (void)argv;

    // Initialize sdl
    SDL_Init(SDL_INIT_VIDEO |
        SDL_INIT_AUDIO |
        SDL_INIT_GAMECONTROLLER
    );

    // Initialize sdl2_mixer
    Mix_OpenAudio(44100, 
        MIX_DEFAULT_FORMAT, 
        MIX_DEFAULT_CHANNELS, 
        2048
    );

    // create window
    SDL_Window *win = SDL_CreateWindow(
        "psp_win",
        SDL_WINDOWPOS_UNDEFINED,
        SDL_WINDOWPOS_UNDEFINED,
        SCREEN_WIDTH,
        SCREEN_HEIGHT,
        0
    );

    // Create Renderer
    SDL_Renderer *renderer = SDL_CreateRenderer(
        win, -1, 0
    );

    // Load ogg file
    Mix_Music *ogg_file = NULL;
    ogg_file = Mix_LoadMUS(MUSIC_PATH);
    if (!ogg_file) {
        return 0;
    }

    SDL_Rect rect;

    // Square dimensions: Half of the min(SCREEN_WIDTH, SCREEN_HEIGHT)
    rect.w = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) / 2;
    rect.h = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) / 2;

    // Square position: In the middle of the screen
    rect.x = SCREEN_WIDTH / 2 - rect.w / 2;
    rect.y = SCREEN_HEIGHT / 2 - rect.h / 2;


    // Declare rects of pause symbol
    SDL_Rect pause_rect1, pause_rect2;

    pause_rect1.h = rect.h / 2;
    pause_rect1.w = 40;
    pause_rect1.x = rect.x + (rect.w - pause_rect1.w * 3) / 2;
    pause_rect1.y = rect.y + rect.h / 4;
    pause_rect2 = pause_rect1;
    pause_rect2.x += pause_rect1.w * 2;
    
    // play the music 8 times
    if (Mix_PlayMusic(ogg_file, 8) == -1) {
        return 0;
    }

    int running = 1;
    SDL_Event e;
    while (running) {
        if(SDL_PollEvent(&e)) {
            switch(e.type) {
                case SDL_QUIT:
                    running = 0;
                break;
                case SDL_CONTROLLERDEVICEADDED:
                    SDL_GameControllerOpen(e.cdevice.which);
                break;
                case SDL_CONTROLLERBUTTONDOWN:
                    // pause using cross button
                    if (e.cbutton.button == SDL_CONTROLLER_BUTTON_A) {
                        Mix_PauseMusic();
                    // resume using circle button
                    } else if (e.cbutton.button == SDL_CONTROLLER_BUTTON_B) {
                        Mix_ResumeMusic();
                    }	
                    // press start button to exit
                    if (e.cbutton.button == SDL_CONTROLLER_BUTTON_START) {
                        running = 0;
                    }
            break;		
            }
        }

        // Initialize renderer color black for the background
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);

        // Clear screen
        SDL_RenderClear(renderer);

        // Set renderer color green to draw the square
        SDL_SetRenderDrawColor(renderer, 0, 0xFF, 0, 0xFF);

        // Draw filled square
        SDL_RenderFillRect(renderer, &rect);

        // Check pause status
        if(Mix_PausedMusic()) {
            // Set renderer color black to draw the pause symbol
            SDL_SetRenderDrawColor(renderer, 0, 0, 0, 0);

            // Draw pause symbol
            SDL_RenderFillRect(renderer, &pause_rect1);
             SDL_RenderFillRect(renderer, &pause_rect2);
        }

        // Update screen
        SDL_RenderPresent(renderer);
    }

    Mix_FreeMusic(ogg_file);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(win);
    Mix_CloseAudio();
    SDL_Quit();

    return 0;
}

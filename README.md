# FRACTAL-WITH-COBOL
A pixel-accurate **Burning Ship fractal** renderer where **COBOL drives SDL2** through thin C wrappers. Fixed-point math, zero external deps beyond SDL2 and the GnuCOBOL runtime.

> **Scope/claim:** As of 2025-09-09, I’m not aware of another publicly documented project that renders a fractal **directly from COBOL** via an SDL pipeline. If you know one, I’d love a link.
## What? (and why)
It starded more as a joke, and then I did it, which I'm kinda grateful of since I learned so much about this programming language. As you may know, COBOL stands for (**CO**)mmon (**B**)usiness (**O**)riented (**L**)anguage, I just though it would be kinda funny to create something that isn't even close to the acronym, I already knew that you could call c and c++ function inside of cobol, and I'm already pretty interested in fractals and complex number(maybe I will show other project related to those in the future), so this absurd joke already had almost everything to become the **The Bane Of My Existence**

The hardest part wasn’t the math it was the **COBOL ↔ C/SDL2 interop**:

- **Pointers.** SDL uses types like `SDL_Renderer*` and `SDL_Window*`. But cobol doen't have idea of what these variables mean, but it does know what void pointer are, by using key words like (USAGE POINTER) which are used when creating a variable, internally cobol creates a (void*), and (BY REFERENCE) will pass the address of a variable, which is useful, because I can call (by reference) a variable created with USAGE POINTER, generating a (void**), if I don't want to pass a double pointer, I can just use (BY VALUE) since those variables are already (void*)
- **Binary numerics.** COBOL’s default numeric storage is “display” (text-like). I use `COMP-5` so values are stored as **native binary** integers that C understands.  
  32-bit fields map cleanly to C `int`/`int32_t`; 64-bit fields to `long long`/`int64_t`.
- **Floating Points** Cobol doesn't have that, so I created a variable called (SCALE), I just multiply every variable that should be a float/double by that for fixed pointer arimethic

## What you need to run:
- gnucobol compiler, also know as cobc
- SDL2
- you also will need to clone the repo 
## How to run:
- linux (DEBIAN/UBUNTO BASED):
```bash
sudo apt update
sudo apt install -y gnucobol libsdl2-dev git # installing compiler and SDL2 de libs
git clone https://github.com/PedroGeometrias/FRACTAL-WITH-COBOL # here you're cloning my repo
cd FRACTAL-WITH-COBOL # moving to the place where the code is, so you can compile it
cobc -x -O2 main.cob sdl_expose.c $(sdl2-config --cflags) -lSDL2 # compiling. -x means to generate a executable, it's necessary, but the O2 flag really isn't, it just means the optimization level 
```
and that's basically it, If I remembered everything correctly. Now on windows you will have a bit more trouble, so
I made a release for the executable, you can just download it, maybe in the future I can create a makefile for windows, so it can better help people out.

# What to do next:
- As I said, I will problably make the process simpler to compile for windows users
- add some sort of explorer, like a point and click zoom feature, so people can explore the fractal
- make it so people can also create an image from the rendered fractal



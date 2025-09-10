# FRACTAL-WITH-COBOL
I've written a burning ship fractal implementation with COBOL, using c as a SDL2 bridge, and setted it with constants spans.
## What you need to run:
- gnucobol compiler, also know as cobc
- SDL2
- you also will need to clone the repo 
## How to run:
- linux (DEBIAN BASED):
```bash
sudo apt update
sudo apt-get install libsdl2-dev # installing the SDL2 dev version
sudo apt install gnucobol # installing the cobol compiler
git clone https://github.com/PedroGeometrias/FRACTAL-WITH-COBOL # here you're cloning my repo
cd FRACTAL-WITH-COBOL # moving to the place where the code is, so you can compile it
cobc -x -O2 main.cob sdl_expose.c -lSDL2 # compiling. -x means to generate a executable, it's necessary, but the O2 flag really isn't, it just means the optimization level 
```
and that's basically it, If I remember everything correctly, now on windows you will have a bit more trouble.
So I will make the windows executable available on the releases, and maybe also do a MakeFile to help

# What to do next:
- As I said, I will problably make process simpler to compiler for windows users
- add some sort of explorer, like a point and click zoom feature, so people can explore the fractal
- make it so people can also create a image from the rendered fractal



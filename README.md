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
sudo apt-get install libsdl2-dev
sudo apt install gnucobol
git clone https://github.com/PedroGeometrias/FRACTAL-WITH-COBOL
cd FRACTAL-WITH-COBOL
cobc -x -O2 main.cob sdl_expose.c -lSDL2
```
and that's basically it, If I remember everything correctly, now on windows you will have a bit more trouble.
So I will make the windows executable available on the releases, and maybe also do a MakeFile to help

# What to do next:
- As I said, I will problably make process simpler to compiler for windows users
- add some sort of explorer, like a point and click zoom feature, so people can explorer the fractal
- make it so people can also create a image from the rendered fractal



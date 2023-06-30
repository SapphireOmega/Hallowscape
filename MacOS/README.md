# Project Software Engineering 2023 - Group B

See `controllerApp/ReadMe.md` for information about the phone app specifically.

## Housekeeping

Links:
+ Trello: https://trello.com/invite/pse227/ATTI650f49a0d9ddb08176879cc15165a97a0383CABE

Directories:
+ `godot` contains the Godot project that will run on the laptop (screen).
  - `godot/godot-cpp` contains the C++ GDExtension repo.
  - `godot/src` contains the C++ source files.
  - `godot/project` contains the Godot project files.
  - `godot/demo` contains the Godot platforming demo for reference
  - `godot/SConstruct` tells sconstruct how our C++ module(s) should be compiled

## Running

TODO: Add compiled binaries.

You need to have the app installed on your phone (see `controllerApp/ReadMe.md`). Make sure you have your computer and your two phones on the same wifi network. Run the game on your computer, and in the app on the phones, type the ip address shown on the computer screen. Your phone will function as controller. You will be able to interact with certain game entities, wich may trigger a puzzle on your phone.

There is the option to run the game without needing a phone if you run godot from the editor. To do this, you will need to have Godot 4 installed. In the Godot project manager (which will run when opening godot without arguments) select `Import` and open the `godot/project/project.godot` file. Then open the newly imported project. To run, just press the triangle in the top-right. To turn off the server and phones, open `TestServerClients/Server.tscn` in the editor, select the root `Server` node, and in the inspector on the right, turn off `RunOnLaunch`.

## Compiling the Godot Project

### C++ Bindings

*We did not end up using the C++ bindings, so this step is optional, and the C++ bindings are already compiled for MacOS and Linux.*

You will need to install scons to compile.

The C++ module(s) are compiled seperately and loaded into Godot. You need to initialise the `/PSE/godot/godot-cpp/bib/` submodule. To compile the C++ module(s), run `scons platform=<platform>` in the `PSE/godot` directory. This will compile the C++ files according to `PSE/godot/SConstruct`.

It expects the static library for the C++ extension to be in `/PSE/godot/godot-cpp/bin/`, of which the name should start with `libgodot-cpp.<platform>`. If the library for your platform is not present, you should go into the `/PSE/godot/godot-cpp/` directory and compile it for your platform. The Godot C++ code is added as a git submodule. You will need to run `git submodule update --init` to pull the submodule. To compile, run `scons platform=<platform>` in the `godot-cpp` directory (you can change the number of cores to be used with the `-j` flag, it will automatically use as many as possible).

If the `libgodot-cpp` library *is* present, it will go on to read `PSE/godot/src/register_types.cpp`. This file defines our C++ *module*. All types defined in our module must be registered in `initialize_pse_module` using `ClassDB::register_class<TYPENAME>()`. After compilation is done, a dynamically linked library should have been placed in `/PSE/godot/project/bin/`.

If all has gone well, you should be able to boot up Godot, and find that the types you created should now exist as new types of nodes which are placable in your scene.

(For the complete documentation on GDExtension C++, click [here](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/gdextension_cpp_example.html).)

### Game Executable

todo
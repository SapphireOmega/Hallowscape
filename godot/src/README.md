# Godot C++

In this directory all the C++ source code for the Godot game is found.

## Discussion on GDScript and C++

Godot has a built-in interpreted scripting language called GDScript. It also exports bindings for other languages. One of these officially supported languages is C++. We have set up this project such that the C++ bindings are available. They are not, however, necessary. The C++ bindings may have some uses, and thus we have set up the project to have the C++ option.

Ultimately, different parts of the project can easily be made in the different languages. We must consider when to use which. We will discuss some of the considerations to be taken into account next.

### Advantages of C++ Bindings

C++, unlike GDScript, is compiled. This means that it is potentially faster and more (energy) efficient. This may be a consideration if we want to make the project "green". Furthermore, GDScript is quite a limited language. It is only Object Oriented and Imperative. C++ has more language features, such as lambdas, which allows for more programming paradigms. With C++, you are not limited to strictly using the Godot paradigm/architecture (with node trees and scenes). On top of that, you have access to the vast C++ STL, and the vast array of third party C++ libraries out in the world. This means it could potentially be possible to import certain functionality into our project which we would have to do without or build from scratch if we just had GDScript. C++ also has static typing, which could be something we would want.

### Disadvantages of the C++ Bindings

The C++ "scripts" must be compiled seperately and linked (dynamically) into Godot. The Godot API must also be linked (statically) into the C++ code. This means you will have to deal with compile times, and will have to reload the Godot editor every time you change the C++ code, if you want the changes to take effect. This drastically increases the length of the feedback loop and may make for a worse programming experience and productivity. But that is not all; GDExtension makes heavy use of macros, which means that small mistakes (such as typos) can make the compiler implode and spew out a load o' junk. This can make debugging and iterating really difficult. A possibility would be to prototype everything in GDScript, and then translate it into C++. This does seem like a undesirable solution, though, as the translation takes up time and effort, and we would not have access to C++ features/paradigms while making the prototype. We should weigh up how much more difficult the C++ bindings are to work with and how much we can profit, in language features and efficiency, from said bindings for each component of the project.

On top of all that, the documentation is very poor. The fact that there has been a big update to Godot recently (as of writing this) which changed the way that bindings for other languages work, and that most of the existing documentation has not been updated, does not help a single bit. We will try to document what we learn as best we can.

## C++ GDExtension Documentation and Explanation

Godot 4.0 has switched from GDNative to GDExtension for language bindings for other languages. Between GDNative and GDExtension, the naming conventions and some of the fundamental ways in which the C++ bindings work have changed. As of writing this, the documentation on the C++ bindings is lacking to say the least. All there is, is the setup example [here](https://docs.godotengine.org/en/stable/tutorials/scripting/gdextension/gdextension_cpp_example.html), and some example code [here](https://github.com/godotengine/godot-cpp/tree/master/test/src) (or go to `PSE/godot/godot-cpp/test/src/`). The code snippets in the documentation (such as [here](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/03.coding_the_player.html)) for C++ have not been updated from GDNative. For this reason, it is necessary to document the changes and how to use C++ with GDExtension here.

Note that not only the bindings have changed, but the whole Godot API has changed from Godot 3 to Godot 4. If you are reading the Godot documentation and looking at the C++ snippets, keep in mind that the functions called in the C++ snippet may not exist anymore or may have changed. Make sure to read the text above the snippet, and/or the GDScript snippet to see if they still use the old (no longer existing) functions in the C++ snippet.

### Creating a New Node Type

Normally, with GDScript, you would place some sort of node in your scene and attach a script which will be interpreted by Godot. With C++, you need to compile your code first, and link it with Godot as a dynamically linked library. See `PSE/README.md` for how the basics of Godot's build system work. Rather than attach a script to a node, you must write a class which inherits from the type of node you want to "attach" to. If you compile and reload the project, you should that there now exists a new type of node which you just created in C++.

To create a new node in C++, you must create a class in the `godot` namespace, which inherits from the class representing the type of node you want to "attach" your script to. These classes all exist in the `godot` namespace and are defined in their own respective header files, which can be found in `PSE/godot/godot-cpp/gen/include/godot_cpp/classes/`. `PSE/godot/godot-cpp/gen/include/` will be added as include directory during compilation, so to include these headers, you must include them as `#include <godot_cpp/classes/<header_name>>`. Note that from GDNative to GDExtension, the naming convention of these headers has switched from CamelCase to snake_case. Besides inheritance, you must also call the `GDCLASS` macro with the name of your new class and the name of the class you are inheriting from. (in GDNative, this macro was called `GODOT_CLASS`, so beware with code snippets.) The naming convention for these classes still follows CamelCase (as is standard in C++ for types/classes).

### Reserved Methods and Binding/Exporting/Regestering Methods

There are a couple of "reserved" method names, which start usually with an underscore. One of the most important of these is `void _process(double delta)`. This will be called on every update cycle by godot. Another "reserved" method is `void _ready()`. This will be called once when the node is added to the scene tree and are ready. The one that is most important, however, would be `static void _bind_methods()`. Here you should "bind" or "export" all the methods that you want to be visible to Godot. This method has replaced GDNative's `void _register_methods()`. With `_register_methods`, it was necessary to export even the "reserved" method names, but GDExtension, with `_bind_methods` is able to find them automagically. For those methods you *do* need to export manually, you should include `godot_cpp/core/class_db.hpp` in your source file, and in your implementation of `_bind_methods`, you should add the statement `ClassDB::bind_method(D_METHOD("<name>"), &<TypeName>::<method_name>);`. (You have to do something slightly different for static methods, and is also something called `ADD_PROPERTY`, which I should look into more. See the example at [here](https://github.com/godotengine/godot-cpp/blob/master/test/src/example.cpp).)

### Registering Types

If you have created your class and registered your methods, you are not done yet. You must still register your new type in `register_types.cpp`. You must include any source files which you have added, of course, and in `initialize_pse_module`, you must add `ClassDB::register_class<<ClassName>>();` for any classes you have created. This will make your new type visible to Godot and make sure it is added as a new node type in the editor.

### Getting (Child) Nodes

When you are coding, you will probably have multiple child nodes attached to your root node with your script for certain functions. To get access to these children, run `get_node<<ClassName>>("NodeName");`. This will search the node tree for <NodeName> and return a pointer to it of type `<Classname>*`. Usually you call these functions once in `_ready` or the constructor and store them in some private variable. You should probably make a seperate scene for each script if you use child nodes, and instantiate them as child scenes. This makes it so you only have to set up the hierarchy of child nodes once, declutters the others scenes, and may avoid git conflicts in the scene files.

### Singletons

Singletons are a design pattern in C++, where you have a class of which there only exists one instance. These usually own and manage a specific resource. One instance of this design pattern in Godot is `Input` (see `godot_cpp/classes/input.hpp`). You can request a pointer to the instance with `Input::get_singleton()`. You can then use its methods to get access to input functionality. (Again, you would usually store the pointer in a private variable and run `Input::get_singleton()` once on initialisation.)

### Compilation and Reloading

To compile, run `scons` in the `/PSE/godot` directory. (See `PSE/README.md` for more information on the compilation process.) Note that GDExtension (and GDNative for that matter) make heavy use of macros. This means that a simple type may very well make the compiler implode and give a ginormous error message. Usually you will find the "real" error at the top. Sometimes it tells you pretty much nothing, and there is probably some naming conflict going on with the imported godot libraries, or possibly a discrepancy between the class names used in `GDCLASS` and the actual class inherited.

When compilation was completed successfully, you should be able to (re)start Godot and see your new node type when adding a new node to the scene. If you still had Godot running, click `Project > Reload Current Project` to restart the editor and relink the C++ library, making your changes have effect.
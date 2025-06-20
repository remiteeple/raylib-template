# Raylib-Template

A powerful, cross-platform template for creating a new game or application using the latest bleeding-edge source code of the raylib library.

This template is configured for C by default, but can be switched to C++ with a single file rename. It also includes optional support for ImGui and rlImGui.

## Supported Platforms
* **Windows** (Visual Studio 2022 or MinGW-w64)
* **Linux** (GCC/Clang)
* **macOS** (Clang)

## Getting Started

1.  **Download:** Download and extract the template files.
2.  **Rename:** Rename the project folder to match the name of your game (e.g., `My-Awesome-Game`).
3.  **Choose your platform below** and follow the one-time setup to install a compiler.

---

## Windows Instructions

You have two excellent options for building on Windows. Visual Studio is generally easier for debugging, while MinGW-w64 provides the open-source GCC toolchain.

### Option 1: Visual Studio 2022 (Recommended)

**One-Time Setup:**
1.  **Install Visual Studio:** If you haven't already, [download and install Visual Studio 2022 Community](https://visualstudio.microsoft.com/vs/community/).
2.  **Install Workload:** During installation, make sure to select the **"Desktop development with C++"** workload. This includes the required MSVC compiler, Windows SDK, and build tools.

**Building the Project:**
1.  Run the `generate-vs2022.bat` script by double-clicking it. This will use Premake5 to create a `build` directory containing your Visual Studio solution (`.sln`) file.
2.  Open the `.sln` file in Visual Studio.
3.  In the Solution Explorer, right-click on your project (e.g., "raylib-template") and choose **"Set as Startup Project"**.
4.  Press **F5** to build and run your application.

### Option 2: MinGW-w64 (GCC)

**One-Time Setup:**
1.  **Install MSYS2:** Go to the [official MSYS2 website](https://www.msys2.org/) and follow the instructions to install it.
2.  **Install Toolchain:** Open the **MSYS2 UCRT64** terminal from your Start Menu and run the following command to install the compiler, make, and other essential tools:
    ```sh
    pacman -S --needed base-devel mingw-w64-ucrt-x86_64-toolchain
    ```
3.  **Update Windows PATH:** Add the MinGW-w64 tools to your system's PATH so they can be found by scripts.
    * Press the Windows key, type `env`, and select "Edit the system environment variables".
    * Click "Environment Variables...", select the `Path` variable under "User variables", and click "Edit...".
    * Click "New" and add the following path: `C:\msys64\ucrt64\bin` (assuming a default install).
4.  **Verify:** Open a **new** Command Prompt or PowerShell window and verify the installation by typing `gcc --version`. You should see the compiler version information.

**Building the Project:**
* Simply double-click the `clean-and-build.bat` script.
* This will compile your code and the output executable will be placed in the `bin` directory.

---

## Linux Instructions

**One-Time Setup:**
* Install the necessary development tools. On Debian/Ubuntu-based systems, this can be done with:
    ```sh
    sudo apt update && sudo apt install build-essential
    ```

**Building the Project:**
* Open a terminal in the project's root directory.
* Make the build script executable: `chmod +x build.sh`
* Run the script: `./build.sh`
* The output executable will be in the `bin` directory.

---

## macOS Instructions

**One-Time Setup:**
* Install the Xcode Command Line Tools, which include Apple Clang, make, and other necessary utilities:
    ```sh
    xcode-select --install
    ```

**Building the Project:**
* Open a terminal in the project's root directory.
* Make the build script executable: `chmod +x build.sh`
* Run the script: `./build.sh`
* The output executable will be in the `bin` directory.

---

## Project Customization

### Switching to C

This project is configured for C++ by default. To switch to C, simply:
1.  Rename `src/main.cpp` to `src/main.c`.
2.  Re-run your build script of choice. The build system will automatically detect the change and use a C++ compiler.

### Enabling ImGui and rlImGui

This template includes optional, built-in support for an immediate mode GUI using the powerful **ImGui** library, along with **rlImGui** for easy integration with raylib. This feature is disabled by default.

**Prerequisite:** Enabling ImGui requires using C++. You must first switch your project to C++ by following the steps in the section above.

**To enable ImGui:**
1.  Modify your build generation script (`generate-vs2022.bat`, `clean-and-build.bat`, or `build.sh`).
2.  Find the line that runs `premake5` and add the `--with-imgui=true` flag.
3.  Run the modified script. The build system will automatically download and compile ImGui and rlImGui into your project.

**Example for `clean-and-build.bat`:**
* **Change this:**
    ```
    premake5.exe gmake2
    ```
* **To this:**
    ```
    premake5.exe gmake2 --with-imgui=true
    ```

### Using Your Own Code

You can remove the example `src/main.c` file and add your own source files to the `src` directory. After adding or removing files, re-run the build script to update the project and compile your code.

### Output Files & Resources

The final executable is placed in the `bin` directory. The project is configured to automatically find the `resources` directory, making it easy to load assets without worrying about the current working directory. You can inspect `path_utils.h` to see how this works.

### Building for other OpenGL Targets

To target a different OpenGL version, modify your build script. Add one of the following flags to the `premake5` command:

* `--graphics=opengl11` (OpenGL 1.1)
* `--graphics=opengl21` (OpenGL 2.1)
* `--graphics=opengl43` (OpenGL 4.3)
* `--graphics=opengles2` (OpenGL ES 2.0)
* `--graphics=opengles3` (OpenGL ES 3.0)

**Example for Windows:** `premake5.exe gmake2 --graphics=opengl43`

---

## License

Copyright (c) 2020-2025 Jeffery Myers (Thanks Jeff!)
Copyright (c) 2025 Remi Teeple

This software is provided "as-is", without any express or implied warranty. In no event 
will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial 
applications, and to alter it and redistribute it freely, subject to the following restrictions:

 1. The origin of this software must not be misrepresented; you must not claim that you 
 wrote the original software. If you use this software in a product, an acknowledgment 
 in the product documentation would be appreciated but is not required.

 2. Altered source versions must be plainly marked as such, and must not be misrepresented
 as being the original software.

 3. This notice may not be removed or altered from any source distribution.
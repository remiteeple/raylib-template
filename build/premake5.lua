-- premake5.lua

newoption
{
    trigger = "graphics",
    value = "OPENGL_VERSION",
    description = "version of OpenGL to build raylib against",
    allowed = {
        { "opengl11", "OpenGL 1.1"},
        { "opengl21", "OpenGL 2.1"},
        { "opengl33", "OpenGL 3.3"},
        { "opengl43", "OpenGL 4.3"},
        { "openges2", "OpenGL ES2"},
        { "openges3", "OpenGL ES3"}
    },
    default = "opengl33"
}

newoption
{
    trigger     = "with-raygui",
    value       = "mode",
    description = "Control raygui library",
    allowed = {
        { "download", "Download and use raygui" },
        { "local",    "Use local build of raygui" },
        { "none",     "Do not use raygui" }
    },
    default = "download"
}

newoption
{
    trigger     = "with-rlimgui",
    value       = "mode",
    description = "Control rlimgui and imgui libraries",
    allowed = {
        { "download", "Download and use rlimgui/imgui" },
        { "local",    "Use local builds of rlimgui/imgui" },
        { "none",     "Do not use rlimgui/imgui" }
    },
    default = "download"
}

function download_progress(total, current)
    local ratio = current / total;
    ratio = math.min(math.max(ratio, 0), 1);
    local percent = math.floor(ratio * 100);
    print("Download progress (" .. percent .. "%/100%)")
end

function download_raylib()
    os.chdir("external")
    if(os.isdir("raylib-master") == false) then
        if(not os.isfile("raylib-master.zip")) then
            print("Raylib not found, downloading from github")
            local result_str, response_code = http.download("https://github.com/raysan5/raylib/archive/refs/heads/master.zip", "raylib-master.zip", {
                progress = download_progress,
                headers = { "From: Premake", "Referer: Premake" }
            })
        end
        print("Unzipping to " ..  os.getcwd())
        zip.extract("raylib-master.zip", os.getcwd())
        os.remove("raylib-master.zip")
    end
    os.chdir("../")
end

function download_rlimgui()
    os.chdir("external")
    if(os.isdir("rlImGui-main") == false) then
        if(not os.isfile("rlImGui-main.zip")) then
            print("rlImGui not found, downloading from github")
            local result_str, response_code = http.download("https://github.com/raylib-extras/rlImGui/archive/refs/heads/main.zip", "rlImGui-main.zip", {
                progress = download_progress,
                headers = { "From: Premake", "Referer: Premake" }
            })
        end
        print("Unzipping to " ..  os.getcwd())
        zip.extract("rlImGui-main.zip", os.getcwd())
        os.remove("rlImGui-main.zip")
    end
    os.chdir("../")
end

function download_imgui()
    os.chdir("external")
    if(os.isdir("imgui-master") == false) then
        if(not os.isfile("imgui-master.zip")) then
            print("ImGui not found, downloading from github")
            local result_str, response_code = http.download("https://github.com/ocornut/imgui/archive/refs/heads/master.zip", "imgui-master.zip", {
                progress = download_progress,
                headers = { "From: Premake", "Referer: Premake" }
            })
        end
        print("Unzipping to " ..  os.getcwd())
        zip.extract("imgui-master.zip", os.getcwd())
        os.remove("imgui-master.zip")
    end
    os.chdir("../")
end

function download_raygui()
    os.chdir("external")
    if(os.isdir("raygui-master") == false) then
        if(not os.isfile("raygui-master.zip")) then
            print("raygui not found, downloading from github")
            local result_str, response_code = http.download("https://github.com/raysan5/raygui/archive/refs/heads/master.zip", "raygui-master.zip", {
                progress = download_progress,
                headers = { "From: Premake", "Referer: Premake" }
            })
        end
        print("Unzipping to " ..  os.getcwd())
        zip.extract("raygui-master.zip", os.getcwd())
        os.remove("raygui-master.zip")
    end
    os.chdir("../")
end

function build_externals()
    print("calling externals")
    if (downloadRaylib) then
        download_raylib()
    end
    if (_OPTIONS["with-rlimgui"] == "download") then
        download_rlimgui()
        download_imgui()
    end
    if (_OPTIONS["with-raygui"] == "download") then
        download_raygui()
    end
end

function platform_defines()
    filter {"configurations:Debug or Release"}
        defines{"PLATFORM_DESKTOP"}

    filter {"configurations:Debug_RGFW or Release_RGFW"}
        defines{"PLATFORM_DESKTOP_RGFW"}

    filter {"options:graphics=opengl43"}
        defines{"GRAPHICS_API_OPENGL_43"}

    filter {"options:graphics=opengl33"}
        defines{"GRAPHICS_API_OPENGL_33"}

    filter {"options:graphics=opengl21"}
        defines{"GRAPHICS_API_OPENGL_21"}

    filter {"options:graphics=opengl11"}
        defines{"GRAPHICS_API_OPENGL_11"}

    filter {"options:graphics=openges3"}
        defines{"GRAPHICS_API_OPENGL_ES3"}

    filter {"options:graphics=openges2"}
        defines{"GRAPHICS_API_OPENGL_ES2"}

    filter {"system:macosx"}
        disablewarnings {"deprecated-declarations"}

    filter {"system:linux"}
        defines {"_GLFW_X11"}
        defines {"_GNU_SOURCE"}

    filter{}
end

-- if you don't want to download raylib, then set this to false, and set the raylib dir to where you want raylib to be pulled from, must be full sources.
downloadRaylib = true
raylib_dir = "external/raylib-master"

-- rlImGui, ImGui, and raygui are controlled by their respective options
rlImGui_dir = "external/rlimgui-main"
ImGui_dir = "external/imgui-master"
raygui_dir = "external/raygui-master"

workspaceName = 'MyGame'
baseName = path.getbasename(path.getdirectory(os.getcwd()));

if (baseName ~= 'raylib-template') then
    workspaceName = baseName
end

if (os.isdir('build_files') == false) then
    os.mkdir('build_files')
end

if (os.isdir('external') == false) then
    os.mkdir('external')
end


workspace (workspaceName)
    location "../"
    configurations { "Debug", "Release", "Debug_RGFW", "Release_RGFW"}
    platforms { "x64", "x86", "ARM64"}

    defaultplatform ("x64")

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"

    filter { "platforms:x64" }
        architecture "x86_64"

    filter { "platforms:Arm64" }
        architecture "ARM64"

    filter {}

    targetdir "bin/%{cfg.buildcfg}/"

if (downloadRaylib or _OPTIONS["with-raygui"] == "download" or _OPTIONS["with-rlimgui"] == "download") then
    build_externals()
end

    startproject(workspaceName)

    project (workspaceName)
        kind "ConsoleApp"
        location "build_files/"
        targetdir "../bin/%{cfg.buildcfg}"

        filter {"system:windows", "configurations:Release", "action:gmake*"}
            kind "WindowedApp"
            buildoptions { "-Wl,--subsystem,windows" }

        filter {"system:windows", "configurations:Release", "action:vs*"}
            kind "WindowedApp"
            entrypoint "mainCRTStartup"

        filter "action:vs*"
            debugdir "$(SolutionDir)"

        filter{}

        vpaths
        {
            ["Header Files/Include"] = { "../include/**.h", "../include/**.hpp" },
            ["Header Files/Source"] = { "../src/**.h", "../src/**.hpp" },
            ["Source Files/Main"] = { "../src/**.c", "../src/**.cpp" },
            ["Source Files"] = { "../src/**" }
        }
        files {"../src/**.c", "../src/**.cpp", "../src/**.h", "../src/**.hpp", "../include/**.h", "../include/**.hpp"}

        includedirs { "../src" }
        includedirs { "../include" }

        -- Link to all required libraries
        links {"raylib"}
        if (_OPTIONS["with-rlimgui"] ~= "none") then
            links {"rlImGui", "ImGui"}
        end

        cdialect "C99"
        cppdialect "C++17"

        -- Include directories for raylib
        includedirs {raylib_dir .. "/src" }
        includedirs {raylib_dir .."/src/external" }
        includedirs { raylib_dir .."/src/external/glfw/include" }
        
        if (_OPTIONS["with-raygui"] ~= "none") then
            -- Include directory for raygui
            includedirs {raygui_dir .. "/src"}
        end
        if (_OPTIONS["with-rlimgui"] ~= "none") then
            -- Include directories for rlImGui and ImGui
            includedirs {rlImGui_dir}
            includedirs {ImGui_dir}
        end
        
        flags { "ShadowedVariables"}
        platform_defines()

        filter "action:vs*"
            defines{"_WINSOCK_DEPRECATED_NO_WARNINGS", "_CRT_SECURE_NO_WARNINGS"}
            dependson {"raylib"}
            links {"raylib.lib"}
            if (_OPTIONS["with-rlimgui"] ~= "none") then
                dependson {"rlImGui", "ImGui"}
                links {"rlImGui.lib", "ImGui.lib"}
            end
            characterset ("Unicode")
            buildoptions { "/Zc:__cplusplus" }

        filter "system:windows"
            defines{"_WIN32"}
            links {"winmm", "gdi32", "opengl32"}
            libdirs {"../bin/%{cfg.buildcfg}"}

        filter "system:linux"
            links {"pthread", "m", "dl", "rt", "X11"}

        filter "system:macosx"
            links {"OpenGL.framework", "Cocoa.framework", "IOKit.framework", "CoreFoundation.framework", "CoreAudio.framework", "CoreVideo.framework", "AudioToolbox.framework"}

        filter{}
        

    project "raylib"
        kind "StaticLib"
    
        platform_defines()

        location "build_files/"

        language "C"
        targetdir "../bin/%{cfg.buildcfg}"

        filter "action:vs*"
            defines{"_WINSOCK_DEPRECATED_NO_WARNINGS", "_CRT_SECURE_NO_WARNINGS"}
            characterset ("Unicode")
            buildoptions { "/Zc:__cplusplus" }
        filter{}

        includedirs {raylib_dir .. "/src", raylib_dir .. "/src/external/glfw/include" }
        
        vpaths
        {
            ["Header Files/Core"] = { raylib_dir .. "/src/*.h" },
            ["Header Files/External"] = { raylib_dir .. "/src/external/**.h" },
            ["Source Files/Core"] = { raylib_dir .. "/src/*.c" },
            ["Source Files/External"] = { raylib_dir .. "/src/external/**.c" },
            ["Source Files"] = { raylib_dir .. "/src/**" }
        }
        files {raylib_dir .. "/src/*.h", raylib_dir .. "/src/*.c"}

        removefiles {raylib_dir .. "/src/rcore_*.c"}

        -- If raygui is enabled, define its implementation and add its include path
        -- This will compile raygui's code directly into raylib.lib
        filter { "options:with-raygui=download", "options:with-raygui=local" }
            includedirs { raygui_dir .. "/src" }
            defines { "RAYGUI_IMPLEMENTATION" }
        filter {}

        filter { "system:macosx", "files:" .. raylib_dir .. "/src/rglfw.c" }
            compileas "Objective-C"

        filter{}

if (_OPTIONS["with-rlimgui"] ~= "none") then
    project "rlImGui"
        kind "StaticLib"
        location "build_files/"
        targetdir "../bin/%{cfg.buildcfg}"

        platform_defines()

        language "C++"
        cppdialect "C++17"

        includedirs {
            rlImGui_dir,                                -- For rlimgui.h
            ImGui_dir,                                  -- For imgui.h (rlImGui includes it)
            raylib_dir .. "/src",
            raylib_dir .. "/src/external/glfw/include"
        }

        vpaths
        {
            ["Header Files/rlImGui"] = { rlImGui_dir .. "/*.h" },
            ["Header Files/rlImGui/Include"] = { rlImGui_dir .. "/include/**.h" },
            ["Source Files/rlImGui"] = { rlImGui_dir .. "/*.cpp" },
            ["Source Files/rlImGui/Implementation"] = { rlImGui_dir .. "/src/**.cpp" },
            ["Source Files"] = { rlImGui_dir .. "/**" }
        }

        files {
            rlImGui_dir .. "/rlimgui.h",
            rlImGui_dir .. "/rlimgui.cpp"
        }

        filter {"system:macosx"}
            compileas "Objective-C++"
        filter{}

    project "ImGui"
        kind "StaticLib"
        location "build_files/"
        targetdir "../bin/%{cfg.buildcfg}"

        platform_defines()

        language "C++"
        cppdialect "C++17"

        includedirs {
            ImGui_dir,                                  -- For imgui.h etc.
            raylib_dir .. "/src",
            raylib_dir .. "/src/external/glfw/include" 
        }

        vpaths
        {
            ["Header Files/ImGui/Core"] = {
                ImGui_dir .. "/imconfig.h",
                ImGui_dir .. "/imgui.h",
                ImGui_dir .. "/imgui_internal.h"
            },
            ["Header Files/ImGui/STB"] = {
                ImGui_dir .. "/imstb_rectpack.h",
                ImGui_dir .. "/imstb_textedit.h",
                ImGui_dir .. "/imstb_truetype.h"
            },
            ["Header Files/ImGui/Backends"] = { ImGui_dir .. "/backends/**.h" },
            ["Source Files/ImGui/Core"] = {
                ImGui_dir .. "/imgui.cpp",
                ImGui_dir .. "/imgui_draw.cpp",
                ImGui_dir .. "/imgui_tables.cpp",
                ImGui_dir .. "/imgui_widgets.cpp"
            },
            ["Source Files/ImGui/Demo"] = { ImGui_dir .. "/imgui_demo.cpp" },
            ["Source Files/ImGui/Backends"] = { ImGui_dir .. "/backends/**.cpp" },
            ["Source Files"] = { ImGui_dir .. "/**" }
        }

        files {
            ImGui_dir .. "/imconfig.h",
            ImGui_dir .. "/imgui.h",
            ImGui_dir .. "/imgui_internal.h",
            ImGui_dir .. "/imstb_rectpack.h",
            ImGui_dir .. "/imstb_textedit.h",
            ImGui_dir .. "/imstb_truetype.h",
            ImGui_dir .. "/imgui.cpp",
            ImGui_dir .. "/imgui_draw.cpp",
            ImGui_dir .. "/imgui_tables.cpp",
            ImGui_dir .. "/imgui_widgets.cpp",
            ImGui_dir .. "/imgui_demo.cpp"
        }

        filter {"system:macosx"}
            compileas "Objective-C++"
        filter{}
end
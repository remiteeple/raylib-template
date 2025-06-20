#include "raylib.h"
#include "rlImGui.h"
#include "imgui.h"

#define RAYGUI_IMPLEMENTATION
#include "raygui.h"

int main(int argc, char* argv[])
{
   // Initialize Raylib
   InitWindow(1280, 800, "Raylib rlImGui + raygui Boilerplate");
   SetTargetFPS(144);

   bool showMessageBox = false;

   // Setup rlImGui
   rlImGuiSetup(true);

   // Main game loop
   while (!WindowShouldClose())
   {
      // Start ImGui Frame
      rlImGuiBegin();

      // Show ImGui Demo Window
      ImGui::ShowDemoWindow();

      // Start Drawing
      BeginDrawing();
      ClearBackground(DARKGRAY);

      // Render rlImGui
      rlImGuiEnd();

      // Draw a button to show a message box using raygui
      if (GuiButton({ 24, 24, 120, 30 }, "#191#Show Message")) showMessageBox = true;

      // Draw a button to show the raygui Demo Control Window
      if (showMessageBox)
      {
         int result = GuiMessageBox({ 85, 70, 250, 100 },
            "#191#Message Box", "Hi! This is a message!", "Nice;Cool");

         if (result >= 0) showMessageBox = false;
      }

      EndDrawing();
   }

   // De-Initialization
   rlImGuiShutdown();
   CloseWindow();

   return 0;
}
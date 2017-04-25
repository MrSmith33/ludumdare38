/**
Copyright: Copyright (c) 2017 Andrey Penechko.
License: $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).
Authors: Andrey Penechko.
*/
module game;

import voxelman.platform;
import graphics;
import math;

import player;
import scene;

final class Game
{
	bool isClosePressed;

	IWindow window;
	IRenderer renderer;
	Renderer2d renderer2d;

	PlayerCharacter player;
	Scene scene;

	this()
	{
		initLibs();

		window = new GlfwWindow();
		window.init(ivec2(180, 90)*4, "LD 38 - by MrSmith33");
		renderer = new OglRenderer(window);
		renderer.setClearColor(128,128,128);

		// Bind events
		window.windowResized.connect(&windowResized);
		window.closePressed.connect(&closePressed);

		auto resourceManager = new ResourceManager(renderer);
		renderer2d = new Renderer2d(resourceManager);

		window.mouseReleased.connect(&onMouseReleased);

		player.create(renderer2d);
		scene.create(renderer2d);

		resourceManager.reuploadTexture();
	}

	void initLibs()
	{
		import derelict.glfw3.glfw3;
		import derelict.opengl3.gl3;
		import voxelman.utils.libloader;

		DerelictGL3.load();
		loadLib(DerelictGLFW3, "./", "glfw3");
	}

	void onPreUpdate()
	{
		window.processEvents();
	}

	void onMouseReleased(uint button)
	{
		player.walkTo(window.mousePosition);
	}

	void onUpdate(double delta)	{
		renderer2d.beginFrame();

		renderer2d.print(vec2(0,0), Colors.black, 2, "Ludum Dare 38: A Small World - by MrSmith33");
		player.update(renderer2d, delta);
		scene.update(renderer2d, delta);

		renderer2d.endFrame();
	}
	void onPostUpdate() {}
	void onRender() {
		checkgl!glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
		renderer2d.draw();
		renderer.flush();
	}

	void onStop()
	{
		window.releaseWindow;
	}

	void windowResized(ivec2 newSize)
	{
		renderer.setViewport(ivec2(0, 0), renderer.framebufferSize);
	}

	void closePressed()
	{
		isClosePressed = true;
	}
}

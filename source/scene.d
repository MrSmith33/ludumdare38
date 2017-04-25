/**
Copyright: Copyright (c) 2017 Andrey Penechko.
License: $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).
Authors: Andrey Penechko.
*/
module scene;

import graphics;
import math;

struct Scene
{
	SpriteInstance sceneSprite;

	void create(Renderer2d renderer)
	{
		sceneSprite = SpriteInstance(renderer.resourceManager.loadSprite("scene_1"), vec2(4,4));
	}

	void update(Renderer2d renderer, double dt)
	{
		renderer.draw(sceneSprite, vec2(0,0), 0);
	}
}

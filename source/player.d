/**
Copyright: Copyright (c) 2017 Andrey Penechko.
License: $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).
Authors: Andrey Penechko.
*/
module player;

import graphics;
import math;

struct PlayerCharacter
{
	AnimationInstance* anim_current;
	AnimationInstance anim_walk;
	AnimationInstance anim_idle;

	vec2 currentPos = vec2(400, 300);
	vec2 targetPos = vec2(400, 300);
	float speed = 80;
	int direction = -1;
	int spriteScale = 4;

	frect allowedArea = frect(25, 55, 150, 30);

	void create(Renderer2d renderer)
	{
		anim_walk = AnimationInstance(renderer.resourceManager.loadAnimation("cat_walk"));
		anim_idle = AnimationInstance(renderer.resourceManager.loadAnimation("cat_idle"));

		anim_current = &anim_idle;
	}

	void walkTo(ivec2 scenePos)
	{
		targetPos = scenePos;
	}

	void update(Renderer2d renderer, double dt)
	{
		restrictPos(currentPos);
		restrictPos(targetPos);
		movement(dt);
		anim_current.update(dt);

		anim_current.scale = ivec2(direction * spriteScale, spriteScale);
		anim_current.origin = ivec2(20,64);
		renderer.draw(*anim_current, currentPos, currentPos.y);
		//renderer.print(currentPos + vec2(0, 20), "frame: %s\n", currentPos);
	}

	void restrictPos(ref vec2 pos)
	{
		pos = voxelman.math.utils.clamp(pos, allowedArea.position * spriteScale, allowedArea.endPosition * spriteScale);
	}

	void movement(double dt)
	{
		vec2 prevPos = currentPos;
		currentPos = lerpMovement(currentPos, targetPos, speed, dt);

		vec2 deltaPos = currentPos - prevPos;

		// stop animation when no movement
		if (isAlmostZero(deltaPos))
		{
			anim_current = &anim_idle;
			return;
		}

		anim_current = &anim_walk;

		// flip on opposite movement
		if (sign(deltaPos.x) != sign(anim_current.scale.x))
			direction *= -1;
	}
}

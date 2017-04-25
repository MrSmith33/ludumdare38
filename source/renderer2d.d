/**
Copyright: Copyright (c) 2017 Andrey Penechko.
License: $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).
Authors: Andrey Penechko.
*/
module renderer2d;

import graphics;
import math;

final class Renderer2d
{
	ResourceManager resourceManager;

	BufferRenderer bufferRenderer;
	Batch2d batch;
	TexturedBatch2d texBatch;

	this(ResourceManager resMan)
	{
		resourceManager = resMan;
		bufferRenderer = new BufferRenderer(resourceManager.renderer);
	}

	void beginFrame()
	{
		batch.reset();
		texBatch.reset();
	}

	void endFrame()
	{}

	void draw()
	{
		resourceManager.renderer.alphaBlending(true);
		resourceManager.renderer.depthTest = true;
		bufferRenderer.updateOrtoMatrix(resourceManager.renderer);
		bufferRenderer.draw(batch);
		bufferRenderer.draw(texBatch);
	}

	void draw(AnimationInstance animation, vec2 target, float depth, Color4ub color = Colors.white)
	{
		auto frameRect = animation.currentFrameRect;
		vec2 targetRectPos = target - vec2(animation.origin * animation.scale);
		texBatch.putRect(
			frect(targetRectPos, vec2(frameRect.size) * animation.scale),
			frect(frameRect),
			depth,
			color,
			resourceManager.atlasTexture);
	}

	void draw(Sprite sprite, vec2 target, float depth, Color4ub color = Colors.white)
	{
		texBatch.putRect(
			frect(target, vec2(sprite.atlasRect.size)),
			frect(sprite.atlasRect),
			depth,
			color,
			resourceManager.atlasTexture);
	}

	void draw(SpriteInstance sprite, vec2 target, float depth, Color4ub color = Colors.white)
	{
		vec2 targetRectPos = target - vec2(sprite.origin * sprite.scale);
		texBatch.putRect(
			frect(targetRectPos, vec2(sprite.sprite.atlasRect.size) * sprite.scale),
			frect(sprite.sprite.atlasRect),
			depth,
			color,
			resourceManager.atlasTexture);
	}

	void drawTexRect(frect target, frect source, float depth, Color4ub color = Colors.white)
	{
		texBatch.putRect(target, source, depth, color, resourceManager.atlasTexture);
	}

	TextRenderer text()
	{
		return TextRenderer(&texBatch, resourceManager.atlasTexture);
	}

	TextRenderer textAt(vec2 origin)
	{
		return TextRenderer(&texBatch, resourceManager.atlasTexture, origin);
	}

	void print(Args...)(vec2 pos, Color4ub color, int scale, string fmt, Args args)
	{
		TextRenderer(&texBatch, resourceManager.atlasTexture, pos)
			.writef(resourceManager.fontManager.defaultFont, LayerDepth_text, color, scale, fmt, args);
	}

	void print(Args...)(vec2 pos, Color4ub color, string fmt, Args args)
	{
		this.print(pos, color, 1, fmt, args);
	}

	void print(Args...)(vec2 pos, string fmt, Args args)
	{
		this.print(pos, Colors.black, 1, fmt, args);
	}
}

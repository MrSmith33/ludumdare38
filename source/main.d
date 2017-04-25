/**
Copyright: Copyright (c) 2017 Andrey Penechko.
License: $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).
Authors: Andrey Penechko.
*/

module main;

import voxelman.platform;

import game;
import math;


void main(string[] args)
{
	import std.datetime : MonoTime, Duration, usecs, dur;
	import core.thread : Thread;

	Game game = new Game();

	bool limitFps = true;
	Duration targetFrameTime = (1_000_000 / 60).usecs;

	MonoTime prevTime = MonoTime.currTime;

	bool isRunning = true;
	while(isRunning)
	{
		MonoTime newTime = MonoTime.currTime;
		double delta = (newTime - prevTime).total!"usecs" / 1_000_000.0;
		prevTime = newTime;

		game.onPreUpdate();
		game.onUpdate(delta);
		game.onPostUpdate();
		game.onRender();

		isRunning = !game.isClosePressed;

		if (limitFps) {
			Duration updateTime = MonoTime.currTime - newTime;
			Duration sleepTime = targetFrameTime - updateTime;
			if (sleepTime > Duration.zero)
				Thread.sleep(sleepTime);
		}
	}

	game.onStop();
}

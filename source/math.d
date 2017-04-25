/**
Copyright: Copyright (c) 2017 Andrey Penechko.
License: $(WEB boost.org/LICENSE_1_0.txt, Boost License 1.0).
Authors: Andrey Penechko.
*/
module math;

public import voxelman.math;

V lerpMovement(V)(V from, V to, double speed, double dt)
{
	auto curDist = distance(from, to);
	auto distanceToMove = speed * dt;
	if (curDist == 0 || distanceToMove == 0) return from;
	double time = distanceToMove / curDist;
	return lerpClamp(from, to, time);
}

V lerpClamp(V)(V currentPos, V targetPos, double time)
{
	time = clamp(time, 0.0, 1.0);
	return lerp(currentPos, targetPos, time);
}

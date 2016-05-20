//var ball1 = new EKSphere();
//ball1.radius = 5;
//ball1.physics = "dynamic"
//
//var ball2 = new EKSphere();
//ball2.radius = 2;
//ball2.position = [-10, 0, 0];
//ball2.color = "green"
//ball2.physics = "static"

var ball = new EKSphere();
ball.color = "purple";
ball.physics = "dynamic";
ball.position = [Math.random() * 10 - 5, 2, 4];

var ball2 = new EKSphere();
ball2.color = "blue";
ball2.physics = "dynamic";
ball2.position = [-5, -2, 4];
ball2.velocity = [3 + Math.random() * 3,
				  3 + Math.random() * 3,
				  0];

function myCallback(eventTap) {
	print("I was called back!");
	print(eventTap.position);
}

addCallbackForEvent(myCallback, "tap");

function myPanCallback(eventPan) {
	print("I was called back for pan!");
	print(eventPan.position);
	print(eventPan.displacement);
	print(eventPan.state);
}

addCallbackForEvent(myPanCallback, "pan");

function myPinchCallback(eventPinch) {
	print("I was called back for pinch!");
	print(eventPinch.position);
	print(eventPinch.scale);
	print(eventPinch.state);
}

addCallbackForEvent(myPinchCallback, "pinch");

function myRotationCallback(eventRotation) {
	print("I was called back for rotation!");
	print(eventRotation.position);
	print(eventRotation.angle);
	print(eventRotation.state);
}

addCallbackForEvent(myRotationCallback, "rotation");

function myLongPressCallback(eventLongPress) {
	print("I was called back for long press!");
	print(eventLongPress.position);
	print(eventLongPress.displacement);
	print(eventLongPress.state);
}

addCallbackForEvent(myLongPressCallback, "long press");

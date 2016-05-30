var ball = new EKBox();
ball.color = "purple";
ball.position = [0, 0, 0];

ekCamera.position = [0, 0, 3];

var x = [1, 0, 0];
var y = [0, 1, 0];
var z = [0, 0, 1];

var cameraX = ekCamera.rotation.rotate(x);
var cameraY = ekCamera.rotation.rotate(y);
var cameraZ = ekCamera.rotation.rotate(z);

function updateCameraAxes() {
	cameraX = ekCamera.rotation.rotate(x);
	cameraY = ekCamera.rotation.rotate(y);
	cameraZ = ekCamera.rotation.rotate(z);
}

function myPanCallback(eventPan) {
	print(eventPan.touches)

	if (eventPan.touches == 1) {
		var resized = eventPan.displacement.times(0.01);

		updateCameraAxes();
		var axis = cameraX.times(resized.y)
			.plus(cameraY.times(-resized.x));

		var rot = new EKVector4(axis.x, axis.y, axis.z, resized.normSquared());
		ekCamera.rotateAround(rot.normalize(), [0, 0, 0]);
	} else {
		var resized = eventPan.displacement.times(0.01);
	
		updateCameraAxes();
		var translation = cameraX.times(-resized.x)
			.plus(cameraY.times(-resized.y));
	
		ekCamera.position = ekCamera.position.plus(translation);
	}
}

addCallbackForEvent(myPanCallback, "pan");


function myPinchCallback(eventPinch) {
	updateCameraAxes();
	var translation = cameraZ.times((1 - (eventPinch.scale)) * 5);
	ekCamera.position = ekCamera.position.plus(translation);
}

addCallbackForEvent(myPinchCallback, "pinch");

function myRotationCallback(eventRotation) {
	updateCameraAxes();
	var rotZ = new EKVector4(cameraZ.x, cameraZ.y, cameraZ.z,
							 eventRotation.angle);
	ekCamera.rotateAround(rotZ, [0, 0, 0]);
}

addCallbackForEvent(myRotationCallback, "rotation");


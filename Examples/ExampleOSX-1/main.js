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

function someCallback(event) {
	print(event)
}

addCallbackForEvent(someCallback, "screen input");
addCallbackForEvent(someCallback, "screen input continuous");


function myPanCallback(eventPan) {
	if (eventPan.touches == 1) {
		//		// Object translation
		//		var nodes = ekScene.objectsInCoordinate(eventPan.position);
		//
		//		if (typeof nodes[0] != 'undefined') {
		//			var object = nodes[0];
		//
		//			var resized = eventPan.displacement.times(0.01);
		//
		//			updateCameraAxes();
		//			var translation = cameraX.times(resized.x)
		//				.plus(cameraY.times(resized.y));
		//
		//			var distance = object.position.minus(ekCamera.position);
		//			var ratio = distance.norm() / 7.5;
		//
		//			var resizedTranslation = translation.times(ratio);
		//
		//			object.position = object.position.plus(resizedTranslation);
		//		}

		// Object translation snapped to axes

		var nodes = ekScene.objectsInCoordinate(eventPan.position);

		if (typeof nodes[0] != 'undefined') {

			var item = nodes[0];

			updateCameraAxes();

			var resized = eventPan.displacement.times(0.01);
			var translation = cameraX.times(resized.x)
			.plus(cameraY.times(resized.y));

			var xDot = Math.abs(cameraZ.dot(x));
			var yDot = Math.abs(cameraZ.dot(y));
			var zDot = Math.abs(cameraZ.dot(z));

			var projection;

			if (xDot >  yDot && xDot > zDot) {
				projection = EKVector3(0, translation.y, translation.z);
			}
			else if (yDot > zDot) {
				projection = EKVector3(translation.x, 0, translation.z);
			}
			else {
				projection = EKVector3(translation.x, translation.y, 0);
			}

			var distance = item.position.minus(ekCamera.position);
			var ratio = distance.norm() / 7.5;

			var resizedProjection = projection.times(ratio);

			item.position = item.position.plus(resizedProjection);
		}
		else {
			// Trackball
			var resized = eventPan.displacement.times(0.01);

			updateCameraAxes();
			var axis = cameraX.times(resized.y)
			.plus(cameraY.times(-resized.x));

			var rot = new EKVector4(axis.x, axis.y, axis.z, resized.normSquared());
			ekCamera.rotateAround(rot.normalize(), [0, 0, 0]);
		}
	} else {
		// Camera translation
		var resized = eventPan.displacement.times(0.01);

		updateCameraAxes();
		var translation = cameraX.times(-resized.x)
		.plus(cameraY.times(-resized.y));

		ekCamera.position = ekCamera.position.plus(translation);
	}
}

addCallbackForEvent(myPanCallback, "pan");


function myPinchCallback(eventPinch) {
	var nodes = ekScene.objectsInCoordinate(eventPinch.position);

	if (typeof nodes[0] != 'undefined') {
		var item = nodes[0];
		item.scale = item.scale.times(eventPinch.scale);
	}
	else {
		updateCameraAxes();
		var translation = cameraZ.times((1 - (eventPinch.scale)) * 5);
		ekCamera.position = ekCamera.position.plus(translation);
	}
}

addCallbackForEvent(myPinchCallback, "pinch");

function myRotationCallback(eventRotation) {
	var nodes = ekScene.objectsInCoordinate(eventRotation.position);

	if (typeof nodes[0] != 'undefined') {
		var item = nodes[0];
		updateCameraAxes();
		item.rotate([cameraZ.x, cameraZ.y, cameraZ.z, -eventRotation.angle]);
	} else {
		updateCameraAxes();
		var rotZ = new EKVector4(cameraZ.x, cameraZ.y, cameraZ.z,
								 eventRotation.angle);
		ekCamera.rotateAround(rotZ, [0, 0, 0]);
	}
}

addCallbackForEvent(myRotationCallback, "rotation");

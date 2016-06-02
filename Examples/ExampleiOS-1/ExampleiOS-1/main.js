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
//		// Trackball
//		var resized = eventPan.displacement.times(0.01);
//
//		updateCameraAxes();
//		var axis = cameraX.times(resized.y)
//			.plus(cameraY.times(-resized.x));
//
//		var rot = new EKVector4(axis.x, axis.y, axis.z, resized.normSquared());
//		ekCamera.rotateAround(rot.normalize(), [0, 0, 0]);

		// Object translation
		var nodes = ekScene.objectsInCoordinate(eventPan.position);

		if (typeof nodes[0] != 'undefined') {
			var object = nodes[0];

			var resized = eventPan.displacement.times(0.01);

			updateCameraAxes();
			var translation = cameraX.times(resized.x)
				.plus(cameraY.times(resized.y));

			var distance = object.position.minus(ekCamera.position);
			var ratio = distance.norm() / 7.5;

			var resizedTranslation = translation.times(ratio);

			object.position = object.position.plus(resizedTranslation);
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
	updateCameraAxes();
	var translation = cameraZ.times((1 - (eventPinch.scale)) * 5);
	ekCamera.position = ekCamera.position.plus(translation);
}

addCallbackForEvent(myPinchCallback, "pinch");

function myRotationCallback(eventRotation) {
	var nodes = ekScene.objectsInCoordinate(eventRotation.position);

	if (typeof nodes[0] != 'undefined') {
		var item = nodes[0];
		updateCameraAxes();
		item.rotate([cameraZ.x, cameraZ.y, cameraZ.z, -eventRotation.angle]);
	}
//	updateCameraAxes();
//	var rotZ = new EKVector4(cameraZ.x, cameraZ.y, cameraZ.z,
//							 eventRotation.angle);
//	ekCamera.rotateAround(rotZ, [0, 0, 0]);
}

addCallbackForEvent(myRotationCallback, "rotation");

//function itemTranslationActionSnappedToAxes(items, translation) {
//	if (typeof items[0] != 'undefined') {
//
//		var item = itemForActions(items[0]);
//
//		updateCameraAxes();
//
//		var resized = translation.times(0.01);
//		var translation = cameraX.times(resized.x)
//			.plus(cameraY.times(resized.y));
//
//		var xDot = Math.abs(cameraZ.dot(x));
//		var yDot = Math.abs(cameraZ.dot(y));
//		var zDot = Math.abs(cameraZ.dot(z));
//
//		var projection;
//
//		if (xDot >  yDot && xDot > zDot) {
//			projection = translation.setNewX(0);
//		}
//		else if (yDot > zDot) {
//			projection = translation.setNewY(0);
//		}
//		else {
//			projection = translation.setNewZ(0);
//		}
//
//		var distance = item.position.minus(Camera.position);
//		var ratio = distance.norm() / 7.5;
//
//		var resizedProjection = projection.times(ratio);
//
//		item.position = item.position.plus(resizedProjection);
//	}
//}
//TriggerManager.registerAction(itemTranslationActionSnappedToAxes);
//
//function itemScaleAction(items, scale) {
//	if (typeof items[0] != 'undefined') {
//		var item = itemForActions(items[0]);
//		item.scale = item.scale.times(scale);
//	}
//}
//TriggerManager.registerAction(itemScaleAction);
//
//function zoomCameraAction(items, scale) {
//	updateCameraAxes();
//	var translation = cameraZ.times((1 - (scale)) * 5);
//	Camera.position = Camera.position.plus(translation);
//}
//TriggerManager.registerAction(zoomCameraAction);
//
//function itemRotationAction(items, angle) {
//	if (typeof items[0] != 'undefined') {
//		var item = itemForActions(items[0]);
//		updateCameraAxes();
//		item.rotate({"axis":cameraZ, "a":angle});
//	}
//}
//TriggerManager.registerAction(itemRotationAction);
//
//function sceneRotationAction(items, angle) {
//	updateCameraAxes();
//	var rotZ = Rotation.create([cameraZ, -angle]);
//	Camera.rotateAround(rotZ, origin);
//}
//TriggerManager.registerAction(sceneRotationAction);
//
//////////////////////////////////////////////////////////////////////////////////
//
//function itemIdentity(item) {
//	return item;
//}
//
//function topItem(item) {
//	while (item != item.parent && typeof item.parent != 'undefined') {
//		item = item.parent;
//	}
//	return item;
//}
//
//function templateBase(item) {
//	while (!item.isTemplateBase && typeof item.parent != 'undefined') {
//		item = item.parent;
//	}
//	return item;
//}
//
//var itemForActions = itemIdentity;
//
//
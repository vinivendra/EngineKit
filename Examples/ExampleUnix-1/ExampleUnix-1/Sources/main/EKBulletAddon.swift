import CBullet

var ekPhysicsAddon: EKPhysicsAddon? = nil

public class EKBulletAddon: EKAddon, EKPhysicsAddon, EKTimerDelegate {
	public func setup(onEngine engine: EKEngine) {
		ekPhysicsAddon = self

		cBulletInit()

		let timer = EKTimer(duration: Double.infinity, repeats: true)
		timer.delegate = self
		timer.start()
	}

	deinit {
		for object in EKGLObject.allObjects {
			if object.physicsComponent is EKBulletComponent {
				object.physicsComponent = nil
			}
		}

		cBulletDestroy()
	}

	public func createPhysicsComponent(fromObject object: EKGLObject)
		-> EKPhysicsComponent
	{
		return EKBulletComponent(object: object)
	}

	//
	public func timerHasUpdated(_ timer: EKTimer,
	                     currentTime: Double,
	                     deltaTime: Double) {
		cBulletStep(deltaTime)

		for object in EKGLObject.allObjects {
			if let physicsComponent = object.physicsComponent {
				physicsComponent.update(object: object)
			}
		}
	}

	public func timerHasFinished(_ timer: EKTimer) {}

	public func timerWillRepeat(_ timer: EKTimer) {}
}

public protocol EKPhysicsComponent {
	func update(object: EKGLObject)
}

public protocol EKPhysicsAddon: EKAddon {
	func createPhysicsComponent(fromObject: EKGLObject)
		-> EKPhysicsComponent
}

public class EKBulletComponent: EKPhysicsComponent {
	let cBody: CPhysicsBody

	init(object: EKGLObject) {
		let p = object.position
		let r = object.rotation
		self.cBody = cBulletCreateBody(p.x, p.y, p.z,
		                               r.x, r.y, r.z, r.w)
	}

	public func update(object: EKGLObject) {
		var px: Double = 0.0
		var py: Double = 0.0
		var pz: Double = 0.0
		var rx: Double = 0.0
		var ry: Double = 0.0
		var rz: Double = 0.0
		var rw: Double = 0.0

		cBulletGetTransform(cBody,
		                    &px, &py, &pz,
		                    &rx, &ry, &rz, &rw)

		object.position = EKVector3(x: px, y: py, z: pz)
	}

	//
	deinit {
		destroyCData()
	}

	func destroyCData() {
		cBulletDestroyObject(cBody)
	}
}

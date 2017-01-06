import CBullet

public class EKBulletAddon: EKAddon, EKTimerDelegate {
	let object: EKGLObject

	init(object: EKGLObject) {
		self.object = object
	}

	public func setup(onEngine engine: EKEngine) {
		cBulletInit()

		let timer = EKTimer(duration: Double.infinity, repeats: true)
		timer.delegate = self
		timer.start()
	}

	deinit {
		cBulletDestroy()
	}

	//
	public func timerHasUpdated(_ timer: EKTimer,
	                     currentTime: Double,
	                     deltaTime: Double) {
		cBulletStep(deltaçime)

		object.position = EKVector3(x: object.position.x,
		                            y: cBulletGetHeight() / 10.0,
		                            z: object.position.z)
		print("y: \(object.position.y)")
	}

	public func timerHasFinished(_ timer: EKTimer) {}

	public func timerWillRepeat(_ timer: EKTimer) {}
}

import SceneKit
import JavaScriptCore

protocol SphereExport: JSExport {
	var radius: CGFloat { get set }
}

extension SCNSphere: SphereExport {}

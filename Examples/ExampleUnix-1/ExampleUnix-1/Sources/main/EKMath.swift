#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

func EKToRadians(_ degrees: Double) -> Double {
	return degrees / 180 * Double(M_PI)
}

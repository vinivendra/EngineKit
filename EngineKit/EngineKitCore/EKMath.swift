#if os(Linux)
	import Glibc
#else
	import Darwin
#endif

func EKToRadians(degrees: Double) -> Double {
	return degrees / 180 * Double(M_PI)
}

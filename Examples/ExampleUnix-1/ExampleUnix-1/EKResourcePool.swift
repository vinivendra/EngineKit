public struct EKResourcePool<T>: SequenceType {
	typealias Element = T

	private var resources = [EKResource<T>(value: nil, next: 0)]

	private var arrayCapacity = 1
	public var count = 0

	private var isFull: Bool {
		get {
			return firstAvailableIndex == 0
		}
	}

	private var firstAvailableIndex: Int {
		get {
			return resources[0].next
		}
		set {
			resources[0].next = newValue
		}
	}

	public func generate() -> AnyGenerator<T> {
		var index = 1
		return AnyGenerator {
			while index < self.arrayCapacity {
				if let value = self.resources[index].value {
					defer { index = index + 1 }
					return value
				}
			}
			return nil
		}
	}

	//
	public mutating func addResource(value: T) {
		_ = addResourceAndGetIndex(value)
	}

	public mutating func addResourceAndGetIndex(value: T) -> Int {
		let newResource = EKResource(value: value, next: 0)
		count = count + 1
		if isFull {
			resources.append(newResource)
			arrayCapacity = arrayCapacity + 1
			return count
		} else {
			let firstEmptySlot = resources[firstAvailableIndex]
			let nextEmptySlotIndex = firstEmptySlot.next
			resources[firstAvailableIndex] = newResource
			defer { firstAvailableIndex = nextEmptySlotIndex }
			return firstAvailableIndex
		}
	}

	public mutating func deleteResource(atIndex indexToDelete: Int) {
		resources[indexToDelete].value = nil
		resources[indexToDelete].next = firstAvailableIndex
		firstAvailableIndex = indexToDelete

		if count < arrayCapacity / 3 {
			let newCapacity = arrayCapacity / 2 + 1
			let emptyResource = EKResource<T>(value: nil, next: 0)
			var newArray = [EKResource<T>](count: newCapacity,
			                               repeatedValue: emptyResource)
			var j = 1
			for resource in resources {
				if let value = resource.value {
					newArray[j].value = value
					j = j + 1
				}
			}
			for i in j..<(newCapacity - 1) {
				newArray[i].next = i + 1
			}
			newArray[newCapacity - 1].next = 0
		}
	}
}

public extension EKResourcePool where T: Equatable {
	public mutating func deleteResource(value: T) {
		var index: Int! = nil
		for (i, resource) in resources.enumerate() {
			if resource.value == value {
				index = i
				break
			}
		}
		deleteResource(atIndex: index)
	}
}

private struct EKResource<T> {
	var value: T?
	var next: Int
}

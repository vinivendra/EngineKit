public protocol AsyncConnection: AsyncStream {
    func open(timingOut deadline: Double, completion: ((Void) throws -> AsyncConnection) -> Void) throws
}

extension AsyncConnection {
    public func open(completion: ((Void) throws -> AsyncConnection) -> Void) throws {
        try open(timingOut: .never, completion: completion)
    }
}

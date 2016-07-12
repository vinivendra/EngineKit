public protocol AsyncURIConnection: AsyncConnection {
    init(to uri: URI) throws
    var uri: URI { get }
}

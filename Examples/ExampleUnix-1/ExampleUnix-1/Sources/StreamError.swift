public enum StreamError: ErrorProtocol {
    case closedStream(data: Data)
    case timeout(data: Data)
}

public actor Server {
    @discardableResult
    public func readLine(handler: @escaping Handler) async -> Self {
        self.handler = handler
        return self
    }
    
    public typealias Handler = (String) async throws -> Void
    
    lazy var handler: Handler = { _ in }
    
    public init() { }
    
    public func start() async throws {
        while true {
            guard let string = Swift.readLine() else { return }
            try await self.handler(string)
        }
    }
}

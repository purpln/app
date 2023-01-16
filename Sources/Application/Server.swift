public actor Server {
    @discardableResult
    public func onReadLine(_ handler: @escaping ReadLineHandler) async -> Self {
        self.readLineHandler = handler
        return self
    }
    
    public typealias ReadLineHandler = (String) async throws -> Void
    
    lazy var readLineHandler: ReadLineHandler = handleReadLine
    
    func handleReadLine(_ string: String) async throws { }
    
    public init() { }
    
    public func start() async throws {
        while true {
            guard let string = readLine() else { return }
            try await self.readLineHandler(string)
        }
    }
}

import Loop

struct Core {
    private var application: any Application
    
    mutating func execute() async throws {
        await loop.run()
    }
    
    init<T>(_ t: T.Type) async throws where T: Application {
        application = try await T()
    }
}

import Architecture

@main
struct App: Application {
    var scenes: [any Scene] { [
        
    ] }
    
    init() async throws {
        asyncTask {
            let server = Server()
            await server.onReadLine { string in
                print(string)
            }
            try await server.start()
        }
    }
}

struct View: Scene {
    //func execute() async throws { }
}

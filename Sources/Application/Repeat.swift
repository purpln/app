import Architecture

struct Repeat: Scene {
    func execute() async throws {
        repeat {
            print("tick")
            try? await Task.sleep(for: .seconds(60))
        } while !Task.isCancelled
    }
}

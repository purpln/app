import Architecture
import Link

struct Test: Scene {
    func execute() async throws {
        let url = Link(string: "")
        print(url)
    }
}

import Platform
import Loop

private var socketPair: (Descriptor, Descriptor) {
    var sv: (Descriptor, Descriptor) = (.zero, .zero)
    
    withUnsafeMutableBytes(of: &sv) { buffer in
        let buffer = buffer.baseAddress?.assumingMemoryBound(to: Int32.self)
        socketpair(PF_LOCAL, SOCK_STREAM, 0, buffer)
    }
    return sv
}

struct Core {
    private var application: any Application
    
    mutating func execute() async throws {
        for scene in application.scenes as any Collection {
            guard let scene = scene as? Scene else { continue }
            Task.detached {
                do {
                    try await scene.execute()
                } catch {
                    print(error)
                }
            }
        }
        /*
        Task.detached {
            let message = "test"
            let sv = socketPair
            
            try await loop.wait(for: sv.0, event: .write, deadline: .now + .milliseconds(10))
            
            write(sv.0.rawValue, message, message.count)
            
            try await loop.wait(for: sv.1, event: .read, deadline: .now + .milliseconds(10))
            
            var buffer = [UInt8](repeating: 0, count: message.count)
            read(sv.1.rawValue, &buffer, message.count)
            
            print(String(decoding: buffer, as: UTF8.self))
            
            await loop.terminate()
        }
        
        let message = "test"
        let sv = socketPair
        
        Task.detached {
            try await loop.wait(for: sv.0, event: .write, deadline: .now + .milliseconds(10))
            
            write(sv.0.rawValue, message, message.count)
        }
        
        Task.detached {
            try await loop.wait(for: sv.1, event: .read, deadline: .now + .milliseconds(10))
            
            var buffer = [UInt8](repeating: 0, count: message.count)
            read(sv.1.rawValue, &buffer, message.count)
            
            print(String(decoding: buffer, as: UTF8.self))
            
            //await loop.terminate()
        }
        */
        await loop.run()
    }
    
    init<T>(_ t: T.Type) async throws where T: Application {
        application = try await T()
    }
}

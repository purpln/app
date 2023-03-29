public struct Window<Content>: _Scene where Content: View {
    public var content: Content
    
    public init(content: () -> Content) {
        self.content = content()
    }
}

public protocol View {
    
}

public protocol _Scene {
    
}

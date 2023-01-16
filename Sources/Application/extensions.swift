@discardableResult
public func asyncTask(
    file: StaticString = #filePath,
    line: UInt = #line,
    task: @Sendable @escaping () async throws -> Void,
    deinit: @Sendable @escaping () async throws -> Void = {}
) -> Task<Void, Error> {
    Task.detached {
        do {
            try await task()
            try await `deinit`()
        } catch {
            fail(message: String(describing: error), file: file, line: line)
            try await `deinit`()
        }
    }
}

public func fail(
    message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line)
{
    print("fail", message())
}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin.Mach
#elseif os(Linux) || os(Android) || os(FreeBSD)
import Glibc.Mach
#endif

private var timebaseInfo: mach_timebase_info = {
    var info = mach_timebase_info()
    guard mach_timebase_info(&info) == 0, info.denom > 0 else { fatalError("no monotomic timing") }
    return info
}()

public var nanoseconds: UInt64 {
    mach_absolute_time() * UInt64(timebaseInfo.numer) / UInt64(timebaseInfo.denom)
}

public var milliseconds: Double {
    Double(nanoseconds) / 1_000_000
}


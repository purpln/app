enum Signal: Int, CustomStringConvertible {
    case hup = 1, int, quit, ill, trap, iot, bus, fpe, kill, usr1, segv, usr2, pipe, alrm, term, stkflt, chld, contv, stop, tstp, ttin, ttou, urg, xcpu, xfsz, vtalrm, prof, winch, io, pwr
    
    var description: String {
        switch self {
        case .hup: return "HUP" //Hangup (POSIX)
        case .int: return "INT" //Terminal interrupt (ANSI)
        case .quit: return "QUIT" //Terminal quit (POSIX)
        case .ill: return "ILL" //Illegal instruction (ANSI)
        case .trap: return "TRAP" //Trace trap (POSIX)
        case .iot: return "IOT" //IOT Trap (4.2 BSD)
        case .bus: return "BUS" //BUS error (4.2 BSD)
        case .fpe: return "FPE" //Floating point exception (ANSI)
        case .kill: return "KILL" //Kill(can't be caught or ignored) (POSIX)
        case .usr1: return "USR1" //User defined signal 1 (POSIX)
        case .segv: return "SEGV" //Invalid memory segment access (ANSI)
        case .usr2: return "USR2" //User defined signal 2 (POSIX)
        case .pipe: return "PIPE" //Write on a pipe with no reader, Broken pipe (POSIX)
        case .alrm: return "ALRM" //Alarm clock (POSIX)
        case .term: return "TERM" //Termination (ANSI)
        case .stkflt: return "STKFLT" //Stack fault
        case .chld: return "CHLD" //Child process has stopped or exited, changed (POSIX)
        case .contv: return "CONTv" //Continue executing, if stopped (POSIX)
        case .stop: return "STOP" //Stop executing(can't be caught or ignored) (POSIX)
        case .tstp: return "TSTP" //Terminal stop signal (POSIX)
        case .ttin: return "TTIN" //Background process trying to read, from TTY (POSIX)
        case .ttou: return "TTOU" //Background process trying to write, to TTY (POSIX)
        case .urg: return "URG" //Urgent condition on socket (4.2 BSD)
        case .xcpu: return "XCPU" //CPU limit exceeded (4.2 BSD)
        case .xfsz: return "XFSZ" //File size limit exceeded (4.2 BSD)
        case .vtalrm: return "VTALRM" //Virtual alarm clock (4.2 BSD)
        case .prof: return "PROF" //Profiling alarm clock (4.2 BSD)
        case .winch: return "WINCH" //Window size change (4.3 BSD, Sun)
        case .io: return "IO" //I/O now possible (4.2 BSD)
        case .pwr: return "PWR" //Power failure restart (System V)
        }
    }
}


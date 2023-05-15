import Architecture
import Internal

@main
struct App: Application {
    var scenes: [any Scene] { [
        Server(),
        Client(),
    ] }
}

//CHECKSUM_KEY = "QVD1lRbTuBmTZrcsS2KnL6p550ZgpscuTAFqRFBfvUfNXpjQfuV82OprI65fujAwFIpHFSpfgEFKWlIFRbJczJBSeRLwuM7AHU9hvmg2M9V5IqKuXLckDNhEERl54bk8"
//ONLINE_KEY = "gcHuOYYUTJangeREXoWR4kCDT4Qb4lK490E722U96rIDa0aQxzgwD0ZPplI7LcO2pNOvoitWJowyHj2asv4oqD42AWHAR8k6HqMTsSCKGYJ5eKfI61gtswR8O2r59T4f"
//LOGIN_URL = "https://asi.bike/frontdoor/bacdoorlogin.php"

//verbose_polling_settings_key string (bool)
//bacdoor_user_name_settings_key string
//bacdoor_user_token_settings_key string
//bacdoor_user_last_login_settings_key string (datetime)
//bacdoor_user_access_settings_key string (int)
//bacdoor_user_checksum_settings_key string
//bacdoor_layout_selection_settings_key string
//bacdoor_layout_profile_settings_key string

import struct Foundation.URL
import struct Link.Link

struct View: Scene {
    func execute() async throws {
        var array: [String] = [String](repeating: "value", count: 1000)
        let count: Int = array.count
        var index: Int = 0
        var executing: Bool = true
        
        repeat {
            print("remaining:", count - index)
            print(array[index])
            let character = getch()
            let string = String(UnicodeScalar(character))
            print("")
            switch string {
            case "y": print("yes")
            case "n": print("no")
            case "e": print("exit")
            default: print("not valid")
            }
            //print("\n")
            //print("get char:", string)
            index += 1
            
            //print("\n")
        } while executing || count == 0
        
        //let url = URL(string: "")
        //let link = Link(string: "http://purpln:wersdfxcv@localhost:4000/path/to?query=value&q=v#fragment")
        
        /*
        let server = Server()
        await server.readLine { string in
            print(string)
        }
        try await server.start()
         */
    }
}

import class Foundation.FileHandle
import Darwin.C

extension FileHandle {
    func enableRawMode() -> termios {
        var raw = termios()
        tcgetattr(self.fileDescriptor, &raw)

        let original = raw
        raw.c_lflag &= ~UInt(ECHO | ICANON)
        tcsetattr(self.fileDescriptor, TCSADRAIN, &raw)
        return original
    }

    func restoreRawMode(originalTerm: termios) {
        var term = originalTerm
        tcsetattr(self.fileDescriptor, TCSADRAIN, &term)
    }
}

func getch() -> UInt8 {
    let handle = FileHandle.standardInput
    let term = handle.enableRawMode()
    defer { handle.restoreRawMode(originalTerm: term) }

    var byte: UInt8 = 0
    read(handle.fileDescriptor, &byte, 1)
    return byte
}

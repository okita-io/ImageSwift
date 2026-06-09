#if os(macOS)
import SwiftUI

@main
struct ImageSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            ImageEditorView()
        }
        .windowResizability(.contentSize)
    }
}
#else
@main
struct ImageSwiftApp {
    static func main() {
        print("ImageSwift requires macOS 13 or later.")
    }
}
#endif

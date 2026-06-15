#if os(macOS)
import SwiftUI
import AppKit
import ImageSwiftLib

@main
struct ImageSwiftApp: App {
    var body: some Scene {
        WindowGroup {
            ImageEditorView()
                .onAppear {
                    // When launched via `swift run`, the terminal retains keyboard focus.
                    // This steals it back so text fields are immediately interactive.
                    NSApp.activate(ignoringOtherApps: true)
                }
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
#Preview{
    ImageSwiftApp()
}
#endif

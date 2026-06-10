#if os(macOS)
import SwiftUI
import ImageSwiftLib

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
#Preview{
    ImageSwiftApp()
}
#endif

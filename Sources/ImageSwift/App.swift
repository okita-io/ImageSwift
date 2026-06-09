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

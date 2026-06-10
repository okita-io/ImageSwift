#if os(macOS)
import Foundation
import UniformTypeIdentifiers

struct FileItem: Identifiable, Hashable {
    var id: URL { url }
    let url: URL
    let name: String
    let isDirectory: Bool
    
    init(url: URL, isDirectory: Bool) {
        self.url = url
        self.name = url.lastPathComponent
        self.isDirectory = isDirectory
    }
}

@MainActor
final class DirectoryBrowserViewModel: ObservableObject {
    @Published var currentDirectory: URL
    @Published var items: [FileItem] = []
    @Published var errorMessage: String?
    
    init() {
        self.currentDirectory = FileManager.default.homeDirectoryForCurrentUser
        loadCurrentDirectory()
    }
    
    func navigateTo(url: URL) {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue {
            currentDirectory = url
            loadCurrentDirectory()
        }
    }
    
    func navigateUp() {
        let parent = currentDirectory.deletingLastPathComponent()
        // Avoid infinite loop or navigating past the root view if they are equal
        if parent != currentDirectory {
            currentDirectory = parent
            loadCurrentDirectory()
        }
    }
    
    func loadCurrentDirectory() {
        errorMessage = nil
        do {
            let fileManager = FileManager.default
            let contents = try fileManager.contentsOfDirectory(
                at: currentDirectory,
                includingPropertiesForKeys: [.isDirectoryKey, .isHiddenKey],
                options: [.skipsHiddenFiles]
            )
            
            var newItems: [FileItem] = []
            for url in contents {
                var isDirectoryValue: AnyObject?
                do {
                    try (url as NSURL).getResourceValue(&isDirectoryValue, forKey: .isDirectoryKey)
                } catch {
                    continue
                }
                
                let isDirectory = (isDirectoryValue as? Bool) ?? false
                if isDirectory || isSupportedImage(url: url) {
                    newItems.append(FileItem(url: url, isDirectory: isDirectory))
                }
            }
            
            // Sort directories first, then images, both sorted case-insensitively
            self.items = newItems.sorted { a, b in
                if a.isDirectory != b.isDirectory {
                    return a.isDirectory
                }
                return a.name.localizedStandardCompare(b.name) == .orderedAscending
            }
        } catch {
            errorMessage = error.localizedDescription
            self.items = []
        }
    }
    
    private func isSupportedImage(url: URL) -> Bool {
        if let type = UTType(filenameExtension: url.pathExtension) {
            return type.conforms(to: .image)
        }
        let extensions = ["png", "jpg", "jpeg", "heic", "webp", "gif", "tiff", "bmp"]
        return extensions.contains(url.pathExtension.lowercased())
    }
}
#endif

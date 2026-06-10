#if os(macOS)
import SwiftUI

struct DirectoryBrowserView: View {
    @StateObject private var viewModel = DirectoryBrowserViewModel()
    let onSelectImage: (URL) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            pathHeader
            
            Divider()
            
            if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage)
            } else if viewModel.items.isEmpty {
                emptyView
            } else {
                fileList
            }
        }
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    // MARK: - Subviews
    
    private var pathHeader: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Button(action: {
                    viewModel.navigateUp()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.body.bold())
                        .frame(width: 20, height: 20)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .disabled(viewModel.currentDirectory.path == "/")
                .help("Go to parent directory")
                
                Text(viewModel.currentDirectory.lastPathComponent.isEmpty ? "/" : viewModel.currentDirectory.lastPathComponent)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                Spacer()
                
                Button(action: {
                    viewModel.loadCurrentDirectory()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.body)
                        .frame(width: 20, height: 20)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .help("Refresh directory contents")
            }
            
            Text(abbreviatedPath(viewModel.currentDirectory.path))
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .truncationMode(.head)
                .help(viewModel.currentDirectory.path)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.3))
    }
    
    private var fileList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 2) {
                ForEach(viewModel.items) { item in
                    DirectoryRow(item: item) {
                        if item.isDirectory {
                            viewModel.navigateTo(url: item.url)
                        } else {
                            onSelectImage(item.url)
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "folder.badge.questionmark")
                .font(.system(size: 28))
                .foregroundColor(.secondary)
            Text("No folders or images")
                .font(.callout)
                .foregroundColor(.secondary)
            Text("This folder does not contain any subdirectories or supported image files.")
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 28))
                .foregroundColor(.secondary)
            Text("Access Error")
                .font(.callout)
                .foregroundColor(.secondary)
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button("Retry") {
                viewModel.loadCurrentDirectory()
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Helpers
    
    private func abbreviatedPath(_ path: String) -> String {
        let homePath = FileManager.default.homeDirectoryForCurrentUser.path
        if path == homePath {
            return "~"
        } else if path.hasPrefix(homePath) {
            let relative = path.replacingOccurrences(of: homePath, with: "~")
            return relative
        }
        return path
    }
}

struct DirectoryRow: View {
    let item: FileItem
    let action: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: item.isDirectory ? "folder.fill" : "photo")
                    .foregroundColor(item.isDirectory ? .accentColor : .secondary)
                    .font(.system(size: 14))
                
                Text(item.name)
                    .foregroundColor(.primary)
                    .font(.callout)
                    .lineLimit(1)
                    .truncationMode(.middle)
                
                Spacer()
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .contentShape(Rectangle())
            .background(isHovering ? Color.secondary.opacity(0.12) : Color.clear)
            .cornerRadius(6)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
#endif

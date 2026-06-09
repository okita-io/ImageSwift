#if os(macOS)
import AppKit
import Combine
import CoreImage
import Foundation

@MainActor
final class ImageEditorViewModel: ObservableObject {

    // MARK: - Published state

    @Published var previewImage: NSImage?
    @Published var widthText: String = ""
    @Published var heightText: String = ""
    @Published var selectedFormat: ExportFormat = .png
    @Published var errorMessage: String?
    @Published var isProcessing: Bool = false

    // MARK: - Private

    private var sourceImage: CIImage?
    private let resizer = ImageResizer()
    private let exporter = ImageExporter()
    private let context = CIContext(options: [.useSoftwareRenderer: false])

    // MARK: - Loading

    func load(from url: URL) {
        guard let ciImage = CIImage(contentsOf: url) else {
            errorMessage = "Could not load image from \(url.lastPathComponent)."
            return
        }
        sourceImage = ciImage
        widthText = String(Int(ciImage.extent.width))
        heightText = String(Int(ciImage.extent.height))
        updatePreview(from: ciImage)
        errorMessage = nil
    }

    // MARK: - Export

    func export() {
        guard let source = sourceImage else {
            errorMessage = "No image loaded."
            return
        }
        guard let targetWidth = Double(widthText), targetWidth > 0,
              let targetHeight = Double(heightText), targetHeight > 0 else {
            errorMessage = "Please enter valid width and height values."
            return
        }

        let panel = NSSavePanel()
        panel.allowedContentTypes = [selectedFormat.utType]
        panel.nameFieldStringValue = "export.\(selectedFormat.fileExtension)"

        guard panel.runModal() == .OK, let url = panel.url else { return }

        isProcessing = true
        errorMessage = nil

        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            do {
                let resized = try self.resizer.resize(
                    source,
                    width: CGFloat(targetWidth),
                    height: CGFloat(targetHeight)
                )
                guard let cgImage = self.context.createCGImage(resized, from: resized.extent) else {
                    await MainActor.run { self.errorMessage = "Failed to render image." }
                    return
                }
                try self.exporter.export(cgImage, to: url, format: self.selectedFormat)
                await MainActor.run { self.isProcessing = false }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isProcessing = false
                }
            }
        }
    }

    // MARK: - Helpers

    private func updatePreview(from ciImage: CIImage) {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        previewImage = NSImage(cgImage: cgImage, size: ciImage.extent.size)
    }
}
#endif

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
    @Published var isExporting: Bool = false

    // MARK: - Private

    private var sourceImage: CIImage?
    private let context = CIContext(options: [.useSoftwareRenderer: false])
    private lazy var resizer = ImageResizer(context: context)
    private let exporter = ImageExporter()

    // MARK: - Load

    func load(url: URL) {
        guard let ciImage = CIImage(contentsOf: url) else {
            errorMessage = "Could not load image from \(url.lastPathComponent)."
            return
        }
        sourceImage = ciImage
        widthText = String(Int(ciImage.extent.width))
        heightText = String(Int(ciImage.extent.height))
        updatePreview()
        errorMessage = nil
    }

    // MARK: - Preview

    func updatePreview() {
        guard let source = sourceImage else { return }
        let w = CGFloat(Int(widthText) ?? Int(source.extent.width))
        let h = CGFloat(Int(heightText) ?? Int(source.extent.height))
        guard let resized = resizer.resize(source, toWidth: w, height: h) else { return }
        guard let cgImage = context.createCGImage(resized, from: resized.extent) else { return }
        previewImage = NSImage(cgImage: cgImage, size: resized.extent.size)
    }

    // MARK: - Export

    func export() {
        guard let source = sourceImage else {
            errorMessage = "No image loaded."
            return
        }
        let w = CGFloat(Int(widthText) ?? Int(source.extent.width))
        let h = CGFloat(Int(heightText) ?? Int(source.extent.height))

        guard let resized = resizer.resize(source, toWidth: w, height: h) else {
            errorMessage = "Resize failed."
            return
        }
        guard let cgImage = context.createCGImage(resized, from: resized.extent) else {
            errorMessage = "Could not render image."
            return
        }

        let panel = NSSavePanel()
        panel.allowedContentTypes = []
        panel.nameFieldStringValue = "export.\(selectedFormat.fileExtension)"
        panel.canCreateDirectories = true

        guard panel.runModal() == .OK, let url = panel.url else { return }

        isExporting = true
        Task {
            do {
                try exporter.export(cgImage, to: url, format: selectedFormat)
                errorMessage = nil
            } catch {
                errorMessage = error.localizedDescription
            }
            isExporting = false
        }
    }
}

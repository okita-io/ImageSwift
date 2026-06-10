#if os(macOS)
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

enum ExportError: Error, LocalizedError {
    case cannotCreateDestination
    case finalizationFailed

    var errorDescription: String? {
        switch self {
        case .cannotCreateDestination: return "Could not create an image destination for the given URL."
        case .finalizationFailed: return "Failed to write the image to disk."
        }
    }
}

/// Export format supported by the app.
enum ExportFormat: String, CaseIterable, Identifiable {
    case png  = "PNG"
    case jpeg = "JPEG"
    case heic = "HEIC"
    case webp = "WebP"

    var id: String { rawValue }

    /// The UTType used by Image I/O for this format.
    var utType: UTType {
        switch self {
        case .png:  return .png
        case .jpeg: return .jpeg
        case .heic: return UTType(filenameExtension: "heic") ?? .png
        case .webp: return UTType(filenameExtension: "webp") ?? .png
        }
    }

    /// File extension used when naming the exported file.
    var fileExtension: String {
        switch self {
        case .png:  return "png"
        case .jpeg: return "jpg"
        case .heic: return "heic"
        case .webp: return "webp"
        }
    }
}

struct ImageExporter {

    /// Writes `cgImage` to `url` in the specified `format`.
    func export(_ cgImage: CGImage, to url: URL, format: ExportFormat) throws {
        let uti = format.utType.identifier as CFString
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, uti, 1, nil) else {
            throw ExportError.cannotCreateDestination
        }
        CGImageDestinationAddImage(destination, cgImage, nil)
        guard CGImageDestinationFinalize(destination) else {
            throw ExportError.finalizationFailed
        }
    }
}
#endif

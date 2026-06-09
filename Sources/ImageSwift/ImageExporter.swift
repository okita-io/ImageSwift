import Foundation
import ImageIO
import UniformTypeIdentifiers

enum ExportError: LocalizedError {
    case cannotCreateDestination
    case finalizeFailed

    var errorDescription: String? {
        switch self {
        case .cannotCreateDestination: "Could not create export destination."
        case .finalizeFailed: "Failed to write image to disk."
        }
    }
}

/// Exports a CGImage to disk using Image I/O (CGImageDestination).
struct ImageExporter {

    func export(_ cgImage: CGImage, to url: URL, format: ExportFormat) throws {
        let uti = format.uti
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, uti, 1, nil) else {
            throw ExportError.cannotCreateDestination
        }
        CGImageDestinationAddImage(destination, cgImage, nil)
        guard CGImageDestinationFinalize(destination) else {
            throw ExportError.finalizeFailed
        }
    }
}

enum ExportFormat: String, CaseIterable, Identifiable {
    case png  = "PNG"
    case jpeg = "JPEG"
    case heic = "HEIC"
    case webp = "WebP"

    var id: String { rawValue }

    var fileExtension: String {
        switch self {
        case .png:  "png"
        case .jpeg: "jpg"
        case .heic: "heic"
        case .webp: "webp"
        }
    }

    var uti: CFString {
        switch self {
        case .png:  UTType.png.identifier as CFString
        case .jpeg: UTType.jpeg.identifier as CFString
        case .heic: UTType.heic.identifier as CFString
        case .webp: "org.webmproject.webp" as CFString
        }
    }
}

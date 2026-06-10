#if os(macOS)
import CoreImage
import Foundation

enum ResizeError: Error, LocalizedError {
    case filterUnavailable
    case outputUnavailable

    var errorDescription: String? {
        switch self {
        case .filterUnavailable: return "CILanczosScaleTransform filter is unavailable."
        case .outputUnavailable: return "The filter did not produce an output image."
        }
    }
}

struct ImageResizer {

    /// Resizes `image` so that it fits within `targetWidth` × `targetHeight`
    /// while preserving the original aspect ratio.
    func resize(_ image: CIImage, width targetWidth: CGFloat, height targetHeight: CGFloat) throws -> CIImage {
        let sourceWidth = image.extent.width
        let sourceHeight = image.extent.height

        guard sourceWidth > 0, sourceHeight > 0 else { return image }

        let scaleX = targetWidth / sourceWidth
        let scaleY = targetHeight / sourceHeight
        let scale = min(scaleX, scaleY)

        guard let filter = CIFilter(name: "CILanczosScaleTransform") else {
            throw ResizeError.filterUnavailable
        }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(scale, forKey: kCIInputScaleKey)
        filter.setValue(1.0, forKey: kCIInputAspectRatioKey)

        guard let output = filter.outputImage else {
            throw ResizeError.outputUnavailable
        }
        return output
    }
}
#endif

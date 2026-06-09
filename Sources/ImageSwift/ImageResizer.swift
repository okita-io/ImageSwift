import CoreImage
import Foundation

/// Resizes a CIImage using the high-quality Lanczos algorithm.
struct ImageResizer {

    private let context: CIContext

    init(context: CIContext) {
        self.context = context
    }

    /// Returns a resized CIImage that fits within the given dimensions while preserving aspect ratio.
    func resize(_ image: CIImage, toWidth width: CGFloat, height: CGFloat) -> CIImage? {
        let originalWidth = image.extent.width
        let originalHeight = image.extent.height
        guard originalWidth > 0, originalHeight > 0 else { return nil }

        let scaleX = width / originalWidth
        let scaleY = height / originalHeight
        let scale = min(scaleX, scaleY)

        guard let filter = CIFilter(name: "CILanczosScaleTransform") else { return nil }
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(scale, forKey: kCIInputScaleKey)
        filter.setValue(1.0, forKey: kCIInputAspectRatioKey)
        return filter.outputImage
    }
}

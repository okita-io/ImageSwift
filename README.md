# ImageSwift 🖼️⚡

A super lightweight, high-performance image editing and processing utility for macOS, written natively in Swift and SwiftUI.

ImageSwift is designed from the ground up to be fast, simple, and resource-efficient by leveraging native macOS technologies (Core Image, Metal-accelerated CIContext, and ImageIO) rather than heavy third-party dependencies.

---

## 🌟 Key Features

- **Blazing Fast performance**: Uses Metal-accelerated `CIContext` rendering for rapid image operations.
- **High-Quality Resizing**: Employs the `CILanczosScaleTransform` Core Image filter for premium Lanczos interpolation, ensuring clean and sharp details.
- **Aspect Ratio Locking**: Intelligently scales images proportionally, ensuring they fit within target boundaries without distortion.
- **Native File Drag & Drop**: Smoothly drag image files directly from Finder into the editor's drop zone.
- **Multi-Format Export**: Export to popular web and macOS formats including **PNG**, **JPEG**, **HEIC**, and **WebP** using native Image I/O (`CGImageDestination`).
- **Modern macOS Design**: Built using SwiftUI with standard native layouts, support for dark/light appearance, and responsive window sizing.

---

## 🛠️ Architecture & Tech Stack

ImageSwift is a modular, native Swift package structured as follows:

- **SwiftUI**: Drives the native interface and standard macOS drag-and-drop integration.
- **Core Image (CIImage / CIFilter)**: Used for handling image representation, filtering, and scaling.
- **Metal Acceleration**: The `CIContext` is initialized with software rendering disabled, ensuring graphics hardware acceleration (GPU) is used for rendering.
- **ImageIO & UniformTypeIdentifiers**: Handles reading and writing standard image formats natively.
- **Swift Package Manager**: Self-contained project with zero external package dependencies.

---

## 📁 Project Structure

```
ImageSwift/
├── Package.swift               # SPM Configuration (targets macOS 13+)
├── README.md                   # Project Documentation
└── Sources/
    └── ImageSwift/
        ├── App.swift           # Application Entrypoint (@main)
        ├── ImageEditorView.swift       # SwiftUI main workspace & drop zone
        ├── ImageEditorViewModel.swift  # Coordinates loading, UI state & export Tasks
        ├── ImageResizer.swift  # Core Image Resizer (Lanczos scale transform)
        └── ImageExporter.swift # Disk-writer via ImageIO and CGImageDestination
```

---

## 🚀 Getting Started

### Prerequisites
- macOS 13.0 or later
- Xcode 14.0+ or Swift 5.8+ toolchain

### Build & Run via Terminal

You can run the application directly from your terminal using the Swift Package Manager:

```bash
# Clone the repository
git clone https://github.com/okita-io/ImageSwift.git
cd ImageSwift

# Run the app
swift run
```

### Opening in Xcode

Since the project is structured as a standard Swift Package, you can simply open the root directory in Xcode:

1. Open Xcode.
2. Select **File** -> **Open...**
3. Select the `ImageSwift` folder containing `Package.swift`.
4. Xcode will automatically resolve targets and dependencies. Select the executable target `ImageSwift` -> My Mac, then press **Cmd + R** to build and run.

---

## 🗺️ Roadmap & Planned Features

As ImageSwift grows, we plan to implement additional lightweight editing utilities:
- [ ] **Basic Rotation & Cropping**: Freeform cropping and 90-degree rotations.
- [ ] **Metadata Preservations**: Toggle options to retain/strip EXIF data when exporting.
- [ ] **Batch Processing**: Select or drop multiple images to apply bulk resizing and format conversion.
- [ ] **Color Adjustment Filters**: Simple adjustments for Brightness, Contrast, Saturation, and Exposure.

---

## 📄 License

This project is licensed under the MIT License. Feel free to use and contribute.

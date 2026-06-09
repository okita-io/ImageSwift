# ImageSwift

Super lightweight image editor for macOS built with Swift, SwiftUI, and Core Image — no external dependencies, instant boot, tiny binary.

## Features

- **Drag-and-drop loading** — drop any image file directly onto the app window to open it
- **Image resizing** — specify target width and height; uses `CILanczosScaleTransform` via Core Image for high-quality results
- **GPU-accelerated processing** — leverages `CIContext` with GPU acceleration for fast rendering
- **Multiple export formats** — export images as PNG, JPEG, HEIC, or WebP
- **Live preview** — see a preview of the loaded image before exporting
- **Zero dependencies** — uses only Apple frameworks (SwiftUI, Core Image, Image I/O)

## Requirements

- macOS 12 or later
- Xcode 14 or later (for building from source)

## Usage

1. **Open an image** — drag and drop an image file onto the drop zone in the app window.
2. **Set dimensions** — enter the desired width and height in the input fields.
3. **Choose a format** — select an export format (PNG, JPEG, HEIC, or WebP) from the picker.
4. **Export** — click the **Export** button and choose a save location. The resized image will be written to disk.

## Architecture

The app is structured as a small set of focused Swift files:

| File | Responsibility |
|------|---------------|
| `App.swift` | SwiftUI app entry point |
| `ImageEditorView.swift` | UI — drop zone, preview, dimension fields, format picker, export button |
| `ImageEditorViewModel.swift` | State — holds the loaded `CIImage`/`NSImage`, drives resize and export |
| `ImageResizer.swift` | Core Image pipeline — applies `CILanczosScaleTransform` |
| `ImageExporter.swift` | Image I/O pipeline — writes output via `CGImageDestination` |

## Building

```bash
swift build -c release
```

## License

MIT

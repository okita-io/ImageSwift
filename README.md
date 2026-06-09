# ImageSwift

Super lightweight macOS image editor built with **Swift + SwiftUI + Core Image + Image I/O**.

## Features

- Drag-and-drop image loading (or click to open)
- High-quality resize via `CILanczosScaleTransform`
- Export to PNG, JPEG, HEIC, or WebP via `CGImageDestination`
- GPU-accelerated `CIContext`
- No storyboards, no nibs, no external dependencies

## Requirements

| | |
|---|---|
| **Platform** | macOS 13 Ventura or later |
| **Toolchain** | Xcode 15+ or Swift 5.9+ on macOS |

## Project structure

```
Sources/ImageSwift/
├── App.swift                  # @main SwiftUI entry point
├── ImageEditorView.swift      # Drag-and-drop UI
├── ImageEditorViewModel.swift # State, resize, export orchestration
├── ImageResizer.swift         # Core Image Lanczos pipeline
└── ImageExporter.swift        # Image I/O (CGImageDestination) pipeline
```

## Build & run

```bash
# From the repository root on macOS:
swift run
```

Or open the package in Xcode:

```bash
open Package.swift
```

Then press **⌘R** to run.

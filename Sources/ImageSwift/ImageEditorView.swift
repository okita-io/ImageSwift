#if os(macOS)
import SwiftUI
import UniformTypeIdentifiers

struct ImageEditorView: View {

    @StateObject private var viewModel = ImageEditorViewModel()
    @State private var isDroppingOver = false

    var body: some View {
        VStack(spacing: 16) {
            dropZone
            dimensionFields
            formatPicker
            exportButton
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20)
        .frame(minWidth: 400, minHeight: 460)
    }

    // MARK: - Subviews

    private var dropZone: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isDroppingOver ? Color.accentColor : Color.secondary.opacity(0.4),
                    style: StrokeStyle(lineWidth: 2, dash: [6])
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isDroppingOver ? Color.accentColor.opacity(0.08) : Color.secondary.opacity(0.05))
                )

            if let preview = viewModel.previewImage {
                Image(nsImage: preview)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(8)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("Drop an image here")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(height: 280)
        .onDrop(of: [.fileURL], isTargeted: $isDroppingOver) { providers in
            handleDrop(providers: providers)
        }
    }

    private var dimensionFields: some View {
        HStack(spacing: 12) {
            LabeledContent("Width") {
                TextField("px", text: $viewModel.widthText)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
            }
            LabeledContent("Height") {
                TextField("px", text: $viewModel.heightText)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 80)
            }
        }
    }

    private var formatPicker: some View {
        Picker("Format", selection: $viewModel.selectedFormat) {
            ForEach(ExportFormat.allCases) { format in
                Text(format.rawValue).tag(format)
            }
        }
        .pickerStyle(.segmented)
    }

    private var exportButton: some View {
        Button {
            viewModel.export()
        } label: {
            if viewModel.isProcessing {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(0.7)
            } else {
                Text("Export")
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.previewImage == nil || viewModel.isProcessing)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Drag & Drop

    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier) { item, _ in
            guard let data = item as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            DispatchQueue.main.async {
                viewModel.load(from: url)
            }
        }
        return true
    }
}
#endif

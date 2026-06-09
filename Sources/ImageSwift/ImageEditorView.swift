import SwiftUI
import UniformTypeIdentifiers

struct ImageEditorView: View {

    @StateObject private var vm = ImageEditorViewModel()
    @State private var isDragging = false

    // Supported image UTTypes for drag-and-drop / open panel
    private let imageTypes: [UTType] = [.png, .jpeg, .heic, .webP, .image]

    var body: some View {
        VStack(spacing: 16) {
            dropZone
            if vm.previewImage != nil {
                controls
                exportRow
            }
            if let msg = vm.errorMessage {
                Text(msg)
                    .foregroundStyle(.red)
                    .font(.footnote)
            }
        }
        .padding(20)
        .frame(minWidth: 480, minHeight: 400)
    }

    // MARK: - Drop zone

    private var dropZone: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isDragging ? Color.accentColor : Color.secondary.opacity(0.4),
                    style: StrokeStyle(lineWidth: 2, dash: [6])
                )
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isDragging ? Color.accentColor.opacity(0.08) : Color.clear)
                )

            if let preview = vm.previewImage {
                Image(nsImage: preview)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(8)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text("Drop an image here or click to open")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .contentShape(Rectangle())
        .onTapGesture(perform: openFile)
        .onDrop(of: imageTypes, isTargeted: $isDragging) { providers in
            handleDrop(providers)
        }
    }

    // MARK: - Controls

    private var controls: some View {
        HStack(spacing: 12) {
            LabeledContent("Width") {
                TextField("px", text: $vm.widthText)
                    .frame(width: 72)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { vm.updatePreview() }
            }
            LabeledContent("Height") {
                TextField("px", text: $vm.heightText)
                    .frame(width: 72)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { vm.updatePreview() }
            }
            Spacer()
            Picker("Format", selection: $vm.selectedFormat) {
                ForEach(ExportFormat.allCases) { fmt in
                    Text(fmt.rawValue).tag(fmt)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 220)
        }
    }

    // MARK: - Export row

    private var exportRow: some View {
        HStack {
            Spacer()
            Button(action: vm.export) {
                if vm.isExporting {
                    ProgressView().controlSize(.small)
                } else {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.isExporting)
        }
    }

    // MARK: - Helpers

    private func openFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = imageTypes
        panel.allowsMultipleSelection = false
        guard panel.runModal() == .OK, let url = panel.url else { return }
        vm.load(url: url)
    }

    private func handleDrop(_ providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        let supported = imageTypes.compactMap(\.identifier)
        for uti in supported {
            if provider.hasItemConformingToTypeIdentifier(uti) {
                provider.loadItem(forTypeIdentifier: uti, options: nil) { item, _ in
                    guard let data = item as? Data,
                          let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                    Task { @MainActor in vm.load(url: url) }
                }
                return true
            }
        }
        return false
    }
}

import ScrechKit
import Kingfisher
import Photos

struct AppCard: View {
    private let app: Result
    
    init(_ app: Result) {
        self.app = app
    }
    
    @State private var skOverlay = false
    
    var body: some View {
        Button {
            skOverlay = true
        } label: {
            HStack {
                KFImage(URL(string: app.artworkUrl512))
                    .resizable()
                    .fade(duration: 0.25)
                    .frame(width: 64, height: 64)
                    .clipShape(.rect(cornerRadius: 16))
                
                VStack(alignment: .leading) {
                    Text(app.artistName)
                        .caption(.bold)
                    
                    Text(app.trackName)
                        .rounded()
                    
                    Text(app.bundleID)
                        .caption(design: .monospaced)
                        .secondary()
                }
            }
            .foregroundStyle(.foreground)
        }
#if !os(macOS)
        .appStoreOverlay($skOverlay, id: app.trackId)
#endif
        .contextMenu {
#if !os(macOS)
            Button("Download", systemImage: "plus.app") {
                skOverlay = true
            }
#endif
            Button("Donwload app icon", systemImage: "square.and.arrow.down") {
                Task {
                    do {
#if os(macOS)
                        _ = try await downloadAndSaveToDownloads(app.artworkUrl512)
#else
                        try await downloadAndSaveImageToPhotos(app.artworkUrl512)
#endif
                    } catch {
                        print("Failed to download app icon:", error.localizedDescription)
                    }
                }
            }
            
            Divider()
            
            Button("Copy Bundle ID", systemImage: "doc.on.doc") {
                Pasteboard.copy(app.bundleID)
            }
            
            Button("Copy App ID", systemImage: "doc.on.doc") {
                Pasteboard.copy(String(app.trackId))
            }
            
            Divider()
            
            if let url = URL(string: app.trackViewUrl) {
                Link(destination: url) {
                    Label("App Store", systemImage: "link")
                }
            }
            
            ShareLink(item: app.trackViewUrl)
        }
    }
    
    private func downloadAndSaveToDownloads(_ urlString: String) async throws -> URL {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let documentsUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let fileUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        try data.write(to: fileUrl)
        
        return fileUrl
    }
    
    func downloadAndSaveImageToPhotos(_ urlString: String) async throws {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (tempFileURL, _) = try await URLSession.shared.download(from: url)
        let data = try Data(contentsOf: tempFileURL)
        
        guard let image = UniversalImage(data: data) else {
            throw URLError(.cannotDecodeRawData)
        }
        
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        
        guard status == .authorized || status == .limited else {
            throw URLError(.noPermissionsToReadFile)
        }
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
        }
    }
}

//#Preview {
//    AppCard()
//}

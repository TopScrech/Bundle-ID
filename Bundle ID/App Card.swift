import ScrechKit
import Kingfisher

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
                        .caption()
                        .secondary()
                        .monospaced()
                }
            }
            .foregroundStyle(.foreground)
        }
#if !os(macOS)
        .appStoreOverlay($skOverlay, id: app.trackId)
#endif
        .contextMenu {
#if !os(macOS)
            Button {
                skOverlay = true
            } label: {
                Label("Download", systemImage: "plus.app")
            }
#endif
#if os(macOS)
            Button {
                Task {
                    try await downloadFile(app.artworkUrl512)
                }
            } label: {
                Label("Donwload app icon", systemImage: "square.and.arrow.down")
            }
#endif
            Divider()
            
            Button {
                Pasteboard.copy(app.bundleID)
            } label: {
                Label("Copy Bundle ID", systemImage: "doc.on.doc")
            }
            
            Button {
                Pasteboard.copy(String(app.trackId))
            } label: {
                Label("Copy App ID", systemImage: "doc.on.doc")
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
    
    @available(macOS 10.10, *)
    func downloadFile(_ urlString: String) async throws -> URL {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let documentsUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let fileUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        try data.write(to: fileUrl)
        
        return fileUrl
    }
}

//#Preview {
//    AppCard()
//}

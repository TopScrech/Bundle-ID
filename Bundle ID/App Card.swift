import SwiftUI
import Kingfisher

struct AppCard: View {
    private let app: Result
    
    init(_ app: Result) {
        self.app = app
    }
    
    @State private var uiImage: UIImage?
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
        .appStoreOverlay($skOverlay, id: app.trackId)
        .contextMenu {
            Button {
                skOverlay = true
            } label: {
                Label("Download", systemImage: "plus.app")
            }
            
            Divider()
            
            Button {
                UIPasteboard.general.string = app.bundleID
            } label: {
                Label("Copy Bundle ID", systemImage: "doc.on.doc")
            }
            
            Button {
                UIPasteboard.general.string = String(app.trackId)
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
}

//#Preview {
//    AppCard()
//}

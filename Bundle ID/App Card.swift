import SwiftUI
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
            Divider()
            
            Button {
                copy(app.bundleID)
            } label: {
                Label("Copy Bundle ID", systemImage: "doc.on.doc")
            }
            
            Button {
                copy(String(app.trackId))
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

#warning("Move to ScrechKit")
func copy(_ string: String) {
#if os(macOS)
    NSPasteboard.general.setString(string, forType: .string)
#else
    UIPasteboard.general.string = string
#endif
}

//#Preview {
//    AppCard()
//}

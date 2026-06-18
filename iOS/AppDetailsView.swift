import ScrechKit
import Kingfisher

struct AppDetailsView: View {
    private let app: Result
    
    @State private var skOverlay = false
    
    init(_ app: Result) {
        self.app = app
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    KFImage(URL(string: app.artworkUrl512))
                        .resizable()
                        .fade(duration: 0.25)
                        .frame(width: 96, height: 96)
                        .clipShape(.rect(cornerRadius: 22))
                    
                    VStack(alignment: .leading) {
                        Text(app.trackName)
                            .title()
                        
                        Text(app.artistName)
                            .secondary()
                    }
                }
            }
            
            Section("Requirements") {
                LabeledContent("Minimum OS Version") {
                    Text(app.minimumOSVersionRequirement)
                }
            }
            
            Section("Identifiers") {
                LabeledContent("Bundle ID") {
                    Text(app.bundleID)
                        .font(.body.monospaced())
                        .textSelection(.enabled)
                }
                
                LabeledContent("App ID") {
                    Text(String(app.trackId))
                        .font(.body.monospaced())
                        .textSelection(.enabled)
                }
            }
            
            Section("Store") {
                if let url = URL(string: app.trackViewUrl) {
                    Link(destination: url) {
                        Label("App Store", systemImage: "link")
                    }
                }
            }
        }
        .navigationTitle("App Details")
#if !os(macOS)
        .appStoreOverlay($skOverlay, id: app.trackId)
        .toolbar {
            Button("Download", systemImage: "plus.app") {
                skOverlay = true
            }
        }
#endif
    }
}

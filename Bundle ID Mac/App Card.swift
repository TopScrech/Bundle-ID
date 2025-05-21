import SwiftUI

struct AppCard: View {
    private let app: Result
    
    init(_ app: Result) {
        self.app = app
    }
    
    @State private var uiImage: NSImage?
    private let cache = NSCache<NSURL, NSImage>()
    
    var body: some View {
        HStack {
            if let uiImage {
                Image(nsImage: uiImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(.rect(cornerRadius: 16))
            } else {
                ProgressView()
                    .frame(width: 64, height: 64)
            }
            
            VStack(alignment: .leading) {
                Text(app.trackName)
                    .rounded()
                    .bold()
                
                Text(app.artistName)
                    .caption()
                
                Text(app.bundleID)
                    .caption()
                    .secondary()
                    .monospaced()
            }
        }
        .contextMenu {
            Button {
                NSPasteboard.general.setString(app.bundleID, forType: .string)
            } label: {
                Label("Copy Bundle ID", systemImage: "doc.on.doc")
            }
            
            Button {
                NSPasteboard.general.setString("\(app.trackId)", forType: .string)
            } label: {
                Label("Copy App ID", systemImage: "doc.on.doc")
            }
            
            Divider()
            
            Link(destination: URL(string: app.trackViewUrl)!) {
                Label("App Store", systemImage: "link")
            }
            
            ShareLink(item: app.trackViewUrl)
        }
        .task {
            // cache.name = app.bundleID
            guard let nsUrl = NSURL(string: app.bundleID) else {
                return
            }
            
            if let image = cache.object(forKey: nsUrl) {
                uiImage = image
            } else {
                if let url = URL(string: app.artworkUrl512) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let data, error == nil else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            let image = NSImage(data: data)
                            
                            if let image {
                                cache.setObject(image, forKey: nsUrl)
                                uiImage = image
                            } else {
                                print("Can't be converted to an image")
                            }
                        }
                    }
                    .resume()
                } else {
                    print("Invalid URL")
                }
            }
        }
    }
}

//#Preview {
//    AppCard()
//}

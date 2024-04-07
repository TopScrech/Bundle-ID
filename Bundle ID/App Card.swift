import SwiftUI

struct AppCard: View {
    private let app: Result
    
    init(_ app: Result) {
        self.app = app
    }
    
    let cache = NSCache<NSURL, UIImage>()
    
    @State private var uiImage: UIImage?
        
    var body: some View {
        HStack {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 64, height: 64)
                    .clipShape(.rect(cornerRadius: 16))
            } else {
                ProgressView()
                    .frame(width: 64, height: 64)
            }
            
            VStack(alignment: .leading) {
                Text(app.artistName)
                    .caption(.bold)
                
                Text(app.trackName)
                    .rounded()
                
                Text(app.bundleID)
                    .caption()
                    .foregroundStyle(.secondary)
                    .monospaced()
            }
        }
        .contextMenu {
            Button {
                UIPasteboard.general.string = app.bundleID
            } label: {
                Label("Copy Bundle ID", systemImage: "doc.on.doc")
            }
            
            Link(destination: URL(string: app.trackViewUrl)!) {
                Label("App Store", systemImage: "link")
            }
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
                            // handle the error here
                            return
                        }
                        
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                cache.setObject(image, forKey: nsUrl)
                                uiImage = image
                            } else {
                                print("Can't be converted to an image")
                                // handle the case when the data can't be converted to an image
                            }
                        }
                    }
                    .resume()
                } else {
                    print("Invalid URL")
                    // handle the case when the URL is not valid
                }
            }
        }
    }
}

//#Preview {
//    AppCard()
//}

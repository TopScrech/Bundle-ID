import Foundation

@Observable
final class VM {
    var data: Welcome? = nil
    
    func fetch(term: String, country: String) {
        //        let urlComponents = NSURLComponents(string: "https://itunes.apple.com/search")!
        //
        //        urlComponents.queryItems = [
        //            URLQueryItem(name: "limit", value: "\(limit)"),
        //            URLQueryItem(name: "media", value: "software"),
        //            URLQueryItem(name: "term", value: term),
        //            URLQueryItem(name: "country", value: country),
        //            URLQueryItem(name: "callback", value: "jQuery21407782049124112466_1711761089482"),
        //            URLQueryItem(name: "_", value: "1711761089483")
        //        ]
        //
        //        let url = urlComponents.url!
        
        let urlString = "https://itunes.apple.com/search?limit=10&media=software&term=\(term)&country=\(country)&callback=jQuery21407782049124112466_1711761089482&_=1711761089483"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data else {
                print("No data received")
                return
            }
            
            // Convert data to a string
            guard let jsonString = String(data: data, encoding: .utf8) else {
                print("Failed to convert data to string")
                return
            }
            
            // Find the index of the first '{' and the last '}'
            guard
                let firstBraceIndex = jsonString.firstIndex(of: "{"),
                let lastBraceIndex = jsonString.lastIndex(of: "}")
            else {
                print("Failed to find braces in JSON string")
                self.data = nil
                return
            }
            
            // Extract the substring between the braces
            let cleanJsonString = jsonString[firstBraceIndex...lastBraceIndex]
            
            // Convert the cleaned JSON string back to Data
            guard
                let cleanJsonData = cleanJsonString.data(using: .utf8)
            else {
                print("Failed to convert cleaned JSON string to data")
                return
            }
            
            // Decode cleaned JSON
            do {
                let welcome = try JSONDecoder().decode(Welcome.self, from: cleanJsonData)
                self.data = welcome
            } catch {
                print("Decoder error: \(error.localizedDescription)")
                self.data = nil
            }
        }
        .resume()
    }
}

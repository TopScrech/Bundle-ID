import SwiftUI

struct AppList: View {
    private var vm = VM()
    
    @AppStorage("term") private var term = "" // Name
    @AppStorage("country") private var country = "US"
    
    private var searchRules: String {
        term + country
    }
    
    var body: some View {
        List {
            HStack {
                TextField("Name", text: $term)
                
                if !term.isEmpty {
                    Button {
                        term = ""
                    } label: {
                        Image(systemName: "delete.left")
                            .tint(.red)
                    }
                }
            }
            
            Picker("Region", selection: $country) {
                Section("Default") {
                    ForEach(Region.defaultCases, id: \.self) { country in
                        Text("\(country) - \(country.rawValue)")
                            .tag("\(country)")
                    }
                }
                
                Section("All Countries") {
                    ForEach(Region.allCases, id: \.self) { country in
                        Text("\(country) - \(country.rawValue)")
                            .tag("\(country)")
                    }
                }
            }
            
            Section {
                if let data = vm.data {
                    ForEach(data.results, id: \.bundleID) { app in
                        AppCard(app)
                    }
                }
            }
        }
        .scrollIndicators(.never)
        .refreshableTask {
            vm.fetch(
                term: term,
                country: country
            )
        }
        .onChange(of: searchRules) {
            vm.fetch(
                term: term,
                country: country
            )
        }
    }
}

#Preview {
    AppList()
}

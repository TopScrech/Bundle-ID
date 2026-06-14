import ScrechKit

struct AppList: View {
    private var vm = VM()
    
    @AppStorage("term") private var term = "" // Name
    @AppStorage("country") private var country = "US"
    
    private var searchRules: String {
        term + country
    }
    
    @FocusState private var isFocused
    
    var body: some View {
        List {
            HStack {
                TextField("Name", text: $term)
                    .focused($isFocused)
                
                if !term.isEmpty {
                    SFButton("delete.left") {
                        term = ""
                        isFocused = true
                    }
                    .title3()
                    .tint(.red)
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
        .refreshable {
            vm.fetch(term: term, country: country)
        }
        .onAppear {
            vm.fetch(term: term, country: country)
        }
        .onChange(of: searchRules) {
            vm.fetch(term: term, country: country)
        }
    }
}

#Preview {
    AppList()
        .darkSchemePreferred()
}

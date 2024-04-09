import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            AppList()
                .tag(1)
                .tabItem {
                    Label("App Store", systemImage: "hammer")
                }
            
            StarredApps()
                .tag(2)
                .tabItem {
                    Label("Favorite", systemImage: "star")
                }
        }
    }
}

#Preview {
    HomeView()
}

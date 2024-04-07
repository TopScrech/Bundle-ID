import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            AppList()
                .tag(1)
                .tabItem {
                    Label("", systemImage: "")
                }
        }
    }
}

#Preview {
    HomeView()
}

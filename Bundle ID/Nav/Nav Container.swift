import SwiftUI

struct NavContainer: View {
    var body: some View {
        NavigationStack {
            AppList()
        }
    }
}

#Preview {
    NavContainer()
}

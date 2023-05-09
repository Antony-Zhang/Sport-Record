import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("This is the Home View")
                NavigationLink(destination: DetailView()) {
                    Text("Go to Detail View")
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("This is the Settings View")
                .navigationTitle("Settings")
        }
    }
}

struct DetailView: View {
    var body: some View {
        VStack {
            Text("This is the Detail View")
            NavigationLink(destination: SettingsView()) {
                Text("Go to Settings View")
            }
        }
        .navigationTitle("Detail")
    }
}

struct Previewss: PreviewProvider {
    static var previews: some View {
        HomeView()
        DetailView()
        SettingsView()
    }
}

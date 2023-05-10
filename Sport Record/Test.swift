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

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("This is the Settings View")
                .navigationTitle("Settings")
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        DetailView()
        SettingsView()
    }
}

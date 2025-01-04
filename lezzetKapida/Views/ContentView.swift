import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
            
            CartView()
                .tabItem {
                    Label("Sepetim", systemImage: "cart.fill")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favoriler", systemImage: "heart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
        .accentColor(.orange)
    }
} 
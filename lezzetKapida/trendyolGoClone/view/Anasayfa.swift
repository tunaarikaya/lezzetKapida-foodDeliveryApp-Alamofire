import SwiftUI

struct Anasayfa: View {
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
            
            OrderTrackingView()
                .tabItem {
                    Label("Sipariş Takip", systemImage: "location.fill")
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
        .preferredColorScheme(.light)
    }
}

#Preview {
    Anasayfa()
}

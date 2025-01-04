import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading) {
                            Text("Test Kullanıcı")
                                .font(.headline)
                            Text("test_user@email.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Hesap") {
                    NavigationLink(destination: EmptyView()) {
                        Label("Siparişlerim", systemImage: "bag")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Adreslerim", systemImage: "map")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Ödeme Yöntemlerim", systemImage: "creditcard")
                    }
                }
                
                Section("Ayarlar") {
                    NavigationLink(destination: EmptyView()) {
                        Label("Bildirim Ayarları", systemImage: "bell")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Gizlilik", systemImage: "lock")
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        Label("Yardım", systemImage: "questionmark.circle")
                    }
                }
                
                Section {
                    Button(action: {}) {
                        HStack {
                            Text("Çıkış Yap")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "arrow.right.square")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Profil")
        }
    }
} 
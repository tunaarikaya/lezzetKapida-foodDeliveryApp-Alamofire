import SwiftUI

struct AppAboutView: View {
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Lezzet Kapıda")
                        .font(.title2)
                        .bold()
                    
                    Text("Versiyon 1.0.0")
                        .foregroundColor(.gray)
                    
                    Text("© 2024 Lezzet Kapıda. Tüm hakları saklıdır.")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            
            Section("Yasal") {
                NavigationLink("Kullanım Koşulları") {
                    TermsView()
                }
                
                NavigationLink("Gizlilik Politikası") {
                    PrivacyPolicyView()
                }
                
                NavigationLink("KVKK Aydınlatma Metni") {
                    KVKKView()
                }
            }
            
            Section("Uygulama Hakkında") {
                NavigationLink("Sürüm Notları") {
                    ReleaseNotesView()
                }
                
                Link("Web Sitemiz", destination: URL(string: "https://lezzetkapida.com")!)
                
                Link("Sosyal Medya", destination: URL(string: "https://instagram.com/lezzetkapida")!)
            }
        }
        .navigationTitle("Hakkında")
    }
}

struct TermsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Kullanım Koşulları")
                    .font(.title)
                    .bold()
                
                Text("1. Hizmet Kullanımı")
                    .font(.headline)
                Text("Lezzet Kapıda uygulamasını kullanarak, bu koşulları kabul etmiş olursunuz...")
                
                Text("2. Hesap Güvenliği")
                    .font(.headline)
                Text("Hesabınızın güvenliğinden siz sorumlusunuz...")
            }
            .padding()
        }
        .navigationTitle("Kullanım Koşulları")
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Gizlilik Politikası")
                    .font(.title)
                    .bold()
                
                Text("Kişisel Verileriniz")
                    .font(.headline)
                Text("Lezzet Kapıda olarak gizliliğinize önem veriyoruz...")
            }
            .padding()
        }
        .navigationTitle("Gizlilik Politikası")
    }
}

struct KVKKView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("KVKK Aydınlatma Metni")
                    .font(.title)
                    .bold()
                
                Text("Veri Sorumlusu")
                    .font(.headline)
                Text("Lezzet Kapıda olarak, 6698 sayılı Kişisel Verilerin Korunması Kanunu uyarınca...")
            }
            .padding()
        }
        .navigationTitle("KVKK Aydınlatma Metni")
    }
}

struct ReleaseNotesView: View {
    var body: some View {
        List {
            Section("Versiyon 1.0.0") {
                Text("• İlk sürüm yayınlandı")
                Text("• Yemek siparişi özelliği eklendi")
                Text("• Favori yemekler özelliği eklendi")
                Text("• Adres ve ödeme yönetimi eklendi")
            }
        }
        .navigationTitle("Sürüm Notları")
    }
}

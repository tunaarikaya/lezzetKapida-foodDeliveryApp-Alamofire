import SwiftUI

struct ProfileView: View {
    @State private var showLogoutAlert = false
    @State private var isDarkMode = false
    @State private var selectedLanguage = "Türkçe"
    @State private var notificationSettings = NotificationSettings()
    
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
                            Text("Tuna Arıkaya")
                                .font(.headline)
                            Text("tunarikaya@email.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Hesap") {
                    NavigationLink(destination: OrdersView()) {
                        Label("Siparişlerim", systemImage: "bag")
                    }
                    
                    NavigationLink(destination: OrderTrackingView()) {
                        Label("Aktif Sipariş Takibi", systemImage: "location")
                    }
                    
                    NavigationLink(destination: AddressesView()) {
                        Label("Adreslerim", systemImage: "map")
                    }
                    
                    NavigationLink(destination: PaymentMethodsView()) {
                        Label("Ödeme Yöntemlerim", systemImage: "creditcard")
                    }
                    
                    NavigationLink(destination: FavoritesView()) {
                        Label("Favorilerim", systemImage: "heart")
                    }
                    
                    NavigationLink(destination: LoyaltyProgramView()) {
                        Label("Sadakat Programı", systemImage: "star.fill")
                    }
                    
                    NavigationLink(destination: CouponsView()) {
                        Label("Kuponlarım", systemImage: "ticket")
                    }
                }
                
                Section("Tercihler") {
                    NavigationLink(destination: DietaryPreferencesView()) {
                        Label("Diyet Tercihleri", systemImage: "leaf")
                    }
                    
                    NavigationLink(destination: NotificationSettingsView(settings: $notificationSettings)) {
                        Label("Bildirim Ayarları", systemImage: "bell")
                    }
                }
                
                Section("Ayarlar") {
                    NavigationLink(destination: PrivacySettingsView()) {
                        Label("Gizlilik", systemImage: "lock")
                    }
                    
                    Toggle(isOn: $isDarkMode) {
                        Label("Karanlık Mod", systemImage: "moon.fill")
                    }
                    .onChange(of: isDarkMode) { oldValue, newValue in
                        updateAppearance(isDark: newValue)
                    }
                    
                    Picker(selection: $selectedLanguage) {
                        Text("Türkçe").tag("Türkçe")
                        Text("English").tag("English")
                    } label: {
                        Label("Dil", systemImage: "globe")
                    }
                    .onChange(of: selectedLanguage) { oldValue, newValue in
                        updateLanguage(to: newValue)
                    }
                }
                
                Section("Yardım & Destek") {
                    NavigationLink(destination: FAQView()) {
                        Label("Sıkça Sorulan Sorular", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink(destination: SupportView()) {
                        Label("Müşteri Hizmetleri", systemImage: "headphones")
                    }
                    
                    NavigationLink(destination: AppAboutView()) {
                        Label("Hakkında", systemImage: "info.circle")
                    }
                }
                
                Section {
                    Button(action: { showLogoutAlert = true }) {
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
            .alert("Çıkış Yap", isPresented: $showLogoutAlert) {
                Button("İptal", role: .cancel) {}
                Button("Çıkış Yap", role: .destructive) {
                    logout()
                }
            } message: {
                Text("Çıkış yapmak istediğinizden emin misiniz?")
            }
        }
    }
    
    private func updateAppearance(isDark: Bool) {
        // Uygulama görünümünü güncelle
        UserDefaults.standard.set(isDark, forKey: "isDarkMode")
        // Tema değişikliğini uygula
    }
    
    private func updateLanguage(to language: String) {
        // Dil ayarını güncelle
        UserDefaults.standard.set(language, forKey: "appLanguage")
        // Dil değişikliğini uygula
    }
    
    private func logout() {
        // Kullanıcı oturumunu sonlandır
        UserDefaults.standard.removeObject(forKey: "userToken")
        // Ana ekrana yönlendir
    }
}

struct NotificationSettings {
    var promotions = true
    var orderUpdates = true
    var specialOffers = true
    var deliveryAlerts = true
}

struct NotificationSettingsView: View {
    @Binding var settings: NotificationSettings
    
    var body: some View {
        List {
            Section("Bildirim Tercihleri") {
                Toggle("Kampanya Bildirimleri", isOn: $settings.promotions)
                Toggle("Sipariş Güncellemeleri", isOn: $settings.orderUpdates)
                Toggle("Özel Teklifler", isOn: $settings.specialOffers)
                Toggle("Teslimat Bildirimleri", isOn: $settings.deliveryAlerts)
            }
            
            Section {
                Text("Bildirimleri kapatmak, önemli güncellemeleri kaçırmanıza neden olabilir.")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Bildirim Ayarları")
    }
}

// Yardımcı görünümler
struct ProfileEditView: View {
    var body: some View {
        List {
            Section("Kişisel Bilgiler") {
                TextField("Ad Soyad", text: .constant("Test Kullanıcı"))
                TextField("E-posta", text: .constant("test_user@email.com"))
                TextField("Telefon", text: .constant("+90 555 555 55 55"))
            }
            
            Section {
                Button("Değişiklikleri Kaydet") {
                    // Kaydetme işlemleri
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.orange)
            }
        }
        .navigationTitle("Profili Düzenle")
    }
}

struct OrdersView: View {
    var body: some View {
        List {
            ForEach(0..<5) { _ in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sipariş #12345")
                        .font(.headline)
                    Text("2 Ürün • 150.00 ₺")
                        .foregroundColor(.gray)
                    Text("Durumu: Hazırlanıyor")
                        .foregroundColor(.orange)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Siparişlerim")
    }
}

struct AddressesView: View {
    var body: some View {
        List {
            ForEach(0..<2) { index in
                VStack(alignment: .leading, spacing: 8) {
                    Text(index == 0 ? "Ev" : "İş")
                        .font(.headline)
                    Text("Örnek Mahallesi, Örnek Sokak No: \(index + 1)")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            
            Button(action: {}) {
                Label("Yeni Adres Ekle", systemImage: "plus.circle.fill")
                    .foregroundColor(.orange)
            }
        }
        .navigationTitle("Adreslerim")
    }
}

struct PaymentMethodsView: View {
    var body: some View {
        List {
            Section("Kayıtlı Kartlar") {
                ForEach(0..<2) { index in
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(.orange)
                        Text("**** **** **** \(1234 + index)")
                    }
                }
            }
            
            Section {
                Button(action: {}) {
                    Label("Yeni Kart Ekle", systemImage: "plus.circle.fill")
                        .foregroundColor(.orange)
                }
            }
        }
        .navigationTitle("Ödeme Yöntemlerim")
    }
}

struct PrivacySettingsView: View {
    @State private var isLocationEnabled = true
    @State private var isAnalyticsEnabled = true
    
    var body: some View {
        List {
            Section("İzinler") {
                Toggle("Konum İzni", isOn: $isLocationEnabled)
                Toggle("Analitik Verileri", isOn: $isAnalyticsEnabled)
            }
            
            Section("Hesap Güvenliği") {
                NavigationLink("Şifre Değiştir") {
                    // Şifre değiştirme görünümü
                }
                NavigationLink("İki Faktörlü Doğrulama") {
                    // 2FA görünümü
                }
            }
        }
        .navigationTitle("Gizlilik")
    }
}

struct FAQView: View {
    var body: some View {
        List {
            Section {
                DisclosureGroup("Siparişimi nasıl iptal edebilirim?") {
                    Text("Siparişinizi, hazırlanma aşamasındayken 'Siparişlerim' bölümünden iptal edebilirsiniz.")
                        .foregroundColor(.gray)
                }
                
                DisclosureGroup("Ödeme yöntemlerini nasıl güncelleyebilirim?") {
                    Text("'Ödeme Yöntemlerim' bölümünden kartlarınızı ekleyebilir veya güncelleyebilirsiniz.")
                        .foregroundColor(.gray)
                }
                
                DisclosureGroup("Teslimat ne kadar sürer?") {
                    Text("Siparişleriniz genellikle 30-45 dakika içerisinde teslim edilir.")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Sıkça Sorulan Sorular")
    }
}

struct SupportView: View {
    var body: some View {
        List {
            Section("İletişim") {
                Button(action: {}) {
                    Label("Canlı Destek", systemImage: "message.fill")
                        .foregroundColor(.orange)
                }
                
                Button(action: {}) {
                    Label("E-posta Gönder", systemImage: "envelope.fill")
                        .foregroundColor(.orange)
                }
                
                Button(action: {}) {
                    Label("Bizi Ara", systemImage: "phone.fill")
                        .foregroundColor(.orange)
                }
            }
        }
        .navigationTitle("Müşteri Hizmetleri")
    }
}

struct AppAboutViewi: View {
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
                    // Kullanım koşulları görünümü
                }
                
                NavigationLink("Gizlilik Politikası") {
                    // Gizlilik politikası görünümü
                }
                
                NavigationLink("KVKK Aydınlatma Metni") {
                    // KVKK görünümü
                }
            }
        }
        .navigationTitle("Hakkında")
    }
} 


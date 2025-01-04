import SwiftUI

struct CouponsView: View {
    var body: some View {
        List {
            Section("Aktif Kuponlarınız") {
                ForEach(0..<3) { _ in
                    CouponCard(
                        discount: "% 20 İndirim",
                        description: "100 TL ve üzeri siparişlerde geçerli",
                        expiryDate: "01.03.2024",
                        code: "YENI20"
                    )
                }
            }
            
            Section("Yakında Sona Erecek") {
                CouponCard(
                    discount: "% 15 İndirim",
                    description: "İlk siparişinize özel",
                    expiryDate: "28.02.2024",
                    code: "HOSGELDIN15",
                    isExpiringSoon: true
                )
            }
        }
        .navigationTitle("Kuponlarım")
    }
}

struct CouponCard: View {
    let discount: String
    let description: String
    let expiryDate: String
    let code: String
    var isExpiringSoon: Bool = false
    @State private var isCopied = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(discount)
                .font(.title3)
                .bold()
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text("Son kullanım: \(expiryDate)")
                    .font(.caption)
                    .foregroundColor(isExpiringSoon ? .red : .gray)
                
                Spacer()
                
                Button(action: {
                    UIPasteboard.general.string = code
                    isCopied = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isCopied = false
                    }
                }) {
                    Text(isCopied ? "Kopyalandı!" : code)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isCopied ? Color.green : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
        }
        .padding(.vertical, 8)
    }
} 
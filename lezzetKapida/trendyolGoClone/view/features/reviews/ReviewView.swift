import SwiftUI

struct ReviewView: View {
    let orderId: String
    @State private var rating: Int = 0
    @State private var comment: String = ""
    @State private var showSuccessAlert = false
    
    var body: some View {
        Form {
            Section("Siparişinizi Değerlendirin") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Sipariş #\(orderId)")
                        .font(.headline)
                    
                    HStack {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= rating ? "star.fill" : "star")
                                .font(.title2)
                                .foregroundColor(.orange)
                                .onTapGesture {
                                    withAnimation {
                                        rating = index
                                    }
                                }
                        }
                    }
                }
            }
            
            Section("Yorumunuz") {
                TextEditor(text: $comment)
                    .frame(height: 100)
                
                Text("\(comment.count)/500 karakter")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Section("Fotoğraf Ekle") {
                Button(action: {}) {
                    Label("Fotoğraf Ekle", systemImage: "photo")
                }
            }
            
            Section {
                Button("Değerlendir") {
                    submitReview()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.orange)
                .disabled(rating == 0)
            }
        }
        .navigationTitle("Sipariş Değerlendirme")
        .alert("Teşekkürler!", isPresented: $showSuccessAlert) {
            Button("Tamam") { }
        } message: {
            Text("Değerlendirmeniz başarıyla gönderildi.")
        }
    }
    
    private func submitReview() {
        // Değerlendirme gönderme işlemi
        showSuccessAlert = true
    }
} 
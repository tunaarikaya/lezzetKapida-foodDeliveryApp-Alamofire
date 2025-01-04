import SwiftUI

struct FoodDetailView: View {
    let food: Food
    @State private var quantity = 1
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: URL(string: food.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 200)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(food.yemek_adi)
                        .font(.title2)
                        .bold()
                    
                    Text("\(food.yemek_fiyat) ₺")
                        .font(.title3)
                        .foregroundColor(.orange)
                    
                    Stepper("Adet: \(quantity)", value: $quantity, in: 1...10)
                        .padding(.vertical)
                }
                .padding()
                
                Button(action: addToCart) {
                    Text("Sepete Ekle")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                }
                .padding()
            }
        }
        .alert("Bilgi", isPresented: $showingAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func addToCart() {
        Task {
            do {
                try await NetworkService.shared.addToCart(
                    food: food,
                    quantity: quantity,
                    username: "test_user"
                )
                alertMessage = "Ürün sepete eklendi"
                showingAlert = true
            } catch {
                alertMessage = "Bir hata oluştu: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }
} 
import SwiftUI

struct FoodDetailView: View {
    let food: Food
    @StateObject private var viewModel = CartViewModel()
    @State private var quantity = 1
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: food.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(food.yemek_adi)
                        .font(.title2)
                        .bold()
                    
                    Text(String(format: "%.2f ₺", food.price))
                        .font(.title3)
                        .foregroundColor(.orange)
                    
                    Stepper("Adet: \(quantity)", value: $quantity, in: 1...10)
                        .padding(.vertical)
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    Text("Toplam: \(String(format: "%.2f ₺", food.price * Double(quantity)))")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    Button(action: addToCart) {
                        if case .loading = viewModel.loadingState {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sepete Ekle")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(viewModel.loadingState == .loading)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Bilgi", isPresented: $viewModel.showAlert) {
            Button("Tamam") {
                if case .loaded = viewModel.loadingState {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
    }
    
    private func addToCart() {
        Task {
            await viewModel.addToCart(food: food, quantity: quantity)
        }
    }
} 
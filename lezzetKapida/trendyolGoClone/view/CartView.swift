import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    @State private var showClearCartAlert = false
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.loadingState {
                case .loading:
                    LoadingView()
                case .error(let error):
                    ErrorView(error: error) {
                        Task {
                            await viewModel.loadCartItems()
                        }
                    }
                case .idle, .loaded:
                    if viewModel.cartItems.isEmpty {
                        EmptyCartView()
                    } else {
                        CartContentView(viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Sepetim")
            .toolbar {
                if !viewModel.cartItems.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showClearCartAlert = true }) {
                            Text("Sepeti Temizle")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.loadCartItems()
        }
        .alert("Bilgi", isPresented: $viewModel.showAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
        .alert("Sepeti Temizle", isPresented: $showClearCartAlert) {
            Button("İptal", role: .cancel) { }
            Button("Temizle", role: .destructive) {
                Task {
                    await viewModel.clearCart()
                }
            }
        } message: {
            Text("Sepetinizdeki tüm ürünler silinecek. Onaylıyor musunuz?")
        }
    }
}

// Yardımcı görünümler
struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Yükleniyor...")
                .foregroundColor(.gray)
        }
    }
}

struct ErrorView: View {
    let error: AppError
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text(error.localizedDescription)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Button(action: retryAction) {
                Text("Tekrar Dene")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct EmptyCartView: View {
    var body: some View {
        ContentUnavailableView(
            "Sepetiniz Boş",
            systemImage: "cart",
            description: Text("Sepetinize henüz ürün eklemediniz.")
        )
        .foregroundColor(.gray)
    }
}

struct CartContentView: View {
    @ObservedObject var viewModel: CartViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(viewModel.cartItems) { item in
                    CartItemRow(item: item)
                        .swipeActions {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.removeItem(item)
                                }
                            } label: {
                                Label("Sil", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.loadCartItems()
            }
            
            CartSummaryView(
                totalPrice: viewModel.totalPrice,
                deliveryFee: viewModel.deliveryFee,
                finalPrice: viewModel.finalPrice
            )
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.yemek_adi)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack {
                    Text("\(item.quantity) adet")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text(String(format: "%.2f ₺", item.price))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text(String(format: "%.2f ₺", item.totalPrice))
                .font(.headline)
                .foregroundColor(.orange)
        }
        .padding(.vertical, 4)
    }
}

struct CartSummaryView: View {
    let totalPrice: Double
    let deliveryFee: Double
    let finalPrice: Double
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Text("Ara Toplam")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(String(format: "%.2f ₺", totalPrice))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Teslimat Ücreti")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(String(format: "%.2f ₺", deliveryFee))
                        .foregroundColor(.gray)
                }
                
                Divider()
                
                HStack {
                    Text("Toplam")
                        .font(.headline)
                    Spacer()
                    Text(String(format: "%.2f ₺", finalPrice))
                        .font(.title3)
                        .foregroundColor(.orange)
                        .bold()
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                // Ödeme işlemi için
            }) {
                Text("Siparişi Tamamla")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(
            Color(.systemBackground)
                .shadow(radius: 2, y: -2)
        )
    }
} 
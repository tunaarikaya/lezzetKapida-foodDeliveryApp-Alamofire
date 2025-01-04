import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.cartItems.isEmpty {
                    Text("Sepetiniz boş")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    VStack {
                        List {
                            ForEach(viewModel.cartItems) { item in
                                CartItemRow(item: item)
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            viewModel.removeItem(item)
                                        } label: {
                                            Label("Sil", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("Toplam")
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "%.2f ₺", viewModel.totalPrice))
                                    .font(.title3)
                                    .foregroundColor(.orange)
                            }
                            
                            Button(action: {}) {
                                Text("Siparişi Tamamla")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .shadow(radius: 2)
                    }
                }
            }
            .navigationTitle("Sepetim")
            .onAppear {
                viewModel.loadCartItems()
            }
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
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.yemek_adi)
                    .font(.headline)
                Text("\(item.yemek_siparis_adet) adet")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(item.yemek_fiyat) ₺")
                .font(.headline)
                .foregroundColor(.orange)
        }
        .padding(.vertical, 4)
    }
} 
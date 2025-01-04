import Foundation

@MainActor
class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadCartItems() {
        isLoading = true
        Task {
            do {
                cartItems = try await NetworkService.shared.getCartItems(username: "test_user")
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func removeItem(_ item: CartItem) {
        Task {
            do {
                try await NetworkService.shared.removeFromCart(
                    itemId: item.sepet_yemek_id,
                    username: "test_user"
                )
                await loadCartItems()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    var totalPrice: Double {
        cartItems.reduce(0) { total, item in
            total + (Double(item.yemek_fiyat) ?? 0) * (Double(item.yemek_siparis_adet) ?? 0)
        }
    }
} 
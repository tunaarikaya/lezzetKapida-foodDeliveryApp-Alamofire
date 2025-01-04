import Foundation
import SwiftUI

@MainActor
class CartViewModel: ObservableObject {
    @Published private(set) var cartItems: [CartItem] = []
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var showAlert = false
    @Published private(set) var alertMessage: String?
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var deliveryFee: Double {
        cartItems.isEmpty ? 0 : 14.90
    }
    
    var finalPrice: Double {
        totalPrice + deliveryFee
    }
    
    func loadCartItems() async {
        if case .loading = loadingState { return }
        
        loadingState = .loading
        do {
            cartItems = try await NetworkService.shared.getCartItems(username: "test_user")
            loadingState = .loaded
        } catch {
            let appError = error as? AppError ?? AppError.networkError(error.localizedDescription)
            loadingState = .error(appError)
            alertMessage = appError.localizedDescription
            showAlert = true
        }
    }
    
    func addToCart(food: Food, quantity: Int) async -> Bool {
        if case .loading = loadingState { return false }
        
        loadingState = .loading
        do {
            try await NetworkService.shared.addToCart(
                food: food,
                quantity: quantity,
                username: "test_user"
            )
            await loadCartItems()
            alertMessage = "Ürün başarıyla sepete eklendi"
            showAlert = true
            return true
        } catch {
            let appError = error as? AppError ?? AppError.networkError(error.localizedDescription)
            loadingState = .error(appError)
            alertMessage = appError.localizedDescription
            showAlert = true
            return false
        }
    }
    
    func removeItem(_ item: CartItem) async {
        if case .loading = loadingState { return }
        
        loadingState = .loading
        do {
            try await NetworkService.shared.removeFromCart(
                itemId: item.sepet_yemek_id,
                username: "test_user"
            )
            await loadCartItems()
        } catch {
            let appError = error as? AppError ?? AppError.networkError(error.localizedDescription)
            loadingState = .error(appError)
            alertMessage = appError.localizedDescription
            showAlert = true
        }
    }
    
    func clearCart() async {
        if cartItems.isEmpty { return }
        if case .loading = loadingState { return }
        
        loadingState = .loading
        do {
            for item in cartItems {
                try await NetworkService.shared.removeFromCart(
                    itemId: item.sepet_yemek_id,
                    username: "test_user"
                )
            }
            await loadCartItems()
            alertMessage = "Sepet başarıyla temizlendi"
            showAlert = true
        } catch {
            let appError = error as? AppError ?? AppError.networkError(error.localizedDescription)
            loadingState = .error(appError)
            alertMessage = appError.localizedDescription
            showAlert = true
        }
    }
} 

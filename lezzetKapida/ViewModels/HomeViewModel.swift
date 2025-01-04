import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var searchText = ""
    @Published var favoriteIds: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    var filteredFoods: [Food] {
        if searchText.isEmpty {
            return foods
        }
        return foods.filter { $0.yemek_adi.localizedCaseInsensitiveContains(searchText) }
    }
    
    func loadFoods() {
        isLoading = true
        Task {
            do {
                foods = try await NetworkService.shared.getAllFoods()
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func toggleFavorite(foodId: String) {
        if favoriteIds.contains(foodId) {
            favoriteIds.remove(foodId)
        } else {
            favoriteIds.insert(foodId)
        }
    }
} 
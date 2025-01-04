import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteIds: Set<String> = []
    @Published var favoriteFoods: [Food] = []
    @Published var isLoading = false
    
    func loadFavoriteFoods() {
        isLoading = true
        Task {
            do {
                let allFoods = try await NetworkService.shared.getAllFoods()
                favoriteFoods = allFoods.filter { favoriteIds.contains($0.id) }
                isLoading = false
            } catch {
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
        loadFavoriteFoods()
    }
} 
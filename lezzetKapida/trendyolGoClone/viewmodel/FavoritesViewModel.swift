import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favoriteIds: Set<String> = []
    @Published var favoriteFoods: [Food] = []
    @Published private(set) var loadingState: LoadingState = .idle
    
    private let favoritesKey = "favoriteIds"
    
    init() {
        loadFavorites()
    }
    
    func loadFavoriteFoods() async {
        if case .loading = loadingState { return }
        
        loadingState = .loading
        do {
            let allFoods = try await NetworkService.shared.getAllFoods()
            favoriteFoods = allFoods.filter { favoriteIds.contains($0.id) }
            loadingState = .loaded
        } catch {
            loadingState = .error(error as? AppError ?? AppError.networkError(error.localizedDescription))
        }
    }
    
    func toggleFavorite(foodId: String) {
        if favoriteIds.contains(foodId) {
            favoriteIds.remove(foodId)
        } else {
            favoriteIds.insert(foodId)
        }
        saveFavorites()
        Task {
            await loadFavoriteFoods()
        }
    }
    
    // Favorileri UserDefaults'a kaydet
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(Array(favoriteIds)) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    // Favorileri UserDefaults'tan yükle
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            favoriteIds = Set(decoded)
        }
    }
} 
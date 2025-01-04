import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var searchText = ""
    @Published var favoriteIds: Set<String> = []
    @Published private(set) var loadingState: LoadingState = .idle
    @Published var errorMessage: String?
    
    private let favoritesKey = "favoriteIds"
    
    init() {
        loadFavorites()
    }
    
    var showError: Bool {
        get { errorMessage != nil }
        set { if !newValue { errorMessage = nil } }
    }
    
    var filteredFoods: [Food] {
        if searchText.isEmpty {
            return foods
        }
        return foods.filter { $0.yemek_adi.localizedCaseInsensitiveContains(searchText) }
    }
    
    func loadFoods() async {
        if case .loading = loadingState { return }
        
        loadingState = .loading
        do {
            foods = try await NetworkService.shared.getAllFoods()
            loadingState = .loaded
        } catch {
            let appError = error as? AppError ?? AppError.networkError(error.localizedDescription)
            loadingState = .error(appError)
            errorMessage = appError.localizedDescription
        }
    }
    
    func toggleFavorite(foodId: String) {
        if favoriteIds.contains(foodId) {
            favoriteIds.remove(foodId)
        } else {
            favoriteIds.insert(foodId)
        }
        saveFavorites()
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
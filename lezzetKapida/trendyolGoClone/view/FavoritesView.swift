import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if case .loading = viewModel.loadingState {
                    ProgressView()
                        .scaleEffect(1.5)
                } else if viewModel.favoriteFoods.isEmpty {
                    ContentUnavailableView(
                        "Favori Ürününüz Yok",
                        systemImage: "heart",
                        description: Text("Henüz favori ürün eklemediniz.")
                    )
                    .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(viewModel.favoriteFoods) { food in
                                NavigationLink(destination: FoodDetailView(food: food)) {
                                    FoodCard(food: food,
                                           isFavorite: true,
                                           onFavorite: { viewModel.toggleFavorite(foodId: food.id) })
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.loadFavoriteFoods()
                    }
                }
            }
            .navigationTitle("Favorilerim")
        }
        .task {
            await viewModel.loadFavoriteFoods()
        }
    }
} 
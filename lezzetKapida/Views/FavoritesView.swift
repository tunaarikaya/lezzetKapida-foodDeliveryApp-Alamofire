import SwiftUI

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.favoriteFoods.isEmpty {
                    Text("Favori ürününüz bulunmamaktadır")
                        .font(.headline)
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
                }
            }
            .navigationTitle("Favorilerim")
        }
        .onAppear {
            viewModel.loadFavoriteFoods()
        }
    }
} 
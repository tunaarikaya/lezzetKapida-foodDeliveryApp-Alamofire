import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                
                if case .loading = viewModel.loadingState {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                } else if viewModel.foods.isEmpty {
                    ContentUnavailableView(
                        "Yemek Bulunamadı",
                        systemImage: "fork.knife.circle",
                        description: Text("Şu anda listelenecek yemek bulunmamaktadır.")
                    )
                    .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(viewModel.filteredFoods) { food in
                                NavigationLink(destination: FoodDetailView(food: food)) {
                                    FoodCard(food: food,
                                           isFavorite: viewModel.favoriteIds.contains(food.id),
                                           onFavorite: { viewModel.toggleFavorite(foodId: food.id) })
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.loadFoods()
                    }
                }
            }
            .navigationTitle("Lezzet Kapıda")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Lezzet Kapıda")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
            }
        }
        .task {
            await viewModel.loadFoods()
        }
        .alert("Hata", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("Tamam") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
} 
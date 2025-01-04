import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText)
                
                if viewModel.isLoading {
                    ProgressView()
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
                }
            }
            .navigationTitle("Trendyol Go")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Trendyol Go")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
            }
        }
        .onAppear {
            viewModel.loadFoods()
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
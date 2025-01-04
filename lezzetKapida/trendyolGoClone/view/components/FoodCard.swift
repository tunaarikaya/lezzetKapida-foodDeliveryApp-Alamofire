import SwiftUI

struct FoodCard: View {
    let food: Food
    let isFavorite: Bool
    let onFavorite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: food.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(height: 120)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(food.yemek_adi)
                    .font(.headline)
                    .lineLimit(2)
                
                Text("\(food.yemek_fiyat) ₺")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .overlay(
            Button(action: onFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .padding(8)
            }
            .padding(4),
            alignment: .topTrailing
        )
    }
} 
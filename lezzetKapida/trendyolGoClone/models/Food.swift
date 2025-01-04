struct Food: Identifiable, Codable {
    let yemek_id: String
    let yemek_adi: String
    let yemek_resim_adi: String
    let yemek_fiyat: String
    
    var id: String { yemek_id }
    
    var imageUrl: String {
        "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek_resim_adi)"
    }
    
    var price: Double {
        Double(yemek_fiyat) ?? 0.0
    }
}

struct FoodResponse: Codable {
    let yemekler: [Food]
    let success: Int
} 
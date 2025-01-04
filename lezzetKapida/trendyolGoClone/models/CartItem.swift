struct CartItem: Identifiable, Codable {
    let sepet_yemek_id: String
    let yemek_adi: String
    let yemek_resim_adi: String
    let yemek_fiyat: String
    let yemek_siparis_adet: String
    let kullanici_adi: String
    
    var id: String { sepet_yemek_id }
    
    var imageUrl: String {
        "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek_resim_adi)"
    }
    
    var quantity: Int {
        Int(yemek_siparis_adet) ?? 0
    }
    
    var price: Double {
        Double(yemek_fiyat) ?? 0.0
    }
    
    var totalPrice: Double {
        price * Double(quantity)
    }
}

struct CartResponse: Codable {
    let sepet_yemekler: [CartItem]?
    let success: Int
} 
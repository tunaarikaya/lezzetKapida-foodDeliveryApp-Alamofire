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
}

struct CartResponse: Codable {
    let sepet_yemekler: [CartItem]?
    let success: Int
} 
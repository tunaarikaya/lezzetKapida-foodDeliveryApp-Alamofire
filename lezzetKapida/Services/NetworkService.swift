import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "http://kasimadalan.pe.hu/yemekler"
    
    func getAllFoods() async throws -> [Food] {
        let url = "\(baseURL)/tumYemekleriGetir.php"
        let response = try await AF.request(url).serializingDecodable(FoodResponse.self).value
        return response.yemekler
    }
    
    func addToCart(food: Food, quantity: Int, username: String) async throws {
        let url = "\(baseURL)/sepeteYemekEkle.php"
        let parameters: [String: Any] = [
            "yemek_adi": food.yemek_adi,
            "yemek_resim_adi": food.yemek_resim_adi,
            "yemek_fiyat": food.yemek_fiyat,
            "yemek_siparis_adet": quantity,
            "kullanici_adi": username
        ]
        
        try await AF.request(url, method: .post, parameters: parameters)
            .serializingDecodable(BaseResponse.self).value
    }
    
    func getCartItems(username: String) async throws -> [CartItem] {
        let url = "\(baseURL)/sepettekiYemekleriGetir.php"
        let parameters: [String: Any] = ["kullanici_adi": username]
        
        let response = try await AF.request(url, method: .post, parameters: parameters)
            .serializingDecodable(CartResponse.self).value
        return response.sepet_yemekler ?? []
    }
    
    func removeFromCart(itemId: String, username: String) async throws {
        let url = "\(baseURL)/sepettenYemekSil.php"
        let parameters: [String: Any] = [
            "sepet_yemek_id": itemId,
            "kullanici_adi": username
        ]
        
        try await AF.request(url, method: .post, parameters: parameters)
            .serializingDecodable(BaseResponse.self).value
    }
}

struct BaseResponse: Codable {
    let success: Int
    let message: String
} 
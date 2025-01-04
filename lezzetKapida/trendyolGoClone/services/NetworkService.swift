import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    private let baseURL = "http://kasimadalan.pe.hu/yemekler"
    private let username = "test_user" // Gerçek uygulamada UserDefaults veya Keychain'den alınmalı
    
    private init() {}
    
    func getAllFoods() async throws -> [Food] {
        let url = "\(baseURL)/tumYemekleriGetir.php"
        
        do {
            let response = try await AF.request(url)
                .validate()
                .serializingDecodable(FoodResponse.self).value
            
            guard response.success == 1 else {
                throw AppError.serverError("Yemek listesi alınamadı")
            }
            
            guard !response.yemekler.isEmpty else {
                throw AppError.emptyData
            }
            
            return response.yemekler
        } catch DecodingError.dataCorrupted(_), DecodingError.keyNotFound(_, _),
                DecodingError.typeMismatch(_, _), DecodingError.valueNotFound(_, _) {
            throw AppError.decodingError
        } catch {
            throw AppError.networkError(error.localizedDescription)
        }
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
        
        do {
            let response = try await AF.request(url, method: .post, parameters: parameters)
                .validate()
                .serializingDecodable(BaseResponse.self).value
            
            guard response.success == 1 else {
                throw AppError.serverError(response.message)
            }
        } catch {
            if let appError = error as? AppError {
                throw appError
            }
            throw AppError.networkError(error.localizedDescription)
        }
    }
    
    func getCartItems(username: String) async throws -> [CartItem] {
        let url = "\(baseURL)/sepettekiYemekleriGetir.php"
        let parameters: [String: Any] = ["kullanici_adi": username]
        
        do {
            let response = try await AF.request(url, method: .post, parameters: parameters)
                .validate()
                .serializingDecodable(CartResponse.self).value
            
            return response.sepet_yemekler ?? []
        } catch DecodingError.dataCorrupted(_), DecodingError.keyNotFound(_, _),
                DecodingError.typeMismatch(_, _), DecodingError.valueNotFound(_, _) {
            throw AppError.decodingError
        } catch {
            throw AppError.networkError(error.localizedDescription)
        }
    }
    
    func removeFromCart(itemId: String, username: String) async throws {
        let url = "\(baseURL)/sepettenYemekSil.php"
        let parameters: [String: Any] = [
            "sepet_yemek_id": itemId,
            "kullanici_adi": username
        ]
        
        do {
            let response = try await AF.request(url, method: .post, parameters: parameters)
                .validate()
                .serializingDecodable(BaseResponse.self).value
            
            guard response.success == 1 else {
                throw AppError.serverError(response.message)
            }
        } catch {
            if let appError = error as? AppError {
                throw appError
            }
            throw AppError.networkError(error.localizedDescription)
        }
    }
}

struct BaseResponse: Codable {
    let success: Int
    let message: String
} 
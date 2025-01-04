import Foundation
import SwiftUI

enum AppError: LocalizedError, Equatable {
    case networkError(String)
    case decodingError
    case invalidResponse
    case emptyData
    case serverError(String)
    case userError(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Bağlantı hatası: \(message)"
        case .decodingError:
            return "Veri işleme hatası oluştu"
        case .invalidResponse:
            return "Sunucudan geçersiz yanıt alındı"
        case .emptyData:
            return "Veri bulunamadı"
        case .serverError(let message):
            return "Sunucu hatası: \(message)"
        case .userError(let message):
            return message
        }
    }
    
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.networkError(let lhs), .networkError(let rhs)):
            return lhs == rhs
        case (.decodingError, .decodingError):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.emptyData, .emptyData):
            return true
        case (.serverError(let lhs), .serverError(let rhs)):
            return lhs == rhs
        case (.userError(let lhs), .userError(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
} 

import SwiftUI

struct LoyaltyProgramView: View {
    @StateObject private var viewModel = LoyaltyViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Puan kartı
                VStack {
                    Text("Toplam Puanınız")
                        .font(.headline)
                    Text("\(viewModel.points)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.orange)
                    Text("\(viewModel.pointsValue) TL değerinde")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Seviye bilgisi
                VStack(spacing: 12) {
                    Text(viewModel.currentTier.displayName)
                        .font(.title3)
                        .bold()
                    
                    ProgressView(value: viewModel.progressToNextTier)
                        .tint(.orange)
                    
                    if let nextTier = viewModel.nextTier {
                        Text("\(nextTier.displayName) seviyesine \(viewModel.pointsToNextTier) puan kaldı")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Avantajlar
                VStack(alignment: .leading, spacing: 12) {
                    Text("Mevcut Avantajlarınız")
                        .font(.headline)
                    
                    ForEach(viewModel.currentTier.benefits, id: \.self) { benefit in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(benefit)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Puan geçmişi
                VStack(alignment: .leading, spacing: 12) {
                    Text("Puan Geçmişi")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(viewModel.pointHistory) { history in
                        PointHistoryRow(history: history)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Sadakat Programı")
    }
}

struct PointHistoryRow: View {
    let history: PointHistory
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(history.description)
                    .font(.subheadline)
                Text(history.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(history.points > 0 ? "+\(history.points)" : "\(history.points)")
                .foregroundColor(history.points > 0 ? .green : .red)
                .bold()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

class LoyaltyViewModel: ObservableObject {
    @Published var points = 1250
    @Published var currentTier: LoyaltyTier = .bronze
    @Published var pointHistory: [PointHistory] = []
    
    var pointsValue: Int {
        points / 25 // Her 25 puan 1 TL
    }
    
    var nextTier: LoyaltyTier? {
        switch currentTier {
        case .bronze: return .silver
        case .silver: return .gold
        case .gold: return nil
        }
    }
    
    var progressToNextTier: Double {
        guard let next = nextTier else { return 1.0 }
        let remaining = Double(pointsToNextTier)
        let total = Double(next.requiredPoints - currentTier.requiredPoints)
        let progress = 1.0 - (remaining / total)
        return max(0.0, min(1.0, progress))
    }
    
    var pointsToNextTier: Int {
        guard let next = nextTier else { return 0 }
        return next.requiredPoints - points
    }
    
    init() {
        // Örnek puan geçmişi
        pointHistory = [
            PointHistory(id: 1, description: "Sipariş #12345", date: "01.02.2024", points: 25),
            PointHistory(id: 2, description: "Sipariş #12346", date: "03.02.2024", points: 30),
            PointHistory(id: 3, description: "Puan Kullanımı", date: "05.02.2024", points: -50),
            PointHistory(id: 4, description: "Sipariş #12347", date: "07.02.2024", points: 40)
        ]
    }
}

enum LoyaltyTier {
    case bronze, silver, gold
    
    var displayName: String {
        switch self {
        case .bronze: return "Bronz Üye"
        case .silver: return "Gümüş Üye"
        case .gold: return "Altın Üye"
        }
    }
    
    var requiredPoints: Int {
        switch self {
        case .bronze: return 0
        case .silver: return 1000
        case .gold: return 2500
        }
    }
    
    var benefits: [String] {
        switch self {
        case .bronze:
            return [
                "Her siparişte %1 puan kazanma",
                "Özel kampanyalardan haberdar olma"
            ]
        case .silver:
            return [
                "Her siparişte %2 puan kazanma",
                "Özel kampanyalardan haberdar olma",
                "Ücretsiz teslimat"
            ]
        case .gold:
            return [
                "Her siparişte %3 puan kazanma",
                "Özel kampanyalardan haberdar olma",
                "Ücretsiz teslimat",
                "Öncelikli müşteri desteği",
                "Özel indirimler"
            ]
        }
    }
}

struct PointHistory: Identifiable {
    let id: Int
    let description: String
    let date: String
    let points: Int
} 
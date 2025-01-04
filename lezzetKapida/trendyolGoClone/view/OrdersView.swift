import SwiftUI

struct OrdersViewi: View {
    @State private var orders = [
        Order(id: "12345", items: 2, totalPrice: 150.0, status: .preparing, date: "15.02.2024"),
        Order(id: "12346", items: 1, totalPrice: 85.0, status: .delivered, date: "14.02.2024"),
        Order(id: "12347", items: 3, totalPrice: 220.0, status: .delivered, date: "13.02.2024")
    ]
    
    var body: some View {
        List {
            if let activeOrder = orders.first(where: { $0.status == .preparing }) {
                Section("Aktif Sipariş") {
                    NavigationLink(destination: OrderTrackingView()) {
                        ActiveOrderRow(order: activeOrder)
                    }
                }
            }
            
            Section("Geçmiş Siparişler") {
                ForEach(orders.filter { $0.status == .delivered }) { order in
                    NavigationLink(destination: OrderDetailView(order: order)) {
                        OrderRow(order: order)
                    }
                }
            }
        }
        .navigationTitle("Siparişlerim")
    }
}

struct Order: Identifiable {
    let id: String
    let items: Int
    let totalPrice: Double
    let status: OrderStatus
    let date: String
}

enum OrderStatus {
    case preparing, onTheWay, delivered
    
    var displayText: String {
        switch self {
        case .preparing: return "Hazırlanıyor"
        case .onTheWay: return "Yolda"
        case .delivered: return "Teslim Edildi"
        }
    }
    
    var color: Color {
        switch self {
        case .preparing: return .orange
        case .onTheWay: return .blue
        case .delivered: return .green
        }
    }
}

struct OrderRow: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Sipariş #\(order.id)")
                    .font(.headline)
                Spacer()
                Text(order.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Text("\(order.items) Ürün • \(String(format: "%.2f", order.totalPrice)) ₺")
                .foregroundColor(.gray)
            
            Text(order.status.displayText)
                .font(.caption)
                .foregroundColor(order.status.color)
        }
        .padding(.vertical, 4)
    }
}

struct ActiveOrderRow: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Sipariş #\(order.id)")
                    .font(.headline)
                Spacer()
                Text("Şimdi")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            Text("\(order.items) Ürün • \(String(format: "%.2f", order.totalPrice)) ₺")
                .foregroundColor(.gray)
            
            HStack {
                Text(order.status.displayText)
                    .font(.caption)
                    .foregroundColor(order.status.color)
                
                Spacer()
                
                Text("Siparişi Takip Et →")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .padding(.vertical, 4)
    }
}

struct OrderDetailView: View {
    let order: Order
    @State private var showReviewSheet = false
    
    var body: some View {
        List {
            Section("Sipariş Detayı") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sipariş #\(order.id)")
                        .font(.headline)
                    
                    Text(order.date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("\(order.items) Ürün • \(String(format: "%.2f", order.totalPrice)) ₺")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(order.status.displayText)
                        .font(.caption)
                        .foregroundColor(order.status.color)
                }
            }
            
            if order.status == .delivered {
                Section {
                    Button(action: { showReviewSheet = true }) {
                        Label("Siparişi Değerlendir", systemImage: "star")
                            .foregroundColor(.orange)
                    }
                }
            }
        }
        .navigationTitle("Sipariş Detayı")
        .sheet(isPresented: $showReviewSheet) {
            NavigationView {
                ReviewView(orderId: order.id)
            }
        }
    }
} 

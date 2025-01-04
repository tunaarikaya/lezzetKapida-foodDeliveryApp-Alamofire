import SwiftUI
import MapKit

struct OrderTrackingView: View {
    @State private var currentStep = 2
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 41.0082,
            longitude: 28.9784
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.05,
            longitudeDelta: 0.05
        )
    )
    
    @State private var locations = [
        LocationItem(
            coordinate: CLLocationCoordinate2D(
                latitude: 41.0082,
                longitude: 28.9784
            ),
            title: "Restoran",
            type: .restaurant
        ),
        LocationItem(
            coordinate: CLLocationCoordinate2D(
                latitude: 41.0122,
                longitude: 28.9862
            ),
            title: "Kurye",
            type: .courier
        ),
        LocationItem(
            coordinate: CLLocationCoordinate2D(
                latitude: 41.0152,
                longitude: 28.9922
            ),
            title: "Teslimat Adresi",
            type: .destination
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Sipariş durumu adımları
                    StepperView(steps: [
                        "Sipariş Alındı",
                        "Hazırlanıyor",
                        "Yola Çıktı",
                        "Teslim Edildi"
                    ], currentStep: currentStep)
                    
                    // Tahmini varış süresi
                    VStack(alignment: .leading) {
                        Text("Tahmini Varış")
                            .font(.headline)
                        Text("15-20 dakika")
                            .font(.title2)
                            .foregroundColor(.orange)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Kurye bilgisi
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading) {
                            Text("Ahmet Y.")
                                .font(.headline)
                            Text("Kurye")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "phone.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Harita görünümü
                    Map(coordinateRegion: $region,
                        annotationItems: locations) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            LocationAnnotationView(location: location)
                        }
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Sipariş Takibi")
        }
    }
}

enum LocationType {
    case restaurant, courier, destination
    
    var icon: String {
        switch self {
        case .restaurant: return "fork.knife.circle.fill"
        case .courier: return "bicycle.circle.fill"
        case .destination: return "house.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .restaurant: return .orange
        case .courier: return .green
        case .destination: return .blue
        }
    }
}

struct LocationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let type: LocationType
}

struct LocationAnnotationView: View {
    let location: LocationItem
    
    var body: some View {
        VStack {
            Image(systemName: location.type.icon)
                .font(.title)
                .foregroundColor(location.type.color)
            
            Text(location.title)
                .font(.caption)
                .foregroundColor(.black)
                .padding(4)
                .background(Color.white)
                .cornerRadius(4)
        }
    }
}

struct StepperView: View {
    let steps: [String]
    let currentStep: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                HStack(spacing: 15) {
                    Circle()
                        .fill(index <= currentStep ? Color.orange : Color.gray)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: index < currentStep ? "checkmark" : "\(index + 1).circle.fill")
                                .foregroundColor(.white)
                        )
                    
                    Text(step)
                        .font(.headline)
                        .foregroundColor(index <= currentStep ? .primary : .gray)
                    
                    Spacer()
                }
                
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(index < currentStep ? Color.orange : Color.gray)
                        .frame(width: 2, height: 20)
                        .padding(.leading, 14)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
} 
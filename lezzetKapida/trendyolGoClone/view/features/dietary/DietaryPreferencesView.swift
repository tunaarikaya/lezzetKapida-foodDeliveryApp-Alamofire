import SwiftUI

struct DietaryPreferencesView: View {
    @State private var dietaryPreferences = DietaryPreferences()
    @State private var showSaveAlert = false
    
    var body: some View {
        Form {
            Section("Diyet Tercihleri") {
                Toggle("Vejetaryen", isOn: $dietaryPreferences.isVegetarian)
                Toggle("Vegan", isOn: $dietaryPreferences.isVegan)
                Toggle("Glutensiz", isOn: $dietaryPreferences.isGlutenFree)
            }
            
            Section("Alerjenler") {
                ForEach(Allergen.allCases, id: \.self) { allergen in
                    Toggle(allergen.displayName, isOn: .init(
                        get: { dietaryPreferences.allergies.contains(allergen) },
                        set: { isOn in
                            if isOn {
                                dietaryPreferences.allergies.insert(allergen)
                            } else {
                                dietaryPreferences.allergies.remove(allergen)
                            }
                        }
                    ))
                }
            }
            
            Section("Kalori Tercihi") {
                Toggle("Düşük Kalorili Seçenekler", isOn: $dietaryPreferences.lowCalorie)
            }
            
            Section {
                Button("Kaydet") {
                    saveDietaryPreferences()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.orange)
            }
        }
        .navigationTitle("Diyet Tercihleri")
        .alert("Başarılı", isPresented: $showSaveAlert) {
            Button("Tamam") { }
        } message: {
            Text("Tercihleriniz kaydedildi.")
        }
    }
    
    private func saveDietaryPreferences() {
        // Tercihleri kaydetme işlemi
        showSaveAlert = true
    }
}

struct DietaryPreferences {
    var isVegetarian = false
    var isVegan = false
    var isGlutenFree = false
    var allergies: Set<Allergen> = []
    var lowCalorie = false
}

enum Allergen: String, CaseIterable {
    case milk = "Süt"
    case eggs = "Yumurta"
    case peanuts = "Fıstık"
    case treeNuts = "Kuruyemiş"
    case fish = "Balık"
    case shellfish = "Kabuklu Deniz Ürünleri"
    case wheat = "Buğday"
    case soy = "Soya"
    
    var displayName: String { rawValue }
} 
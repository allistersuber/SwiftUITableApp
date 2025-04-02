import SwiftUI
import MapKit

// Define the Item struct with the rating property
struct Item: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let desc: String
    let lat: Double
    let long: Double
    let imageName: String
    let rating: Int // Added the rating variable
}

// Sample data for the items (stores)
let data = [
    Item(name: "Vagabond", address: "410 N LBJ Dr, San Marcos", desc: "This store is an amazing place for sourcing vintage often for a very good price, the atmosphere is hectic but the finds are worth it.", lat: 29.885136, long: -97.9399711, imageName: "image1", rating: 8),
    Item(name: "Love-Buzz", address: "426 N LBJ Dr, San Marcos", desc: "Love-Buzz offers a unique vintage shopping experience with amazing curated sections that make it super easy to find what styles you are looking for!", lat: 29.883543, long: -97.941487, imageName: "image2", rating: 10),
    Item(name: "Old-Soul Exchange", address: "419 N LBJ Dr, San Marcos", desc: "Old-Soul Exchange is a funky little vintage shop filled with nostalgic treasures from a different time, the owner is awesome and the atmosphere is extremely friendly.", lat: 29.883821, long: -97.940274, imageName: "image3", rating: 9),
    Item(name: "Uptown Cheapskate", address: "1260 Aquarena Springs Dr, San Marcos", desc: "Uptown Cheapskate is a truly hidden gem for vintage in the San Marcos area, it can be hit or miss but the hits make it so worth it.", lat: 29.8773, long: -97.9394, imageName: "image4", rating: 8),
    Item(name: "Goodwill", address: "2915 N I-35, San Marcos", desc: "Goodwill is an old classic but is still a staple for vintage finds in the San Marcos area, it isn't as good as the other locations but is still worth checking out.", lat: 29.8890, long: -97.9436, imageName: "image5", rating: 7)
]

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29.885136, longitude: -97.939971), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var body: some View {
        NavigationView {
            VStack {
                // List of items (stores)
                List(data, id: \.id) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        HStack {
                            // Display image for each item
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.address)
                                    .font(.subheadline)
                                
                                // Display rating in list
                                Text("Rating: \(item.rating)/10")
                                    .font(.subheadline)
                                    .foregroundColor(
                                        item.rating >= 8 ? .green : (item.rating == 7 ? .yellow : .red) // Yellow for 7
                                    )
                            }
                        }
                    }
                }
                
                // Map displaying locations
                Map(coordinateRegion: $region, annotationItems: data) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                            .overlay(
                                Text(item.name)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .offset(y: 25)
                            )
                    }
                }
                .frame(height: 300)
                .padding(.bottom, -30)
            }
            .background(Color.green.opacity(0.2)) // Pastel green background for ContentView
            .listStyle(PlainListStyle())
            .navigationTitle("San Marcos Vintage")
        }
    }
}

struct DetailView: View {
    @State private var region: MKCoordinateRegion
    let item: Item
    
    init(item: Item) {
        self.item = item
        _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
    }
    
    var body: some View {
        VStack {
            // Display the image
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 200)
            
            Text("Address: \(item.address)")
                .font(.subheadline)
            
            Text("Description: \(item.desc)")
                .font(.subheadline)
                .padding(10)
            
            // Display the rating
            Text("Rating: \(item.rating)/10")
                .font(.title)
                .foregroundColor(
                    item.rating >= 8 ? .green : (item.rating == 7 ? .yellow : .red) // Yellow for 7
                )
            
            // Display map for item location
            Map(coordinateRegion: $region, annotationItems: [item]) { item in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                        .overlay(
                            Text(item.name)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .fixedSize(horizontal: true, vertical: false)
                                .offset(y: 25)
                        )
                }
            }
            .frame(height: 300)
            .padding(.bottom, -30)
            
            Spacer()
        }
        .background(Color.green.opacity(0.2)) // Pastel green background for DetailView
        .navigationTitle(item.name)
    }
}

#Preview {
    ContentView()
}

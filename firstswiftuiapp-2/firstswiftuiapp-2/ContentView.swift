//
//  ContentView.swift
//  firstswiftuiapp-2
//
//  Created by Demitri Booker on 4/6/26.
//

import SwiftUI
import MapKit


let data = [
Item(name: "Traphouse Carribean", neighborhood: "Downtown", category: "Carribean", desc: "Patties and Jerk Chicken,beef and pork tacos star at this bustling eatery with a laid back vibe", address: "310 Colorado St", lat: 30.26617, long: -97.753550,  imageName: "rest1"),
Item(name: "NADC Burger", neighborhood: "Downtown", category: "Burgers", desc: "Not a Damn Chance Burger is a wagyu cheeseburger collaboration between Professional Skateboarder Neen Williams and Michelin-starred Chef Phillip Frankland Lee", address: "1007 E 6th St", lat: 30.264830, long: -97.732224, imageName: "rest2"),
Item(name: "Gossip Shack", neighborhood: "Pflugerville", category: "Wings & More", desc: "Family-owned joint offering a variety of chicken wing flavors plus fried pickles, waffles, and sides.", address: "1615 Grand Ave Pkwy #110", lat: 30.455570, long: -97.658836, imageName: "rest3"),
Item(name: "Bob's Steak & Chop House", neighborhood: "Downtown", category: "Steakhouse", desc: "Texas-born chain serving big slabs of beef, seafood & a large wine list in a classy atmosphere. ", address: "301 Lavaca St", lat: 30.266159, long: -97.745872, imageName: "rest4"),
Item(name: "III Forks", neighborhood: "Downtown", category: "Steakhouse", desc: "Luxe, clubby chophouse & seafood chain with a broad wine list & many private rooms", address: "4222 Duval St.", lat: 30.264193, long: -97.746648, imageName: "rest5")
]

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let neighborhood: String
    let category: String
    let desc: String
    let address: String
    let lat: Double
    let long: Double
    let imageName: String
}

struct ContentView: View {
// initialize variables for Map in List View abd set zoom and centering location
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.295190, longitude: -97.726220), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    let categories = ["All"] + Array(Set(data.map { $0.category })).sorted()
       @State private var selectedCategory = "All"

       var filteredData: [Item] {
           if selectedCategory == "All" {
               return data
           } else {
               return data.filter { $0.category == selectedCategory }
           }
       } // end filteredData
    
    
var body: some View {
    NavigationView {
    VStack {
    Picker("Category", selection: $selectedCategory) {
          ForEach(categories, id: \.self) { category in
              Text(category).tag(category)
          }
      } // end Picker
      .pickerStyle(.menu)
      .padding()

        List(filteredData, id: \.name) { item in
            NavigationLink(destination: DetailView(item: item)) {
                HStack {
                    Image(item.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.category)
                            .font(.subheadline)
                        Text(item.neighborhood)
                            .font(.subheadline)
                    } // end internal VStack
                } // end HStack
            } // end NavigationLink
        } // end List
    
// Map code inserted after list
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
} // end Map
.frame(height: 300)
.padding(.bottom, -30)
            
            
        } // end VStack
        .listStyle(PlainListStyle())
             .navigationTitle("Austin Restaurants")
         } // end NavigationView
    } // end body
}


struct DetailView: View {
// initialize variables for Map in Detail View abd set zoom and centering on specific item
@State private var region: MKCoordinateRegion
         
init(item: Item) {
self.item = item
_region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)))
}
        
let item: Item
               
var body: some View {
VStack {
   Image(item.imageName)
       .resizable()
       .aspectRatio(contentMode: .fit)
       .frame(maxWidth: 200)
   Text("Neighborhood: \(item.neighborhood)")
       .font(.subheadline)
   Text("Category: \(item.category)")
       .font(.subheadline)
       
   Text((item.address))
       .font(.subheadline)
       .frame(maxWidth: .infinity, alignment: .leading)
       .padding()
   Text("Description: \(item.desc)")
       .font(.subheadline)
       .padding(10)
               
//Map code in Detail View
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
} // end Map
    .frame(height: 300)
    .padding(.bottom, -60)
    Spacer()
           
    } // end VStack
    .navigationTitle(item.name)
   
        } // end body
     } // end DetailView
   

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

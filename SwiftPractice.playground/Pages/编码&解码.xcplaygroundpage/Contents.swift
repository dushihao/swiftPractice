//: [Previous](@previous)

import Foundation

struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}

struct Placemark: Codable {
    var name: String
    var coordinate: Coordinate
}

let places = [
    Placemark(name: "Berlin", coordinate:
                Coordinate(latitude: 52, longitude: 13)),
    Placemark(name: "Cape Town", coordinate:
                Coordinate(latitude: -34, longitude: 18))
]
do {
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(places) // 129 bytes
    let jsonString = String(decoding: jsonData, as: UTF8.self)
    /*
     [{"name":"Berlin","coordinate":{"longitude":13,"latitude":52}},
     {"name":"Cape Town","coordinate":{"longitude":18,"latitude":-34}}]
     */
} catch {
    print(error.localizedDescription)
}

//: [Next](@next)

import Foundation
import UIKit
import Combine

final class LikedCatsViewModel {
    static let shared = LikedCatsViewModel()
    private let likedCatsSubject = CurrentValueSubject<[UIImage], Never>([])
    
    var likedCatsPublisher: AnyPublisher<[UIImage], Never> {
        likedCatsSubject.eraseToAnyPublisher()
    }
    
    private init() {}
    
    func addLikedCat(image: UIImage) {
        var currentCats = likedCatsSubject.value
        currentCats.append(image)
        likedCatsSubject.send(currentCats)
    }
    
    func getLikedCats() -> [UIImage] {
        return likedCatsSubject.value
    }
}

import Foundation
import Combine

final class RandomCatViewModel {
    private var randomCatSubject = PassthroughSubject<Cat?, Never>()
    private var isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let catAPIService: CatAPIService
    var cancellables = Set<AnyCancellable>()
    
    var catPublisher: AnyPublisher<Cat?, Never> {
        randomCatSubject.eraseToAnyPublisher()
    }

    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }
    
    init(catAPIService: CatAPIService) {
        self.catAPIService = catAPIService
        
    }
}

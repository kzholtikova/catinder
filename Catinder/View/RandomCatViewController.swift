import UIKit
import SnapKit
import Combine

class RandomCatViewController : UIViewController {
    private let viewModel: RandomCatViewModel
    
    private var breeds: [Breed] = []
    private var isLoading = false
    
    init(viewModel: RandomCatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
    }
    
    private func setupTableView() {
        view.backgroundColor = .darkGray
    }
}

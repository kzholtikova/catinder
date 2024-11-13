import UIKit
import SnapKit
import Combine

final class CatBreedsViewController : UIViewController {
    private let viewModel: CatBreedsViewModel
    
    private var breeds: [Breed] = []
    private var images: [UIImage?] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BreedCell.self, forCellReuseIdentifier: BreedCell.identifier)
        return tableView
    }()
    
    private let loadingView = LoadingView()
    
    init(viewModel: CatBreedsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        
        DispatchQueue.global(qos: .background).async {
            self.viewModel.fetchBreeds()

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .darkGray
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        Publishers.CombineLatest(viewModel.breedsPublisher, viewModel.breedsImagesPublisher)
           .sink { [weak self] breeds, images in
               self?.breeds = breeds
               self?.images = images
               self?.tableView.reloadData()
           }
           .store(in: &viewModel.cancellables)
        
        viewModel.isLoadingPublisher
            .sink { [weak self] isLoading in
                DispatchQueue.main.async {
                    if isLoading {
                        self?.loadingView.show()
                    } else {
                        self?.loadingView.hide()
                    }
                }
            }
            .store(in: &viewModel.cancellables)
    }
}

extension CatBreedsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BreedCell.identifier, for: indexPath) as? BreedCell else {
            return UITableViewCell()
        }
        
        cell.setupCell(with: breeds[indexPath.row], image: images[indexPath.row])
        return cell
    }
}

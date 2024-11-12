import UIKit
import SnapKit
import Combine

final class RandomCatViewController : UIViewController {
    private let viewModel: RandomCatViewModel
    
    private var randomCat: Cat? = nil
    private var isLoading = false
    
    private let catImageViewContainer: UIView = {
        let containerView = UIView()
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = 15
        containerView.backgroundColor = .white
        containerView.clipsToBounds = false
        
        return containerView
    }()
    
    private let catImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "heart.circle"), for: .normal)
        button.tintColor = .green
        button.imageView?.contentMode = .scaleAspectFit
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 75, weight: .bold, scale: .large), forImageIn: .normal)
        
        return button
    }()
    
    private let dislikeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .red
        button.imageView?.contentMode = .scaleAspectFit
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 75, weight: .bold, scale: .large), forImageIn: .normal)
            
        return button
    }()
    
    init(viewModel: RandomCatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.fetchRandomCat()
    }
    
    private func setupView() {
        view.addSubview(catImageViewContainer)
        view.addSubview(catImageView)
        view.addSubview(likeButton)
        view.addSubview(dislikeButton)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(dislikeButtonTapped), for: .touchUpInside)
        
        catImageViewContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(500)
        }
        
        catImageView.snp.makeConstraints {
            $0.top.equalTo(catImageViewContainer.snp.top).inset(75)
            $0.leading.trailing.equalTo(catImageViewContainer).inset(5)
            $0.bottom.equalTo(catImageViewContainer.snp.bottom).inset(50)
        }
        
        dislikeButton.snp.makeConstraints {
            $0.top.equalTo(catImageViewContainer.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(50)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(catImageViewContainer.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().inset(50)
        }
    }
    
    private func bindViewModel() {
        viewModel.catPublisher
            .sink { [weak self] cat in
                self?.randomCat = cat
                self?.viewModel.fetchCurrentCatImage()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.catImagePublisher
            .sink { [weak self] image in
                self?.catImageView.image = image
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.isLoadingPublisher
            .sink { [weak self] isLoading in
                self?.isLoading = isLoading
                // Show or hide a loading indicator
            }
            .store(in: &viewModel.cancellables)
    }
    
    @objc private func likeButtonTapped() {
        viewModel.likeCat()
        viewModel.fetchRandomCat()
    }
    
    @objc private func dislikeButtonTapped() {
        viewModel.dislikeCat()
        viewModel.fetchRandomCat()
    }
}

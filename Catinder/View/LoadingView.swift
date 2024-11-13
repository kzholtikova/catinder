import UIKit

final class LoadingView : UIView {
    
    private let loadingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "preloader"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(loadingImageView)
    
        loadingImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        isHidden = true
    }
    
    private func rotateImageView() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1.0
        rotation.repeatCount = .infinity
        loadingImageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func show() {
        isHidden = false
        rotateImageView()
    }
    
    func hide() {
        isHidden = true
        loadingImageView.layer.removeAllAnimations()
    }
}

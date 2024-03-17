import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    static var possibleHeight: CGFloat {
        return 40 + 16 + 16
    }
    
    static var reuseIdentifier: String = "MainCollectionViewCell"
    
    // MARK: - Private Properties
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setup(circleColor: UIColor, number: String, isSeparatorNeeded: Bool) {
        circleView.backgroundColor = circleColor
        titleLabel.text = number
        
        if isSeparatorNeeded {
            separatorView.isHidden = false
        } else {
            separatorView.isHidden = true
        }
    }

    // MARK: - Private methods

    private func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(circleView)
        contentView.addSubview(separatorView)
        contentView.addSubview(titleLabel)
        
        circleView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(separatorView.snp.top).offset(-15)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(circleView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        separatorView.isHidden = true
        circleView.backgroundColor = .systemBackground
        titleLabel.text = nil
    }
}

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(
            MainCollectionViewCell.self,
            forCellWithReuseIdentifier: MainCollectionViewCell.reuseIdentifier
        )
        return collectionView
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: MainViewModel
    private var timer: Timer?
    
    // MARK: - Lifecycle
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private methods
    
    @objc private func startButtonPressed() {
        viewModel.isStartButtonPressed = !viewModel.isStartButtonPressed
        setupStartButton()
        if viewModel.isStartButtonPressed {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        view.addSubview(startButton)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(16)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().inset(32)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
        
        setupStartButton()
    }
    
    private func setupStartButton() {
        if viewModel.isStartButtonPressed {
            startButton.setTitle("STOP", for: .normal)
            startButton.backgroundColor = .red
        } else {
            startButton.setTitle("START", for: .normal)
            startButton.backgroundColor = .green
        }
    }
    
    private func startTimer() {
        guard !viewModel.isTimerEnabled else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            do {
                try self.viewModel.executeActions()
                self.collectionView.reloadData()
            } catch {
                self.startButtonPressed()
                self.showAlertError(errorDescription: error.localizedDescription)
            }
        }
        
        viewModel.isTimerEnabled = true
    }
    
    private func stopTimer() {
        guard viewModel.isTimerEnabled else { return }
        
        timer?.invalidate()
        
        viewModel.isTimerEnabled = false
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.reuseIdentifier, for: indexPath) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = viewModel.dataSource[indexPath.row]
        let isSeparatorNeeded: Bool = (viewModel.dataSource.count - 1) != indexPath.row
        cell.setup(circleColor: item.color, number: String(item.number), isSeparatorNeeded: isSeparatorNeeded)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.isStartButtonPressed else { return }
        viewModel.addValueOfElement(index: indexPath.row)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: MainCollectionViewCell.possibleHeight)
    }
}

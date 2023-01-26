import UIKit
import StoreKit

class PremiumViewController: UIViewController {
    
    let primaryColor = UIColor(red: 56/255, green: 239/255, blue: 125/255, alpha: 1.0)
    let secondaryColor = UIColor(red: 17/255, green: 153/255, blue: 142/255, alpha: 1.0)
    
    var previousNavBarBackgroundImage: UIImage?
    var previousNavBarShadowImage: UIImage?
    var previousBackButtonColor: UIColor?
    
    private var premiumProduct: SKProduct?
    
    private let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
    
    private lazy var topBackgroundView: CurvedView = {
        let view = CurvedView()
        view.contentMode = .redraw
        view.primaryColor = self.primaryColor
        view.secondaryColor = self.secondaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        scrollView.contentInset = .zero
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.scrollIndicatorInsets = .zero
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delaysContentTouches = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var upgradeTitle: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Upgrade to Premium", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let crownImage = #imageLiteral(resourceName: "ic_crown")
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0
        stackView.addArrangedSubview(paymentSection)
        stackView.addArrangedSubview(featureSection)
        stackView.addArrangedSubview(noAdsSection)
        stackView.addArrangedSubview(syncSection)
        stackView.addArrangedSubview(customizeSection)
        stackView.addArrangedSubview(imagesSection)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var paymentSection: UIStackView = {
        let stackView = buildFeatureStackView()
        stackView.addArrangedSubview(paymentCheckMarkView)
        stackView.addArrangedSubview(paymentLabel)
        return stackView
    }()
    
    private lazy var paymentLabel: UILabel = {
        let label = buildFeatureLabel()
        label.text = NSLocalizedString("Pay only once (without subscription)", comment: "")
        return label
    }()
    
    private lazy var paymentCheckMarkView: UIView = {
        let contentView = UIView()
        let view = CheckMarkView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.color = secondaryColor
        contentView.addSubview(view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        contentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        return contentView
    }()
    
    private lazy var featureSection: UIStackView = {
        let stackView = buildFeatureStackView()
        stackView.addArrangedSubview(featureCheckMarkView)
        stackView.addArrangedSubview(featureLabel)
        return stackView
    }()
    
    private lazy var featureLabel: UILabel = {
        let label = buildFeatureLabel()
        label.text = NSLocalizedString("Get access to every feature released in the future", comment: "")
        return label
    }()
    
    private lazy var featureCheckMarkView: UIView = {
        let contentView = UIView()
        let view = CheckMarkView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.color = secondaryColor
        contentView.addSubview(view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        contentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        return contentView
    }()
    
    private lazy var noAdsSection: UIStackView = {
        let stackView = buildFeatureStackView()
        stackView.addArrangedSubview(noAdsCheckMarkView)
        stackView.addArrangedSubview(noAdsLabel)
        return stackView
    }()
    
    private lazy var noAdsLabel: UILabel = {
        let label = buildFeatureLabel()
        label.text = NSLocalizedString("Remove ads", comment: "")
        return label
    }()
    
    private lazy var noAdsCheckMarkView: UIView = {
        let contentView = UIView()
        let view = CheckMarkView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.color = secondaryColor
        contentView.addSubview(view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        return contentView
    }()
    
    private lazy var syncSection: UIStackView = {
        let stackView = buildFeatureStackView()
        stackView.addArrangedSubview(syncCheckMarkView)
        stackView.addArrangedSubview(syncLabel)
        return stackView
    }()
    
    private lazy var syncLabel: UILabel = {
        let label = buildFeatureLabel()
        label.text = NSLocalizedString("Enable full sync between multiple devices (including images)", comment: "")
        return label
    }()
    
    private lazy var syncCheckMarkView: UIView = {
        let contentView = UIView()
        let view = CheckMarkView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.color = secondaryColor
        contentView.addSubview(view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        return contentView
    }()
    
    private lazy var customizeSection: UIStackView = {
        let stackView = buildFeatureStackView()
        stackView.addArrangedSubview(customizeCheckMarkView)
        stackView.addArrangedSubview(customizeLabel)
        return stackView
    }()
    
    private lazy var customizeLabel: UILabel = {
        let label = buildFeatureLabel()
        label.text = NSLocalizedString("Fully customize each event", comment: "")
        return label
    }()
    
    private lazy var customizeCheckMarkView: UIView = {
        let contentView = UIView()
        let view = CheckMarkView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.color = secondaryColor
        contentView.addSubview(view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        contentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        return contentView
    }()
    
    private lazy var imagesSection: UIStackView = {
        let stackView = buildFeatureStackView()
        stackView.addArrangedSubview(imagesCheckMarkView)
        stackView.addArrangedSubview(imagesLabel)
        return stackView
    }()
    
    private lazy var imagesLabel: UILabel = {
        let label = buildFeatureLabel()
        label.text = NSLocalizedString("Download beautiful images for your events right from the app", comment: "")
        return label
    }()
    
    private lazy var imagesCheckMarkView: UIView = {
        let contentView = UIView()
        let view = CheckMarkView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.color = secondaryColor
        contentView.addSubview(view)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        contentView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 25).isActive = true
        return contentView
    }()
    
    private func buildFeatureStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16.0
        return stackView
    }
    
    private func buildFeatureLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .label
        label.font = label.font.withSize(15)
        label.numberOfLines = 0
        return label
    }
    
    private lazy var crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = crownImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var buyButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle(NSLocalizedString("Buy now", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = secondaryColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Restore Purchase", comment: ""), for: .normal)
        button.setTitleColor(secondaryColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        addTargets()
        setUpPremiumInformation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restorePreviousNavBarStyle()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(topBackgroundView)
        contentView.addSubview(upgradeTitle)
        contentView.addSubview(crownImageView)
        contentView.addSubview(mainStackView)
        contentView.addSubview(buyButton)
        contentView.addSubview(restoreButton)
    }
    
    private func addConstraints() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        topBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        topBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        topBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        topBackgroundView.heightAnchor.constraint(equalToConstant: 215).isActive = true
        topBackgroundView.setNeedsDisplay()
        topBackgroundView.layoutIfNeeded()
        
        upgradeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        upgradeTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        upgradeTitle.bottomAnchor.constraint(equalTo: topBackgroundView.bottomAnchor, constant: -45).isActive = true
        
        crownImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        crownImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        crownImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        crownImageView.bottomAnchor.constraint(equalTo: upgradeTitle.topAnchor, constant: -20).isActive = true
        
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        mainStackView.topAnchor.constraint(equalTo: topBackgroundView.bottomAnchor, constant: 30).isActive = true
        
        buyButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        buyButton.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 15, bottom: 0.0, right: 15)
        buyButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        buyButton.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20).isActive = true
        buyButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20).isActive = true
        buyButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 40).isActive = true
        buyButton.layoutIfNeeded()
        
        restoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        restoreButton.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: 10).isActive = true
        restoreButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40).isActive = true
    }
    
    private func addTargets() {
        buyButton.addTarget(self, action: #selector(launchPurchaseFlow), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(launchRestorationFlow), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
        name: .IAPHelperPurchaseNotification,
        object: nil)
    }
    
    @objc private func launchPurchaseFlow() {
        Products.store.buyProduct(premiumProduct!)
    }
    
    @objc private func launchRestorationFlow() {
        Products.store.restorePurchases()
    }
    
    @objc private func handlePurchaseNotification(_ notification: Notification) {
        disableBuyButton(withTitle: NSLocalizedString("Purchased", comment: ""))
    }
    
    private func setUpPremiumInformation() {
        guard !Defaults.isPremiumUser() else {
            disableBuyButton(withTitle: NSLocalizedString("Purchased", comment: ""))
            return
        }
        
        if Products.store.canMakePayments() {
            requestProducts()
        } else {
            disableBuyButton(withTitle: NSLocalizedString("Not available", comment: ""))
        }
    }
    
    private func requestProducts() {
        buyButton.toggleLoading(true)
        Products.store.requestProducts { [weak self] success, products in
            if success, let product = products?[0] {
                self?.premiumProduct = product
                self?.priceFormatter.locale = product.priceLocale
                let formattedPrice = self?.priceFormatter.string(from: product.price)
                let buttonTitle = NSLocalizedString("Buy now for ", comment: "") + formattedPrice!
                
                DispatchQueue.main.async {
                    self?.buyButton.toggleLoading(false)
                    self?.buyButton.setTitle(buttonTitle, for: .normal)
                }
            } else {
                DispatchQueue.main.async {
                    self?.buyButton.toggleLoading(false)
                    self?.disableBuyButton(withTitle: NSLocalizedString("Not available", comment: ""))
                }
            }
        }
    }
    
    private func disableBuyButton(withTitle: String) {
        buyButton.setTitle(withTitle, for: .normal)
        buyButton.isEnabled = false
    }
    
    private func styleNavBar() {
        previousNavBarBackgroundImage = navigationController?.navigationBar.backgroundImage(for: .default)
        previousNavBarShadowImage = navigationController?.navigationBar.shadowImage
        previousBackButtonColor = navigationController?.navigationBar.tintColor
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func restorePreviousNavBarStyle() {
        navigationController?.navigationBar.setBackgroundImage(previousNavBarBackgroundImage, for: .default)
        navigationController?.navigationBar.shadowImage = previousNavBarShadowImage
        navigationController?.navigationBar.tintColor = previousBackButtonColor
        navigationController?.navigationBar.barStyle = .default
    }
}

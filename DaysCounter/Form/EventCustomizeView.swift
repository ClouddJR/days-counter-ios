import UIKit

@IBDesignable
class EventCustomizeView: UIView {
    
    //Public
    
    var delegate: EventCustomizeViewDelegate?
    
    func show(){
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveEaseIn],
            animations: {
                self.center.y -= self.bounds.height
        })
    }
    
    @objc func hide(){
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.center.y += self.bounds.height
        }, completion: { completed in
            self.removeFromSuperview()
            self.delegate?.onViewRemovedFromSuperview()
        })
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delaysContentTouches = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Main vertical StackView
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 16.0
        stackView.addArrangedSubview(formatYearsSectionView)
        stackView.addArrangedSubview(formatMonthsSectionView)
        stackView.addArrangedSubview(formatWeeksSectionView)
        stackView.addArrangedSubview(formatDaysSectionView)
        stackView.addArrangedSubview(formatTimeSectionView)
        stackView.addArrangedSubview(fontColorSectionView)
        stackView.addArrangedSubview(fontColorPickerView)
        stackView.addArrangedSubview(fontTypeSectionView)
        stackView.addArrangedSubview(pictureDimSectionView)
        stackView.addArrangedSubview(cancelButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //Counter format- years
    
    lazy var formatYearsSectionView: UIStackView = {
        let stackView = buildSectionStackView()
        stackView.addArrangedSubview(formatYearsTitleLabel)
        stackView.addArrangedSubview(formatYearsSwitch)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var formatYearsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Years", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var formatYearsSwitch: UISwitch = {
        let yearsSwitch = UISwitch()
        yearsSwitch.onTintColor = UIColor(red: 242/255, green: 132/255, blue: 91/255, alpha: 1.0)
        yearsSwitch.setContentCompressionResistancePriority(.required, for: .horizontal)
        yearsSwitch.translatesAutoresizingMaskIntoConstraints = false
        return yearsSwitch
    }()
    
    //Counter format- months
    
    lazy var formatMonthsSectionView: UIStackView = {
        let stackView = buildSectionStackView()
        stackView.addArrangedSubview(formatMonthsTitleLabel)
        stackView.addArrangedSubview(formatMonthsSwitch)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var formatMonthsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Months", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var formatMonthsSwitch: UISwitch = {
        let monthsSwitch = UISwitch()
        monthsSwitch.onTintColor = UIColor(red: 242/255, green: 132/255, blue: 91/255, alpha: 1.0)
        monthsSwitch.setContentCompressionResistancePriority(.required, for: .horizontal)
        monthsSwitch.translatesAutoresizingMaskIntoConstraints = false
        return monthsSwitch
    }()
    
    //Counter format- weeks
    
    lazy var formatWeeksSectionView: UIStackView = {
        let stackView = buildSectionStackView()
        stackView.addArrangedSubview(formatWeeksTitleLabel)
        stackView.addArrangedSubview(formatWeeksSwitch)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var formatWeeksTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Weeks", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var formatWeeksSwitch: UISwitch = {
        let weeksSwitch = UISwitch()
        weeksSwitch.onTintColor = UIColor(red: 242/255, green: 132/255, blue: 91/255, alpha: 1.0)
        weeksSwitch.setContentCompressionResistancePriority(.required, for: .horizontal)
        weeksSwitch.translatesAutoresizingMaskIntoConstraints = false
        return weeksSwitch
    }()
    
    //Counter format- days
    
    lazy var formatDaysSectionView: UIStackView = {
        let stackView = buildSectionStackView()
        stackView.addArrangedSubview(formatDaysTitleLabel)
        stackView.addArrangedSubview(formatDaysSwitch)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var formatDaysTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Days", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var formatDaysSwitch: UISwitch = {
        let daysSwitch = UISwitch()
        daysSwitch.onTintColor = UIColor(red: 242/255, green: 132/255, blue: 91/255, alpha: 1.0)
        daysSwitch.isOn = true
        daysSwitch.setContentCompressionResistancePriority(.required, for: .horizontal)
        daysSwitch.translatesAutoresizingMaskIntoConstraints = false
        return daysSwitch
    }()
    
    //Counter format- time
    
    lazy var formatTimeSectionView: UIStackView = {
        let stackView = buildSectionStackView()
        stackView.addArrangedSubview(formatTimeTitleLabel)
        stackView.addArrangedSubview(formatTimeSwitch)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var formatTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Time", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var formatTimeSwitch: UISwitch = {
        let timeSwitch = UISwitch()
        timeSwitch.onTintColor = UIColor(red: 242/255, green: 132/255, blue: 91/255, alpha: 1.0)
        timeSwitch.setContentCompressionResistancePriority(.required, for: .horizontal)
        timeSwitch.translatesAutoresizingMaskIntoConstraints = false
        return timeSwitch
    }()
    
    //Font color
    
    lazy var fontColorSectionView: UIStackView = {
        let stackView = buildSectionStackView()
        stackView.addArrangedSubview(fontColorTitleLabel)
        stackView.addArrangedSubview(fontColorCircleView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var fontColorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Font color", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var fontColorCircleView: UIView = {
        let contentView = UIView()
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        circleView.layer.cornerRadius = circleView.frame.height / 2
        circleView.backgroundColor = .white
        contentView.addSubview(circleView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    //Font color picker
    
    lazy var fontColorPickerView: FontColorPickerView = {
        let picker = FontColorPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        return picker
    }()
    
    //Font type
    
    lazy var fontTypeSectionView: UIStackView = {
        let stackView = buildSectionStackView()
        stackView.addArrangedSubview(fontTypeTitleLabel)
        stackView.addArrangedSubview(fontTypeLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var fontTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Font type", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var fontTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Helvetica"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    //Picture dim
    
    lazy var pictureDimSectionView: UIStackView = {
        let stackView = buildSectionStackView()
        stackView.addArrangedSubview(pictureDimTitleLabel)
        stackView.addArrangedSubview(pictureDimSlider)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var pictureDimTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Picture dim", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pictureDimSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.2
        slider.tintColor = UIColor(red: 242/255, green: 132/255, blue: 91/255, alpha: 1.0)
        slider.setContentCompressionResistancePriority(.required, for: .horizontal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    //Premium prompt
    
    lazy var premiumDimView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.opacity = 0.85
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let crownImage = #imageLiteral(resourceName: "ic_crown")
    
    lazy var crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = crownImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var premiumLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("This feature is only available for premium users", comment: "")
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("More info", comment: ""), for: .normal)
        button.tintColor = UIColor(red: 242/255, green: 132/255, blue: 91/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //Cancel button
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        button.tintColor = UIColor(red: 242/255, green: 132/255, blue: 91/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //Font picker
    
    private lazy var fontPicker: UIPickerView  = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    //Back icon
    
    private let backIcon = #imageLiteral(resourceName: "ic_back")
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(backIcon, for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func buildSectionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 64.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)
        layer.cornerRadius = 20
        addSubviews()
        addTargetsAndGestureRecognizers()
        addConstraints()
        setUpPremiumPrompt()
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
        contentView.addSubview(fontPicker)
        contentView.addSubview(backButton)
        fontPicker.isHidden = true
        backButton.isHidden = true
        fontColorPickerView.isHidden = true
    }
    
    private func addTargetsAndGestureRecognizers() {
        formatYearsSwitch.addTarget(self, action: #selector(informObserversAboutSwitchValueChanged), for: .valueChanged)
        formatMonthsSwitch.addTarget(self, action: #selector(informObserversAboutSwitchValueChanged), for: .valueChanged)
        formatWeeksSwitch.addTarget(self, action: #selector(informObserversAboutSwitchValueChanged), for: .valueChanged)
        formatDaysSwitch.addTarget(self, action: #selector(informObserversAboutSwitchValueChanged), for: .valueChanged)
        formatTimeSwitch.addTarget(self, action: #selector(informObserversAboutSwitchValueChanged), for: .valueChanged)
        
        fontColorCircleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleFontColorPicker)))
        
        fontTypeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFontPickerWithAnimation)))
    
        pictureDimSlider.addTarget(self, action: #selector(informObserversAboutSliderTouchedDown), for: .touchDown)
        pictureDimSlider.addTarget(self, action: #selector(informObserversAboutSliderTouchedUp), for: .touchUpInside)
        pictureDimSlider.addTarget(self, action: #selector(informObserversAboutSliderTouchedUp), for: .touchUpOutside)
        pictureDimSlider.addTarget(self, action: #selector(informObserversAboutSliderValueChanged), for: .valueChanged)
        
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideFontPickerWithAnimation)))
        
        cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    @objc private func informObserversAboutSwitchValueChanged() {
        if allSwitchesAreOff() {
            formatDaysSwitch.setOn(true, animated: true)
        }
        delegate?.onSwitchValueChanged(
            formatYearsSwitch.isOn,
            formatMonthsSwitch.isOn,
            formatWeeksSwitch.isOn,
            formatDaysSwitch.isOn,
            formatTimeSwitch.isOn
        )
    }
    
    private func allSwitchesAreOff() -> Bool {
        return formatYearsSwitch.isOn == false &&
        formatMonthsSwitch.isOn == false &&
        formatWeeksSwitch.isOn == false &&
        formatDaysSwitch.isOn == false
    }
    
    @objc private func informObserversAboutSliderTouchedDown() {
        hideOtherSectionsWhileEditing()
        delegate?.onSliderTouchedDown()
    }
    
    private func hideOtherSectionsWhileEditing() {
        formatYearsSectionView.isHidden = true
        formatYearsSectionView.alpha = 0.0
        formatMonthsSectionView.isHidden = true
        formatMonthsSectionView.alpha = 0.0
        formatWeeksSectionView.isHidden = true
        formatWeeksSectionView.alpha = 0.0
        formatDaysSectionView.isHidden = true
        formatDaysSectionView.alpha = 0.0
        formatTimeSectionView.isHidden = true
        formatTimeSectionView.alpha = 0.0
        fontColorSectionView.isHidden = true
        fontColorSectionView.alpha = 0.0
        fontColorPickerView.isHidden = true
        fontColorPickerView.alpha = 0.0
        fontTypeSectionView.isHidden = true
        fontTypeSectionView.alpha = 0.0
        layoutIfNeeded()
    }
    
    @objc private func informObserversAboutSliderTouchedUp() {
        showOtherSectionsAfterEditing()
        delegate?.onSliderTouchedUp()
    }
    
    private func showOtherSectionsAfterEditing() {
        formatYearsSectionView.isHidden = false
        formatYearsSectionView.alpha = 1.0
        formatMonthsSectionView.isHidden = false
        formatMonthsSectionView.alpha = 1.0
        formatWeeksSectionView.isHidden = false
        formatWeeksSectionView.alpha = 1.0
        formatDaysSectionView.isHidden = false
        formatDaysSectionView.alpha = 1.0
        formatTimeSectionView.isHidden = false
        formatTimeSectionView.alpha = 1.0
        fontColorSectionView.isHidden = false
        fontColorSectionView.alpha = 1.0
        fontColorPickerView.alpha = 1.0
        fontTypeSectionView.isHidden = false
        fontTypeSectionView.alpha = 1.0
        layoutIfNeeded()
    }
    
    @objc private func informObserversAboutSliderValueChanged() {
        delegate?.onSliderValueChanged(pictureDimSlider.value)
    }
    
    @objc private func showFontPickerWithAnimation() {
        fontPicker.selectRow(UIFont.familyNames.firstIndex(of: fontTypeLabel.text!)!, inComponent: 0, animated: false)
        //move font picker and back icon to the right for the animation
        fontPicker.center.x = bounds.midX + fontPicker.bounds.width
        backButton.frame.origin = CGPoint(x: 15 + fontPicker.bounds.width, y: 15)
        fontPicker.isHidden = false
        backButton.isHidden = false
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.mainStackView.center.x -= self.mainStackView.bounds.width
                self.fontPicker.center.x -= self.fontPicker.bounds.width
                self.backButton.center.x -= self.fontPicker.bounds.width
        }, completion: { completed in
            self.mainStackView.isHidden = true
        })
    }
    
    @objc private func hideFontPickerWithAnimation() {
        //move main stack view to the left for the animation
        mainStackView.center.x = bounds.midX - mainStackView.bounds.width
        mainStackView.isHidden = false
        UIView.animate(
            withDuration: 0.25,
            animations: {
                self.mainStackView.center.x += self.mainStackView.bounds.width
                self.fontPicker.center.x += self.fontPicker.bounds.width
                self.backButton.center.x += self.fontPicker.bounds.width
        }, completion: { completed in
            self.fontPicker.isHidden = true
            self.backButton.isHidden = true
        })
    }
    
    @objc private func toggleFontColorPicker() {
        UIView.animate(withDuration: 0.25) {
            self.fontColorPickerView.isHidden = !self.fontColorPickerView.isHidden
            self.mainStackView.layoutIfNeeded()
        }
    }
    
    private func addConstraints() {
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        
        fontPicker.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        fontPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        fontPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        fontColorPickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        fontColorPickerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        
        layoutIfNeeded()
    }
    
    private func setUpPremiumPrompt() {
        if !Defaults.isPremiumUser() {
            scrollView.isUserInteractionEnabled = false
            addSubview(premiumDimView)
            addSubview(crownImageView)
            addSubview(premiumLabel)
            addSubview(moreInfoButton)
            premiumDimView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            premiumDimView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            premiumDimView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            premiumDimView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            
            crownImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            crownImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60).isActive = true
            crownImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            crownImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            
            premiumLabel.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: 10).isActive = true
            premiumLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
            premiumLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
            
            moreInfoButton.topAnchor.constraint(equalTo: premiumLabel.bottomAnchor, constant: 10).isActive = true
            moreInfoButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            moreInfoButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            moreInfoButton.addTarget(self, action: #selector(showPremiumViewController), for: .touchUpInside)
        }
    }
    
    @objc private func showPremiumViewController() {
        delegate?.onPremiumButtonClicked()
    }
}

// MARK:  font picker delegate

extension EventCustomizeView : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view:
        UIView?) -> UIView {
        
        let label = view as? UILabel ?? UILabel()
        let fontName = UIFont.familyNames[row]
        label.font = UIFont(name: fontName, size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = fontName
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let fontName = UIFont.familyNames[row]
        fontTypeLabel.text = fontName
        delegate?.onFontTypeChanged(fontName)
    }
}

// MARK:  font picker data source

extension EventCustomizeView : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return UIFont.familyNames.count
    }
}

// MARK:  FontColorPickerView delegate

extension EventCustomizeView : FontColorPickerViewDelegate {
    func onColorChanged(_ color: UIColor) {
        fontColorCircleView.subviews[0].backgroundColor = color
        delegate?.onFontColorChanged(color)
    }
}


protocol EventCustomizeViewDelegate {
    func onViewRemovedFromSuperview()
    func onSliderTouchedDown()
    func onSliderTouchedUp()
    func onSliderValueChanged(_ value: Float)
    func onFontTypeChanged(_ fontName: String)
    func onFontColorChanged(_ color: UIColor)
    func onSwitchValueChanged(_ areYearsIncluded: Bool, _ areMonthsIncluded: Bool, _ areWeeksIncluded: Bool,
                              _ areDaysIncluded: Bool, _ isTimeIncluded: Bool)
    func onPremiumButtonClicked()
}

import UIKit
import NotificationCenter
import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var realm: Realm!
    var futureEvents: Results<Event>!
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("There are no upcoming events", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var eventImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var eventImageDim: UIView = {
        let view = UIView(frame: CGRect(origin: self.view.bounds.origin, size: self.view.bounds.size))
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.opacity = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Constants.dateStackViewSpacing
        stackView.addArrangedSubview(yearStackView)
        stackView.addArrangedSubview(monthStackView)
        stackView.addArrangedSubview(weekStackView)
        stackView.addArrangedSubview(dayStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var yearStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(yearNumberLabel)
        stackView.addArrangedSubview(yearTitleLabel)
        return stackView
    }()
    
    private lazy var yearNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        return label
    }()
    
    private lazy var yearTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = label.font.withSize(Constants.dateStackViewTitle)
        return label
    }()
    
    private lazy var monthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(monthNumberLabel)
        stackView.addArrangedSubview(monthTitleLabel)
        return stackView
    }()
    
    private lazy var monthNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        return label
    }()
    
    private lazy var monthTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = label.font.withSize(Constants.dateStackViewTitle)
        return label
    }()
    
    private lazy var weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(weekNumberLabel)
        stackView.addArrangedSubview(weekTitleLabel)
        return stackView
    }()
    
    private lazy var weekNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        return label
    }()
    
    private lazy var weekTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = label.font.withSize(Constants.dateStackViewTitle)
        return label
    }()
    
    private lazy var dayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(dayNumberLabel)
        stackView.addArrangedSubview(dayTitleLabel)
        return stackView
    }()
    
    private lazy var dayNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        return label
    }()
    
    private lazy var dayTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = label.font.withSize(Constants.dateStackViewTitle)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.titleLabelSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.dateLabelSize, weight: .ultraLight)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .compact
        initRealm()
        addSubviews()
        setConstraints()
        if let upcomingEvent = futureEvents.first {
            updateView(with: upcomingEvent)
            noDataLabel.isHidden = true
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    private func initRealm() {
        var config = Realm.Configuration()
        config.fileURL = AppGroup.containerUrl.appending(path: "db.realm")
        
        realm = try! Realm(configuration: config)
        futureEvents = realm.objects(Event.self).filter(NSPredicate(format: "date >= %@", NSDate())).sorted(byKeyPath: "date")
    }
    
    private func addSubviews() {
        view.addSubview(noDataLabel)
        view.addSubview(eventImage)
        view.addSubview(eventImageDim)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(dateStackView)
    }
    
    private func setConstraints() {
        noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        eventImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        eventImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        eventImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        eventImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        eventImage.layer.cornerRadius = 10
        
        eventImageDim.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        eventImageDim.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        eventImageDim.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        eventImageDim.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        eventImageDim.layer.cornerRadius = 10
        
        dateLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: eventImage.leadingAnchor, constant: 10).isActive = true
        
        titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -6).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: eventImage.leadingAnchor, constant: 10).isActive = true
        
        dateStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        dateStackView.trailingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: -10).isActive = true
    }
    
    func updateView(with event: Event) {
        titleLabel.text = event.name
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = !event.isEntireDay ? .short : .none
        let eventDate = EventOperator.getDate(from: event)
        dateLabel.text = formatter.string(from: eventDate)
        eventImage.image = EventOperator.getImage(from: event)
        eventImageDim.layer.opacity = event.imageDim
        
        titleLabel.textColor = EventOperator.getFontColor(from: event)
        dateLabel.textColor = EventOperator.getFontColor(from: event)
        yearNumberLabel.textColor = EventOperator.getFontColor(from: event)
        yearTitleLabel.textColor = EventOperator.getFontColor(from: event)
        monthNumberLabel.textColor = EventOperator.getFontColor(from: event)
        monthTitleLabel.textColor = EventOperator.getFontColor(from: event)
        weekNumberLabel.textColor = EventOperator.getFontColor(from: event)
        weekTitleLabel.textColor = EventOperator.getFontColor(from: event)
        dayNumberLabel.textColor = EventOperator.getFontColor(from: event)
        dayTitleLabel.textColor = EventOperator.getFontColor(from: event)
        
        titleLabel.font = UIFont(name: event.fontType, size: titleLabel.font.pointSize)
        dateLabel.font = UIFont(name: event.fontType, size: dateLabel.font.pointSize)
        yearNumberLabel.font = UIFont(name: event.fontType, size: yearNumberLabel.font.pointSize)
        yearTitleLabel.font = UIFont(name: event.fontType, size: yearTitleLabel.font.pointSize)
        monthNumberLabel.font = UIFont(name: event.fontType, size: monthNumberLabel.font.pointSize)
        monthTitleLabel.font = UIFont(name: event.fontType, size: monthTitleLabel.font.pointSize)
        weekNumberLabel.font = UIFont(name: event.fontType, size: weekNumberLabel.font.pointSize)
        weekTitleLabel.font = UIFont(name: event.fontType, size: weekTitleLabel.font.pointSize)
        dayNumberLabel.font = UIFont(name: event.fontType, size: dayNumberLabel.font.pointSize)
        dayTitleLabel.font = UIFont(name: event.fontType, size: dayTitleLabel.font.pointSize)
        
        let calculatedComponents = DateCalculator.calculateDate(eventDate: eventDate, areYearsIncluded: event.areYearsIncluded, areMonthsIncluded: event.areMonthsIncluded, areWeekIncluded: event.areWeeksIncluded, areDaysIncluded: event.areDaysIncluded, isTimeIncluded: false)
        
        if let years = calculatedComponents.years {
            yearTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Years title", comment: ""), years)
            yearNumberLabel.text = String(years)
        }
        
        if let months = calculatedComponents.months {
            monthTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Months title", comment: ""), months)
            monthNumberLabel.text = String(months)
        }
        
        if let weeks = calculatedComponents.weeks {
            weekTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Weeks title", comment: ""), weeks)
            weekNumberLabel.text = String(weeks)
        }
        
        if let days = calculatedComponents.days {
            dayTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Days title", comment: ""), days)
            dayNumberLabel.text = String(days)
        }
        
        yearStackView.removeFromSuperview()
        monthStackView.removeFromSuperview()
        weekStackView.removeFromSuperview()
        dayStackView.removeFromSuperview()
        
        if event.areYearsIncluded {dateStackView.addArrangedSubview(yearStackView)}
        if event.areMonthsIncluded {dateStackView.addArrangedSubview(monthStackView)}
        if event.areWeeksIncluded {dateStackView.addArrangedSubview(weekStackView)}
        if event.areDaysIncluded {dateStackView.addArrangedSubview(dayStackView)}
    }
    
}

extension TodayViewController {
    struct Constants {
        static let titleLabelSize: CGFloat = 15
        static let dateLabelSize: CGFloat = 11
        static let dateStackViewSpacing: CGFloat = 15.0
        static let dateStackViewNumber: CGFloat = 24.0
        static let dateStackViewTitle: CGFloat = 11.0
    }
}

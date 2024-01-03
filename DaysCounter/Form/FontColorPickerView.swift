import UIKit

final class FontColorPickerView: UIView {
    var delegate: FontColorPickerViewDelegate?
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 25, height: 25)
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "color cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var colorCellsData = [
        ColorCellData(isSelected: true, color: .white),
        ColorCellData(isSelected: false, color: .black),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 1, green: 0.4243971756, blue: 0.464074077, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 1, green: 0.9490196078, blue: 0.3019607843, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 1, green: 0.5856890984, blue: 0.8705704725, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)),
        ColorCellData(isSelected: false, color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)),
    ]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func updateFontColor(with color: UIColor) {
        let index = colorCellsData.firstIndex { data in data.color == color }!
        let indexPath = IndexPath(row: index, section: 0)
        
        unselectCells()
        colorCellsData[index].isSelected = true
        colorCollectionView.reloadItems(at: [indexPath])
    }
    
    private func setupView() {
        addSubview(colorCollectionView)
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        colorCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        colorCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        colorCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    private func unselectCells() {
        colorCellsData.indices.forEach {
            // Reload previously selected cell
            if colorCellsData[$0].isSelected {
                colorCellsData[$0].isSelected = false
                colorCollectionView.reloadItems(at: [IndexPath(row: $0, section: 0)])
            }
            colorCellsData[$0].isSelected = false
        }
    }
}

extension FontColorPickerView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorCellsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "color cell", for: indexPath) as? ColorCell ?? ColorCell()
        cell.setupView(colorCellsData[indexPath.row].isSelected, colorCellsData[indexPath.row].color)
        return cell
    }
}

extension FontColorPickerView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        unselectCells()
        if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell {
            cell.setupView(true, colorCellsData[indexPath.row].color)
            colorCellsData[indexPath.row].isSelected = true
        }
        delegate?.onColorChanged(colorCellsData[indexPath.row].color)
    }
}

private class ColorCell: UICollectionViewCell {
    private lazy var circleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.layer.cornerRadius = view.bounds.size.width / 2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(circleView)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(circleView)
        setupView()
    }
    
    func setupView(_ isChosen: Bool = false, _ color: UIColor = .white) {
        if isChosen {
            layer.borderWidth = 2
            layer.borderColor = UIColor.white.cgColor
            circleView.bounds.size.width = 16
            circleView.bounds.size.height = 16
        } else {
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
            circleView.bounds.size.width = 25
            circleView.bounds.size.height = 25
        }
        circleView.layer.cornerRadius = circleView.bounds.size.width / 2
        circleView.backgroundColor = color
        backgroundColor = .clear
        layer.cornerRadius = bounds.size.width / 2
    }
}

private struct ColorCellData {
    var isSelected = false
    var color = UIColor.white
}

protocol FontColorPickerViewDelegate {
    func onColorChanged(_ color: UIColor)
}

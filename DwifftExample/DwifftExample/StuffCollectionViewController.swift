//
//  StuffCollectionViewController.swift
//  DwifftExample
//
//  Created by Jack Flintermann on 3/29/17.
//  Copyright © 2017 jflinter. All rights reserved.
//

import UIKit
import Dwifft

private let reuseIdentifier = "Cell"

class StuffCollectionViewCell: UICollectionViewCell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        self.label.frame = self.bounds
    }
}

class StuffCollectionViewController: UICollectionViewController {

    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(StuffCollectionViewController.shuffle))
    }

    @objc func shuffle() {
        self.stuff = Stuff.emojiStuff()
    }

    var stuff: SectionedValues<String, String> = Stuff.emojiStuff() {
        // So, whenever your datasource's array of things changes, just let the diffCalculator know and it'll do the rest.
        didSet {
            self.diffCalculator?.rowsAndSections = stuff
        }
    }

    var diffCalculator: CollectionViewDiffCalculator<String, String>?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = self.collectionView else { return }
        self.diffCalculator = CollectionViewDiffCalculator(collectionView: collectionView, initialRowsAndSections: self.stuff)

        // Register cell classes
        self.collectionView!.register(StuffCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.diffCalculator?.numberOfSections() ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diffCalculator?.numberOfObjects(inSection: section) ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StuffCollectionViewCell
        guard let diffCalculator = self.diffCalculator else { return cell }
        let thing = diffCalculator.value(atIndexPath: indexPath)
        cell.label.text = thing
        return cell
    }

}
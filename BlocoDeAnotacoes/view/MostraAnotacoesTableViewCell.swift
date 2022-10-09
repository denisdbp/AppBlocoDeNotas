//
//  MostraAnotacoesTableViewCell.swift
//  BlocoDeAnotacoes
//
//  Created by Admin on 11/09/22.
//

import UIKit

class MostraAnotacoesTableViewCell: UITableViewCell {
    
    static let identifier:String = "MostraAnotacoesTableViewCell"
    
    @IBOutlet weak var tituloAnotacaoLabel: UILabel!
    @IBOutlet weak var anotacaoLabel: UILabel!
    @IBOutlet weak var ultimaAlteracaoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configViewCell()
        self.configAcessibilidade()
    }
    
    private func configAcessibilidade(){
        self.tituloAnotacaoLabel.isAccessibilityElement = true
        self.tituloAnotacaoLabel.accessibilityLabel = "Titulo da Anotação"
        self.tituloAnotacaoLabel.accessibilityTraits = .staticText
        self.anotacaoLabel.isAccessibilityElement = true
        self.anotacaoLabel.accessibilityLabel = "Descrição da Anotação"
        self.anotacaoLabel.accessibilityTraits = .staticText
        self.ultimaAlteracaoLabel.isAccessibilityElement = true
        self.ultimaAlteracaoLabel.accessibilityLabel = "Data da ultima alteração da anotação"
        self.ultimaAlteracaoLabel.accessibilityTraits = .staticText
        self.tituloAnotacaoLabel.adjustsFontForContentSizeCategory = true
        self.anotacaoLabel.adjustsFontForContentSizeCategory = true
        self.ultimaAlteracaoLabel.adjustsFontForContentSizeCategory = true
        self.contentView.isAccessibilityElement = true
        self.contentView.accessibilityLabel = "Células referente a lista das anotações"
    }
    
    private func configViewCell(){
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 225.0/255.0, alpha: 1)
    }
}

//
//  Chuveiro.swift
//  Banho Rapido
//
//  Created by José Henrique Fernandes Silva on 10/03/20.
//  Copyright © 2020 José Henrique Fernandes Silva. All rights reserved.
//

import Foundation

class Chuveiro {
    var vazao: Double
    var eletrico: String
    
    init(vazao: Double, eletrico: String) {
        self.vazao = vazao
        self.eletrico = eletrico
    }
    
    func calculaGastoAgua(minutos: Int, segundos: Int) -> Double {
        var quantidadeAgua:Double
        quantidadeAgua = (Double(minutos) * vazao) + ((Double(segundos) / 60) * vazao)
        
        if eletrico == "Não" {
            quantidadeAgua = quantidadeAgua * 3
        }
        
        return quantidadeAgua
    }
}


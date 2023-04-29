//
//  BitBoard.swift
//  Swift Checkers
//
//

import Foundation

public struct BitBoard {
    public typealias Mask = UInt32
    public typealias MaskIndex = Int
    public typealias CheckIndex = Int

    let white: Mask
    let black: Mask
    let queen: Mask

    let player: Bool
    let range: Range<Int>

    public init() {
        self.init(white: 0x00000FFF, black: 0xFFF00000, queen: 0, player: false)
    }

    public init(white: Mask, black: Mask, queen: Mask, player: Bool, range: Range<Int> = 0..<256) {
        if white & black != 0 {
            fatalError("white and black pieces in the same check")
        }

        if (white | black) & queen != queen {
            fatalError("queen must have a side")
        }

        self.white = white
        self.black = black
        self.queen = queen
        self.player = player
        self.range = range
    }
}

extension BitBoard.Mask {
    public init(maskIndex: BitBoard.MaskIndex) {
        self.init(1 << maskIndex)
    }

    public var description: String {
        return "\(BitBoard(white: self, black: 0, queen: 0, player: false))"
    }

    public func hasIndex(maskIndex: BitBoard.MaskIndex) -> Bool {
        return self & BitBoard.Mask(maskIndex: maskIndex) != 0
    }

    public func indexSet() -> [BitBoard.MaskIndex] {
        return (0..<self.bitWidth).compactMap { self.hasIndex(maskIndex: $0) ? $0 : nil }
    }

    public func checkSet() -> [BitBoard.CheckIndex] {
        return self.indexSet().map { $0.checkIndex() }
    }
}

extension BitBoard.MaskIndex {
    public init(checkIndex: BitBoard.CheckIndex) {
        self = checkIndex >> 1
    }

    public func checkIndex() -> BitBoard.CheckIndex {
        return self << 1 + (self >> 2 & 1)
    }
}

extension BitBoard: CustomStringConvertible {
    public var description: String {
        let check = { (mask: Mask) -> String in
            if self.white & mask != 0 {
                return self.queen & mask != 0 ? "◆" : "●"
            }
            if self.black & mask != 0 {
                return self.queen & mask != 0 ? "◇" : "○"
            }
            return " "
        }

        let top = "┌─┬─┬─┬─┬─┬─┬─┬─┐"
        let bot = "└─┴─┴─┴─┴─┴─┴─┴─┘"
        let header = (0..<8).reduce(""){ "\($0) \($1)" } + (player ? "  ○" : "  ●") + "\n\(top)\n"
        let lines = (0..<8).reversed().reduce(header) { res, row in
            let cols = (0..<4).reduce("") { cur, col in
                let check = "\(check(1 << (row * 4 + col)))"
                let (first, second) = (row & 1 != 0) ? (" ", check) : (check, " ")

                return cur + "\(first)│\(second)│"
            }

            return res + "│\(cols) \(row)\n"
            } + "\(bot)\n"

        return lines
    }
}

extension BitBoard: Sequence {

    static let allMovements = 0..<256

    var isContinuation: Bool { return range != BitBoard.allMovements }

    // цей ітератор пропускатиме проміжні захоплення
    public func makeIterator() -> AnyIterator<BitBoard> {
        var stack = [self.makeIteratorCont()]

        return AnyIterator {
            while let iter = stack.popLast() {
                // якщо це останній елемент у цьому ітераторі, перейти до наступного
                guard let res = iter.next() else { continue }

                // додати назад поточний ітератор
                stack.append(iter)

                // якщо це не продовження, повернути його негайно
                guard res.isContinuation else { return res }

                // повертаємо дошку або повторюємо захоплення
                let next = res.makeIteratorCont()
                stack.append(next)
            }
            return nil
        }
    }

    // цей ітератор повертає всі можливі наступні рухи
    public func makeIteratorCont() -> AnyIterator<BitBoard> {
        var i = self.range.startIndex
        var hasCaptured = false

        let moveMask: [Mask] = [0xF0808080, 0xF1010101, 0x8080808F, 0x0101010F] // не може рухатися в цьому напрямку
        let captMask: [Mask] = [0xFF888888, 0xFF111111, 0x888888FF, 0x111111FF] // неможливо захопити в цьому напрямку
        let (playerMask, opponentMask) = player ? (black, white) : (white, black)
        let empty: Mask = ~(white|black)

        let board = self

        return AnyIterator {

            // 0..127 - захоплення, 128..257 - переміщення
            while i < self.range.endIndex {
                let idx = (i >> 2) & 31   // індекс маски
                let dir = i & 3           // один із чотирьох напрямків
                let this = Mask(1 << idx) // поточний фрагмент
                let cap = i < 128         // захоплення або переміщення
                i += 1

                // завершуємо відразу, якщо ми рухаємось і можемо захопити
                guard cap || !hasCaptured else { break }

                // тільки зайняті чеки
                guard empty & this == 0 else { continue }

                // перевірка на захоплення або рух у цьому напрямку для гравця
                guard ~(cap ? captMask : moveMask)[dir] & this & playerMask != 0 else { continue }

                // перевірити, чи може гравець захопити або рухатися в цьому напрямку, чи це ферзь
                let isQueen = board.queen & this != 0
                let isForward = board.player == (dir & 2 != 0)
                guard isQueen || isForward else { continue }

                let odd = (idx >> 2 & 1) // 1, якщо рядок непарний
                let wst = (dir & 1)      // 1, якщо напрямок на захід
                let sth = (dir & 2) << 2 // 8, якщо напрямок на південь

                // маска радіуса 1
                let adj1 = idx + odd - wst - sth
                let mask1 = Mask(0x10 << adj1)

                // перевірка на опонента або порожній чек
                guard mask1 & (cap ? opponentMask : empty) != 0 else { continue }

                let playerXor: Mask
                let opponentXor: Mask

                if cap {
                    // маска радіуса 2
                    let adj2 = idx - (wst << 1) - (sth << 1) + 9
                    let mask2 = Mask(1 << adj2)

                    // перевірити порожній чек
                    guard mask2 & empty != 0 else { continue }

                    hasCaptured = true
                    playerXor = mask2
                    opponentXor = mask1

                } else {
                    playerXor = mask1
                    opponentXor = 0
                }

                // захоплення та переміщення гравця
                let newPlayerMask = playerMask ^ this ^ playerXor
                let newOpponentMask = opponentMask ^ opponentXor
                let (newWhite, newBlack) = board.player ? (newOpponentMask, newPlayerMask) : (newPlayerMask, newOpponentMask)

                // просування королеви, пересування та захоплення
                let newQueenMaskPromo = playerXor & (board.player ? 0xf : 0xf0000000)
                let newQueenMaskPlayer = (isQueen ? this | playerXor : 0) | (board.queen & opponentXor)
                let newQueenMask = board.queen ^ newQueenMaskPlayer | newQueenMaskPromo 

                // для захоплень, які не є просуваннями, продовжити захоплення
                let new = (idx - (wst << 1) - (sth << 1) + 9) << 2
                let cont = cap && (isQueen || (newQueenMaskPromo == 0))
                let range = cont ? new..<(new + 4) : BitBoard.allMovements
                let newPlayer = cont ? board.player : !board.player

                let res = BitBoard(white: newWhite, black: newBlack, queen: newQueenMask, player: newPlayer, range: range)

                return res
            }

            // при дослідженні продовжень, а їх немає, повернути себе та зворотні сторони
            if !hasCaptured && self.isContinuation {
                hasCaptured = true
                return BitBoard(white: board.white, black: board.black, queen: board.queen, player: !board.player)
            }

            return nil
        }
    }

    func applyMove(from: MaskIndex, to: MaskIndex) -> BitBoard? {

        // застосувати хід до маски гравця
        let playerMask = (player ? black : white) ^ (Mask(maskIndex: from) | Mask(maskIndex: to))

        // знайти перший хід, коли позиція гравця відповідає очікуваній
        guard let result = makeIteratorCont().first(where: {
            playerMask == (player ? $0.black : $0.white)
        }) else {
            // недійсний рух
            return nil
        }

        // перевірити, чи потрібно нам продовжувати захоплення, якщо ні, просто повернути наступний
        if result.isContinuation {
            guard let next = result.makeIteratorCont().next() else { return nil }
            guard next.player == result.player else { return next }
        }

        return result
    }
}


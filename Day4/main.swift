import Foundation

func read(file: String) -> [String]? {
    guard let fileContents = try? String(contentsOfFile: file, encoding: .utf8) else {
        print("Failed to read file")
            return nil
    }

    var lines = fileContents.components(separatedBy: "\n")

    if let lastLine = lines.last, lastLine.isEmpty {
        lines.removeLast()
    }

    return lines
}

enum InputType: String {
    case full = "./Input.txt"
    case sample = "./SampleInput.txt"
}

let file: InputType = .full

guard let inputs = read(file: file.rawValue) else {
    print("Failed to open")
    exit(1)
}

// MARK: - Part One

enum Direction: CaseIterable {
    case up
    case down
    case left
    case right
    case upRight
    case upLeft
    case downRight
    case downLeft
}

func partOne() {
    let inputs = inputs.map { input -> [String] in
        input.map { String($0) }
    }

    let rows = inputs.count
    let columns = inputs.first!.count

    func isXMAS(_ string: String) -> Bool {
        return string == "XMAS"
    }

    func search(_ string: String, x: Int, y: Int, direction: Direction) -> Int {

        guard string.count < 4 else {
            return isXMAS(string) ? 1 : 0
        }

        guard 0..<rows ~= x && 0..<columns ~= y else { return 0 }

        let string = string + inputs[x][y]

        switch direction {
        case .up:
            return search(string, x: x - 1, y: y, direction: direction)

        case .down:
            return search(string, x: x + 1, y: y, direction: direction)

        case .left:
            return search(string, x: x, y: y - 1, direction: direction)

        case .right:
            return search(string, x: x, y: y + 1, direction: direction)

        case .upRight:
            return search(string, x: x - 1, y: y + 1, direction: direction)

        case .upLeft:
            return search(string, x: x - 1, y: y - 1, direction: direction)

        case .downRight:
            return search(string, x: x + 1, y: y + 1, direction: direction)

        case .downLeft:
            return search(string, x: x + 1, y: y - 1, direction: direction)
        }
    }

    var total = 0

    for i in 0..<rows {
        for j in 0..<columns {
            guard inputs[i][j] == "X" else { continue }
            for direction in Direction.allCases { // This is objectively terrible, but it's late. Refactor (maybe) this :D.
                total += search("", x: i, y: j, direction: direction)
            }
        }
    }

    print(total)
}

partOne()

// MARK: - Part 2

func partTwo() {
    let inputs = inputs.map { input -> [String] in
        input.map { String($0) }
    }

    let rows = inputs.count
    let columns = inputs.first!.count

    func isMAS(_ string: String) -> Bool {
        string == "MAS" || string == "SAM"
    }

    func isCrossMAS(x: Int, y: Int) -> Bool {
        // Automatically false if x or y +/- 1 is out of bounds.    
        guard 0..<rows ~= x - 1, 0..<rows ~= x + 1 else { return false }
        guard 0..<columns ~= y - 1, 0..<columns ~= y + 1 else { return false }

        let middle = inputs[x][y]

        let topLeft = inputs[x - 1][y - 1]
        let bottomRight = inputs[x + 1][y + 1]
        let first = topLeft + middle + bottomRight

        let topRight = inputs[x - 1][y + 1]
        let bottomLeft = inputs[x + 1][y - 1]
        let second = topRight + middle + bottomLeft

        return isMAS(first) && isMAS(second)
    }

    var count = 0

    for i in 0..<rows {
        for j in 0..<columns {
            guard inputs[i][j] == "A" else { continue }
            count += isCrossMAS(x: i, y: j) ? 1 : 0
        }
    }

    print(count)
}

partTwo()


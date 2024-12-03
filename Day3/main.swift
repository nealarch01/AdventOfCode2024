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

let file = InputType.full

guard let inputs = read(file: file.rawValue) else {
    print("Failed to open")
    exit(1)
}

// MARK: - Helpers

func getOperations(_ inputs: [String]) -> [String] {
    let mulPattern = "mul\\([0-9]+,[0-9]+\\)"

    let regex = try! NSRegularExpression(pattern: mulPattern)

    return inputs.flatMap { input in
        regex.matches(in: input, range: NSRange(input.startIndex..., in: input)).map { match -> String in
            let range = Range(match.range, in: input)!
            return String(input[range])
        }
    }
}

func getProducts(_ operations: [String]) -> [Int] {
    let numberPattern = "[0-9]+"

    let numberRegex = try! NSRegularExpression(pattern: numberPattern)

    return operations.map { operation -> Int in
        let numbers = numberRegex.matches(in: operation, range: NSRange(operation.startIndex..., in: operation)).map { match in
            let range = Range(match.range, in: operation)!
            return Int(operation[range])!
        }

        return numbers.reduce(1, { $0 * $1 })
    }
}

// MARK: - Part One

func partOne() {
    let operations = getOperations(inputs)
    print(getProducts(operations).reduce(0, { $0 + $1 }))
}

partOne()

// MARK: - Part Two

func partTwo() {
    let conditionalPattern = "don\\'t\\(\\)(.*?)do\\(\\)"

    let fullRegex = try! NSRegularExpression(pattern: conditionalPattern)

    let compactedInputs = inputs.compactMap { $0 }.joined(separator: "")

    let range = NSRange(compactedInputs.startIndex..., in: compactedInputs)

    let transformed = fullRegex.stringByReplacingMatches(in: compactedInputs, options: [], range: range, withTemplate: "")

    let operations = getOperations([transformed])

    let products = getProducts(operations)

    print(products.reduce(0, { $0 + $1 }))
}

partTwo()



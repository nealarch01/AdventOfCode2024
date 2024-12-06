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

var savedRules: [Int:[Int]]?

func getRules() -> [Int:[Int]] {
    if savedRules != nil { return savedRules! }

    let rulesPattern = "[0-9]+\\|[0-9]+"
    let rulesRegex = try! NSRegularExpression(pattern: rulesPattern)

    let rules = inputs.map { input in
        let range = NSRange(input.startIndex..., in: input)
        return rulesRegex.matches(in: input, range: range).map { match in
            let range = Range(match.range, in: input)!
            return String(input[range])
        }
    }
    .filter { !$0.isEmpty }
    .compactMap { $0.first! }

    var rulesDictionary = [Int:[Int]]()
    rules.forEach { rule in
        let rule = rule.components(separatedBy: "|")
        let key = Int(rule.first!)!
        let value = Int(rule.last!)!
        if let existingValue = rulesDictionary[key] {
            rulesDictionary[key] = existingValue + [value]
        } else {
            rulesDictionary[key] = [value]
        }
    }

    savedRules = rulesDictionary

    return rulesDictionary
}

func getUpdates() -> [[Int]] {
    let updatePattern = "[0-9]+(,[0-9]+)+"
    let updateRegex = try! NSRegularExpression(pattern: updatePattern)

    let updates = inputs.map { input in
        let range = NSRange(input.startIndex..., in: input)
        return updateRegex.matches(in: input, range: range).compactMap { match -> [Int]? in
            let range = Range(match.range, in: input)!
            let string = input[range]
            guard !string.isEmpty else { return nil }
            return string.components(separatedBy: ",").map { number in
                Int(number)!
            }
        }
        .flatMap { $0 }
    }
    .filter { !$0.isEmpty }

    return updates
}

func isUpdateValid(_ update: inout [Int]) -> Bool {
    let rules = getRules()
    for index in 0..<update.count - 1 {
        if let followingNumbers = rules[update[index]], followingNumbers.contains(update[index + 1]) {
            continue
        }
        return false
    }

    return true
}

func getUpdateTypes() -> (correct: [[Int]], incorrect: [[Int]]) {
    let updates = getUpdates()

    var correct = [[Int]]()
    var incorrect = [[Int]]()

    updates.forEach { update in
        var update = update
        if isUpdateValid(&update) {
            correct.append(update)
        } else {
            incorrect.append(update)
        }
    }

    return(correct: correct, incorrect: incorrect)
}

func middleSum(for updates: [[Int]]) -> Int {
    updates.map { update -> Int in
        let middleIndex = update.count / 2
        return update[middleIndex]
    }
    .reduce(0, { $0 + $1 })
}

// MARK: - Part One

func partOne() {
    let (correct, _) = getUpdateTypes()
    let result = middleSum(for: correct)
    print(result)
}

partOne()


// MARK: - Part Two

func partTwo() {
    let (_, incorrect) = getUpdateTypes()
    let rules = getRules()

    let fixed = incorrect.map { update -> [Int] in
        // Create a mutable variable.
        var update = update

        // I'm going to get my money's worth on my M2 Pro chip. TODO: Optimize (optional)...
        while !isUpdateValid(&update) {
            for index in 0..<update.count - 1 {
                if let followingNumbers = rules[update[index]], followingNumbers.contains(update[index + 1]) {
                    continue
                }
                update.swapAt(index, index + 1)
                continue
            }
        }

        return update
    }

    let result = middleSum(for: fixed)
    print(result)
}

partTwo()


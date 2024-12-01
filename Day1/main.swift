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

guard let input = read(file: "./Input.txt") else {
    print("Failed to open")
    exit(1)
}

let numberPattern = "[0-9]+"

let matrix = input.map { input -> [Int] in

    let regex = try! NSRegularExpression(pattern: numberPattern)

    let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))

    let results = matches.map { match in
        let range = Range(match.range, in: input)!
        return Int(input[range])!
    }

    return results
}


let transposedMatrix = matrix.first!.indices.map { index in
    matrix.map { $0[index] }
}


// MARK: - Part 1

func partOne() {
    let firstSet = transposedMatrix[0].sorted { $0 < $1 }

    let secondSet = transposedMatrix[1].sorted { $0 < $1 }

    let result = firstSet.indices.map { index in
        abs(firstSet[index] - secondSet[index])
    }

    print(result.reduce(0, { $0 + $1 }))
}

partOne()


// MARK: - Part 2

func partTwo() { 
    var dictionary = [Int:Int]()

    transposedMatrix.last!.forEach { number in
        // Check if the number exists.
        if let value = dictionary[number] {
            dictionary[number] = value + 1
            return
        }
        dictionary[number] = 1
    }

    let result = transposedMatrix.first!.map { number in 
        guard let instancesCount = dictionary[number] else {
            return 0
        }
        return number * instancesCount
    }
    
    print(result.reduce(0, { $0 + $1 }))
}

partTwo()


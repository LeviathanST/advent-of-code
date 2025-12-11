const std = @import("std");
const InputReader = @import("../../InputReader.zig");
const InputType = InputReader.InputType;

fn solve(input: *InputType) !usize {
    var sum: usize = 0;
    while (input.next()) |it| {
        const trimmed = std.mem.trimEnd(u8, it, "\n");
        var splitter = std.mem.splitScalar(u8, trimmed, '-');
        const start = try std.fmt.parseInt(usize, splitter.first(), 10);
        const end = try std.fmt.parseInt(usize, splitter.next().?, 10);

        for (start..end + 1) |i| {
            if (isRepeatedTwice(i))
                sum += i;
        }
    }
    return sum;
}

fn isRepeatedTwice(num: usize) bool {
    var num_of_digit: usize = 1;
    var divisor: usize = num / 10;

    while (divisor != 0) {
        divisor = divisor / 10;
        num_of_digit += 1;
    }
    if (num_of_digit % 2 != 0) return false;

    const ten_pow = std.math.pow(usize, 10, num_of_digit / 2);
    const first = num / ten_pow;
    const rest = num % ten_pow;

    return first == rest;
}

test "(2025/day2) solved" {
    const alloc = std.testing.allocator;
    var input_reader: InputReader = try .init(alloc);
    defer input_reader.deinit();

    var iter1 = try input_reader.read("src/2025/day2/test_input.txt", ",");
    const rs1 = try solve(&iter1);
    try std.testing.expectEqual(1227775554, rs1);

    var iter2 = try input_reader.read("src/2025/day2/input.txt", ",");
    const rs2 = try solve(&iter2);
    try std.testing.expectEqual(30599400849, rs2);
}

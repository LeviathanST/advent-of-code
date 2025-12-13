const std = @import("std");
const InputReader = @import("../../InputReader.zig");
const InputType = InputReader.InputType;

const int = u512;

// TODO: refactor
fn solve(input: *InputType) !usize {
    var v1: u8 = undefined;
    var v2: u8 = undefined;
    var sum: u32 = 0;

    while (input.next()) |it| {
        if (it.len <= 0) continue;
        const num: int = try std.fmt.parseInt(int, it, 10);
        const nod = getNumOfDigit(num);
        const first = getLargest(num, nod - 1, &v1, nod);
        if (first == 1) {
            v2 = @intCast(num % 10);
        } else {
            _ = getLargest(num, first - 1, &v2, nod);
        }
        sum += v1 * 10 + v2;
    }
    return sum;
}

fn getNumOfDigit(num: int) u8 {
    var base: u8 = 1;
    var ten_pow = std.math.pow(int, 10, base);
    var value = num / 10;

    while (value != 0) {
        value /= 10;
        base += 1;
        ten_pow = std.math.pow(int, 10, base);
    }
    return base;
}

fn getLargest(num: int, start: u16, buf: *u8, nod: u16) u8 {
    var ten_pow: int = std.math.pow(int, 10, start);
    var largest: int = 0;
    var l_idx: isize = 0;
    var idx: isize = @intCast(start);
    const condition: u2 = get_cond: {
        if (start == nod - 1) {
            break :get_cond 1;
        } else {
            break :get_cond 0;
        }
    };

    while (idx >= condition) {
        const value = num / ten_pow % 10;
        if (value > largest) {
            largest = value;
            l_idx = idx;
        }
        ten_pow /= 10;
        idx -= 1;
    }
    buf.* = @intCast(largest);
    return @intCast(l_idx);
}

test "(2025/day3) solved" {
    const alloc = std.testing.allocator;
    var input_reader: InputReader = try .init(alloc);
    defer input_reader.deinit();

    var iter1 = try input_reader.read("src/2025/day3/test_input.txt", "\n");
    const rs1 = try solve(&iter1);
    try std.testing.expectEqual(357, rs1);

    var iter2 = try input_reader.read("src/2025/day3/input.txt", "\n");
    const rs2 = try solve(&iter2);
    try std.testing.expectEqual(17405, rs2);
}

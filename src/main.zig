const std = @import("std");
const expect = @import("std").testing.expect;

test "if statement" {
    const a = true;
    var x: u16 = 0;
    if (a) {
        x += 1;
    } else {
        x += 2;
    }
    expect(x == 1);
}

test "if statement expression" {
    const a = true;
    var x: u16 = 0;
    x += if (a) 1 else 2;
    expect(x == 1);
}

test "while" {
    var i: u8 = 2;
    while (i < 100) {
        i *= 2;
    }
    expect(i == 128);
}

test "while with a continue expression" {
    var sum: u8 = 0;
    var i: u8 = 1;
    while (i <= 10) : (i += 1) {
        sum += i;
    }
    expect(sum == 55);
}

test "while with continue" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) continue;
        sum += i;
    }
    expect(sum == 4);
}

test "while with break" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) break;
        sum += i;
    }
    expect(sum == 1);
}

test "for" {
    const string = [_]u8{ 'a', 'b', 'c' };

    for (string) |character, index| {}

    for (string) |character| {}

    for (string) |_, index| {}

    for (string) |_| {} 
}

test "function" {
    const y = addFive(0);
    expect(@TypeOf(y) == u32);
    expect(y == 5);
}

fn addFive(x: u32) u32 {
    return x + 5;
}

test "function recursion" {
    const x = fibonacci(10);
    expect(x == 55);
}

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "defer" {
    var x: i16 = 5;
    {
        defer x += 2;
        expect(x == 5);
    }
    expect(x == 7);
}

test "multi defer" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
    }
    expect(x == 4.5);
}

test "Generics" {
    const len: usize = 3;
    var array = [_]i32{1, 2, 3};
    var list = List(i32) {
        .items = &array,
        .len = len,
    };
}

fn List(comptime T: type) type {
    return struct {
        items: []T,
        len: usize,
    };
}

const FileOpenError = error {
    AccessDenied,
    OutOfMemory,
    FileNotFound
};

const AllocationError = error{OutOfMemory};

test "coerce error from a subset to a superset" {
    const err: FileOpenError = AllocationError.OutOfMemory;
    expect(err == FileOpenError.OutOfMemory);
}

test "error union" {
    const maybe_error: AllocationError!u16 = 10;
    const no_error = maybe_error catch 0;

    expect(@TypeOf(no_error) == u16);
    expect(no_error == 10);
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| {
        expect(err == error.Oops);
        return;
    };
}

fn failingFn() error{Oops}!i32 {
    try failingFunction();
    return 12;
}

test "try" {
    var v = failingFn() catch |err| {
        expect(err == error.Oops);
        return;
    };
    expect(v == 12); // Unreachable in this example
}

var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1;
    try failingFunction();
}

test "errdefer" {
    failFnCounter() catch |err| {
        expect(err == error.Oops);
        expect(problems == 99);
        return;
    };
}

fn createFile() !void {
    return error.AccessDenied;
}

test "inferred error set" {
    const x: error{AccessDenied}!void = createFile();
}

const A = error{ NotDir, PathNotFound };
const B = error{ OutOfMemory, PathNotFound };
const C = A || B;

test "switch statement" {
    var x: i8 = 10;
    switch (x) {
        -1...1 => {
            x = -x;
        },
        10, 100 => {
            x = @divExact(x, 10);
        },
        else => {},
    }
    expect(x == 1);
}

test "switch expression" {
    var x: i8 = 10;
    x = switch (x) {
        -1...1 => -x,
        10, 100 => @divExact(x, 10),
        else => x,
    };
    expect(x == 1);
}

test "out of bounds" {
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    //const b = a[index];
}

test "unreachable" {
    const x: i32 = 1;
    //const y: u32 = if (x == 2) 5 else unreachable;
}

fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable,
    };
}

test "unreachable switch" {
    expect(asciiToUpper('a') == 'A');
    expect(asciiToUpper('A') == 'A');
}

fn increment(num: *u8) void {
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    expect(x == 2);
}

test "naughty pointer" {
    var x: u16 = 0;
    //var y: *u8 = @intToPtr(*u8, x);
}

test "const pointers" {
    const x: u8 = 1;
    var y = &x;
    //y.* += 1;
}

test "usize" {
    expect(@sizeOf(usize) == @sizeOf(*u8));
    expect(@sizeOf(isize) == @sizeOf(*u8));
}

fn total(values: []const u8) usize {
    var count: usize = 0;
    for (values) |v| count += v;
    return count;
}

test "slices" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];
    expect(total(slice) == 6);
}

test "slices 2" {
    const array = [_]u8{ 1, 2, 3, 4, 5 };
    const slice = array[0..3];
    expect(@TypeOf(slice) == *const [3]u8);
}

test "slices 3" {
    var array = [_]u8{ 1, 2, 3, 4, 5 };
    var slice = array[0..];
}

const Direction = enum { north, south, east, west };
const Value = enum(u2) { zero, one, two };

test "enum ordinal value" {
    expect(@enumToInt(Value.zero) == 0);
    expect(@enumToInt(Value.one) == 1);
    expect(@enumToInt(Value.two) == 2);
}

const Value2 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    million = 1000000,
    next,
};

test "set enum ordinal value" {
    expect(@enumToInt(Value2.hundred) == 100);
    expect(@enumToInt(Value2.thousand) == 1000);
    expect(@enumToInt(Value2.million) == 1000000);
    expect(@enumToInt(Value2.next) == 1000001);
}

const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

test "enum method" {
    expect(Suit.spades.isClubs() == Suit.isClubs(.spades));
}

const Mode = enum {
    var count: u32 = 0;
    on,
    off,
};

test "hmm" {
    Mode.count += 1;
    expect(Mode.count == 1);
}

const Vec3 = struct {
    x: f32, y: f32, z: f32
};

test "struct usage" {
    const my_vector = Vec3{
        .x = 0,
        .y = 100,
        .z = 50,
    };
}

pub fn main() anyerror!void {
    const a = [_]u8{ 1, 2, 3 };
    std.log.info("Hello, {}!\n", .{"World"});
}

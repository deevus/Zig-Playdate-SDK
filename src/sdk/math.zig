const std = @import("std");

pub const Vector2 = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vector2 {
        return .{ .x = x, .y = y };
    }

    pub fn clone(self: @This()) Vector2 {
        return Vector2.init(self.x, self.y);
    }

    pub fn scale(self: @This(), s: f32) Vector2 {
        var copy = self.clone();
        rawScale(&copy, s);
        return copy;
    }

    pub fn rotate(self: @This(), angle: f32) Vector2 {
        var copy = self.clone();
        rawRotate(&copy, angle);
        return copy;
    }

    pub fn add(self: @This(), other: Vector2) Vector2 {
        var copy = self.clone();
        rawAdd(&copy, other);
        return copy;
    }

    pub fn subtract(self: @This(), other: Vector2) Vector2 {
        var copy = self.clone();
        rawSubtract(&copy, other);
        return copy;
    }

    pub fn length(self: @This()) f32 {
        return std.math.sqrt(self.x * self.x + self.y * self.y);
    }

    pub fn normalize(self: @This()) Vector2 {
        var copy = self.clone();
        rawNormalize(&copy);
        return copy;
    }

    pub fn distance(self: @This(), other: Vector2) f32 {
        return std.math.sqrt((self.x - other.x) * (self.x - other.x) + (self.y - other.y) * (self.y - other.y));
    }

    pub fn toVector2i(self: @This()) Vector2i {
        const x = @round(self.x);
        const y = @round(self.y);

        const xi = std.math.lossyCast(i32, x);
        const yi = std.math.lossyCast(i32, y);

        return Vector2i.init(xi, yi);
    }

    pub fn multiply(self: @This(), other: Vector2) Vector2 {
        return .{
            .x = self.x * other.x,
            .y = self.y * other.y,
        };
    }

    pub fn dot(self: @This(), other: Vector2) f32 {
        return self.x * other.x + self.y * other.y;
    }

    pub fn backward(self: @This()) Vector2 {
        return .{ .x = -self.x, .y = -self.y };
    }

    pub fn left(self: @This()) Vector2 {
        return .{ .x = -self.y, .y = self.x };
    }

    pub fn right(self: @This()) Vector2 {
        return .{ .x = self.y, .y = -self.x };
    }

    pub fn toLocal(self: @This(), reference_pos: Vector2, rotationDegrees: f32) Vector2 {
        const translation = self.subtract(reference_pos);
        const angle = std.math.degreesToRadians(rotationDegrees);

        const cosTheta = @cos(-angle);
        const sinTheta = @sin(-angle);

        const localX = translation.x * cosTheta - translation.y * sinTheta;
        const localY = translation.x * sinTheta + translation.y * cosTheta;

        return Vector2.init(localX, localY);
    }

    pub const ZERO = Vector2.init(0.0, 0.0);
    pub const ONE = Vector2.init(1.0, 1.0);
    pub const UP = Vector2.init(0.0, -1.0);
    pub const DOWN = Vector2.init(0.0, 1.0);
    pub const LEFT = Vector2.init(-1.0, 0.0);
    pub const RIGHT = Vector2.init(1.0, 0.0);
};

pub const Vector2i = struct {
    x: i32,
    y: i32,

    pub fn init(x: i32, y: i32) Vector2i {
        return .{ .x = x, .y = y };
    }

    pub fn toVector2(self: @This()) Vector2 {
        return Vector2.init(@floatFromInt(self.x), @floatFromInt(self.y));
    }
};

fn rawScale(v: *Vector2, s: f32) void {
    v.x = v.x * s;
    v.y = v.y * s;
}

pub const scale = rawScale;

fn rawRotate(v: *Vector2, angle: f32) void {
    const c = std.math.cos(angle);
    const s = std.math.sin(angle);

    v.x = v.x * c - v.y * s;
    v.y = v.x * s + v.y * c;
}

pub const rotate = rawRotate;

fn rawAdd(v: *Vector2, other: Vector2) void {
    v.x = v.x + other.x;
    v.y = v.y + other.y;
}

pub const add = rawAdd;

fn rawSubtract(v: *Vector2, other: Vector2) void {
    v.x = v.x - other.x;
    v.y = v.y - other.y;
}

pub const subtract = rawSubtract;

fn rawNormalize(v: *Vector2) void {
    const len = v.length();

    v.x = v.x / len;
    v.y = v.y / len;
}

pub const normalize = rawNormalize;

pub fn angleBetweenPoints(p1: Vector2, p2: Vector2) f32 {
    const translation = p2.subtract(p1);
    return std.math.radiansToDegrees(std.math.atan2(translation.y, translation.x));
}

pub fn angleBetweenVectors(v1: Vector2, v2: Vector2) f32 {
    return std.math.radiansToDegrees(std.math.acos(v1.dot(v2) / (v1.length() * v2.length())));
}

test "angleBetweenPoints tests" {
    const epsilon = 0.0001;

    // Test case 1: Same points
    {
        const p1 = Vector2.init(0.0, 0.0);
        const p2 = Vector2.init(0.0, 0.0);
        const angle = angleBetweenPoints(p1, p2);
        try std.testing.expectApproxEqAbs(0.0, angle, epsilon);
    }

    // Test case 2: Horizontal line (positive x-axis)
    {
        const p1 = Vector2.init(0.0, 0.0);
        const p2 = Vector2.init(1.0, 0.0);
        const angle = angleBetweenPoints(p1, p2);
        try std.testing.expectApproxEqAbs(0.0, angle, epsilon);
    }

    // Test case 3: Vertical line (positive y-axis)
    {
        const p1 = Vector2.init(0.0, 0.0);
        const p2 = Vector2.init(0.0, 1.0);
        const angle = angleBetweenPoints(p1, p2);
        try std.testing.expectApproxEqAbs(90.0, angle, epsilon);
    }

    // Test case 4: Diagonal line at 45 degrees
    {
        const p1 = Vector2.init(0.0, 0.0);
        const p2 = Vector2.init(1.0, 1.0);
        const angle = angleBetweenPoints(p1, p2);
        try std.testing.expectApproxEqAbs(45.0, angle, epsilon);
    }

    // Test case 5: Negative x-axis
    {
        const p1 = Vector2.init(0.0, 0.0);
        const p2 = Vector2.init(-1.0, 0.0);
        const angle = angleBetweenPoints(p1, p2);
        try std.testing.expectApproxEqAbs(180.0, angle, epsilon);
    }

    // Test case 6: Negative y-axis
    {
        const p1 = Vector2.init(0.0, 0.0);
        const p2 = Vector2.init(0.0, -1.0);
        const angle = angleBetweenPoints(p1, p2);
        try std.testing.expectApproxEqAbs(-90.0, angle, epsilon);
    }

    // Test case 7: General case
    {
        const p1 = Vector2.init(0.0, 0.0);
        const p2 = Vector2.init(3.0, 4.0);
        const angle = angleBetweenPoints(p1, p2);
        const expected_angle = std.math.atan2(@as(f32, 4.0), @as(f32, 3.0));
        try std.testing.expectApproxEqAbs(std.math.radiansToDegrees(expected_angle), angle, epsilon);
    }
}

test "angleBetweenVectors tests" {
    const epsilon = 0.0001;

    // Test case 1: Parallel vectors (same direction)
    {
        const v1 = Vector2.init(1.0, 0.0);
        const v2 = Vector2.init(2.0, 0.0);
        const angle = angleBetweenVectors(v1, v2);
        try std.testing.expectApproxEqAbs(0.0, angle, epsilon);
    }

    // Test case 2: Opposite vectors
    {
        const v1 = Vector2.init(1.0, 0.0);
        const v2 = Vector2.init(-1.0, 0.0);
        const angle = angleBetweenVectors(v1, v2);
        try std.testing.expectApproxEqAbs(180.0, angle, epsilon);
    }

    // Test case 3: Perpendicular vectors
    {
        const v1 = Vector2.init(1.0, 0.0);
        const v2 = Vector2.init(0.0, 1.0);
        const angle = angleBetweenVectors(v1, v2);
        try std.testing.expectApproxEqAbs(90.0, angle, epsilon);
    }

    // Test case 4: Diagonal vectors at 45 degrees
    {
        const v1 = Vector2.init(1.0, 1.0);
        const v2 = Vector2.init(1.0, 0.0);
        const angle = angleBetweenVectors(v1, v2);
        try std.testing.expectApproxEqAbs(45.0, angle, epsilon);
    }

    // Test case 5: Arbitrary vectors
    {
        const v1 = Vector2.init(1.0, 2.0);
        const v2 = Vector2.init(2.0, 1.0);
        const angle = angleBetweenVectors(v1, v2);
        const expected_angle = std.math.radiansToDegrees(std.math.acos(v1.dot(v2) / (v1.length() * v2.length())));
        try std.testing.expectApproxEqAbs(expected_angle, angle, epsilon);
    }
}

test "normalize" {
    var v = Vector2.init(1.0, 2.0);
    const v2 = v.normalize();

    try std.testing.expectApproxEqAbs(1.0, v2.length(), 0.0001);
}

test "add" {
    var v = Vector2.init(1.0, 2.0);
    const v2 = Vector2.init(2.0, 3.0);
    const v3 = v.add(v2);

    try std.testing.expectEqual(v3.x, 3.0);
    try std.testing.expectEqual(v3.y, 5.0);
}

test "subtract" {
    var v = Vector2.init(1.0, 2.0);
    const v2 = Vector2.init(2.0, 3.0);
    const v3 = v.subtract(v2);

    try std.testing.expectEqual(v3.x, -1.0);
    try std.testing.expectEqual(v3.y, -1.0);
}

test "vector2 clone" {
    var v = Vector2.init(1.0, 2.0);
    const v2 = v.clone();

    try std.testing.expectEqual(v.x, v2.x);
    try std.testing.expectEqual(v.y, v2.y);
    try std.testing.expect(&v != &v2);
}

test "scale" {
    var v = Vector2.init(1.0, 2.0);
    scale(&v, 2.0);

    try std.testing.expectEqual(v.x, 2.0);
    try std.testing.expectEqual(v.y, 4.0);

    scale(&v, 0.5);

    try std.testing.expectEqual(v.x, 1.0);
    try std.testing.expectEqual(v.y, 2.0);

    const v2 = v.scale(2.0);

    try std.testing.expectEqual(v2.x, 2.0);
    try std.testing.expectEqual(v2.y, 4.0);

    const v3 = v2.scale(0.5);

    try std.testing.expectEqual(v3.x, 1.0);
    try std.testing.expectEqual(v3.y, 2.0);
}

test "vector2 toLocal" {
    const epsilon = 0.0001; // Tolerance for floating-point comparisons

    // Test case 1: No translation, no rotation
    {
        const reference_pos = Vector2.init(0.0, 0.0);
        const rotation = 0.0;
        const pos = Vector2.init(1.0, 0.0);

        const local = pos.toLocal(reference_pos, rotation);

        try std.testing.expectApproxEqAbs(1.0, local.x, epsilon);
        try std.testing.expectApproxEqAbs(0.0, local.y, epsilon);
    }

    // Test case 2: Translation only
    {
        const reference_pos = Vector2.init(1.0, 1.0);
        const rotation = 0.0;
        const pos = Vector2.init(2.0, 2.0);

        const local = pos.toLocal(reference_pos, rotation);

        try std.testing.expectApproxEqAbs(1.0, local.x, epsilon);
        try std.testing.expectApproxEqAbs(1.0, local.y, epsilon);
    }

    // Test case 3: Rotation only (90 degrees)
    {
        const reference_pos = Vector2.init(0.0, 0.0);
        const rotation = 90.0;
        const pos = Vector2.init(1.0, 0.0);

        const local = pos.toLocal(reference_pos, rotation);

        try std.testing.expectApproxEqAbs(0.0, local.x, epsilon);
        try std.testing.expectApproxEqAbs(-1.0, local.y, epsilon);
    }

    // Test case 4: Rotation only (180 degrees)
    {
        const reference_pos = Vector2.init(0.0, 0.0);
        const rotation = 180.0;
        const pos = Vector2.init(1.0, 0.0);

        const local = pos.toLocal(reference_pos, rotation);

        try std.testing.expectApproxEqAbs(-1.0, local.x, epsilon);
        try std.testing.expectApproxEqAbs(0.0, local.y, epsilon);
    }

    // Test case 5: Rotation and translation
    {
        const reference_pos = Vector2.init(1.0, 1.0);
        const rotation = 90.0;
        const pos = Vector2.init(2.0, 1.0);

        const local = pos.toLocal(reference_pos, rotation);

        try std.testing.expectApproxEqAbs(0.0, local.x, epsilon);
        try std.testing.expectApproxEqAbs(-1.0, local.y, epsilon);
    }

    // Test case 6: Rotation -90 degrees
    {
        const reference_pos = Vector2.init(0.0, 0.0);
        const rotation = -90.0;
        const pos = Vector2.init(1.0, 0.0);

        const local = pos.toLocal(reference_pos, rotation);

        try std.testing.expectApproxEqAbs(0.0, local.x, epsilon);
        try std.testing.expectApproxEqAbs(1.0, local.y, epsilon);
    }

    // Test case 7: Zero vector with rotation
    {
        const reference_pos = Vector2.init(0.0, 0.0);
        const rotation = 45.0;
        const pos = Vector2.init(0.0, 0.0);

        const local = pos.toLocal(reference_pos, rotation);

        try std.testing.expectApproxEqAbs(0.0, local.x, epsilon);
        try std.testing.expectApproxEqAbs(0.0, local.y, epsilon);
    }

    // Test case 8: Diagonal movement and rotation
    {
        const reference_pos = Vector2.init(1.0, 1.0);
        const rotation = 45.0;
        const pos = Vector2.init(2.0, 2.0);

        const local = pos.toLocal(reference_pos, rotation);

        const expected = std.math.sqrt(2.0);
        try std.testing.expectApproxEqAbs(expected, local.x, epsilon);
        try std.testing.expectApproxEqAbs(0.0, local.y, epsilon);
    }
}

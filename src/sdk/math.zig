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
        return .{ .x = self.x * s, .y = self.y * s };
    }

    pub fn rotate(self: @This(), angle: f32) Vector2 {
        const c = std.math.cos(angle);
        const s = std.math.sin(angle);
        return .{
            .x = self.x * c - self.y * s,
            .y = self.x * s + self.y * c,
        };
    }

    pub fn add(self: @This(), other: Vector2) Vector2 {
        return .{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn subtract(self: @This(), other: Vector2) Vector2 {
        return .{ .x = self.x - other.x, .y = self.y - other.y };
    }

    pub fn length(self: @This()) f32 {
        return std.math.sqrt(self.x * self.x + self.y * self.y);
    }

    pub fn normalize(self: @This()) Vector2 {
        const len = self.length();
        return .{ .x = self.x / len, .y = self.y / len };
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

    pub fn zero() Vector2 {
        return Vector2.init(0.0, 0.0);
    }

    pub fn one() Vector2 {
        return Vector2.init(1.0, 1.0);
    }

    pub fn dot(self: @This(), other: Vector2) Vector2 {
        return .{
            .x = self.x * other.x,
            .y = self.y * other.y,
        };
    }
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

pub fn scale(v: *Vector2, s: f32) void {
    v.x = v.x * s;
    v.y = v.y * s;
}

pub fn rotate(v: *Vector2, angle: f32) void {
    const c = std.math.cos(angle);
    const s = std.math.sin(angle);

    v.x = v.x * c - v.y * s;
    v.y = v.x * s + v.y * c;
}

pub fn add(v: *Vector2, other: Vector2) void {
    v.x = v.x + other.x;
    v.y = v.y + other.y;
}

pub fn subtract(v: *Vector2, other: Vector2) void {
    v.x = v.x - other.x;
    v.y = v.y - other.y;
}

pub fn normalize(v: *Vector2) void {
    const len = std.math.sqrt(v.x * v.x + v.y * v.y);

    v.x = v.x / len;
    v.y = v.y / len;
}

const std = @import("std");

pub const Vector2 = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vector2 {
        return .{ .x = x, .y = y };
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

    pub fn normalize(self: @This()) Vector2 {
        const len = std.math.sqrt(self.x * self.x + self.y * self.y);
        return .{ .x = self.x / len, .y = self.y / len };
    }

    pub fn distance(self: @This(), other: Vector2) f32 {
        return std.math.sqrt((self.x - other.x) * (self.x - other.x) + (self.y - other.y) * (self.y - other.y));
    }

    pub fn toVector2i(self: @This()) Vector2i {
        return Vector2i.init(@intFromFloat(std.math.round(self.x)), @intFromFloat(std.math.round(self.y)));
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

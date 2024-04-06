const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");

pub const Vector2 = struct {
    x: i32,
    y: i32,
};

pub const Bitmap = struct {
    api: *const pdapi.PlaydateGraphics,
    bitmap: *pdapi.LCDBitmap,
    flip: pdapi.LCDBitmapFlip = .BitmapUnflipped,

    pub fn init(graphics_api: *const pdapi.PlaydateGraphics, file_path: []const u8) Bitmap {
        return .{
            .api = graphics_api,
            .bitmap = graphics_api.loadBitmap(file_path.ptr, null).?,
        };
    }

    pub fn deinit(self: @This()) void {
        self.api.freeBitmap(self.bitmap);
    }
};

pub const PlaydateGraphics = struct {
    api: *const pdapi.PlaydateGraphics,
    text_encoding: pdapi.PDStringEncoding = .UTF8Encoding,

    pub fn init(graphics_api: *const pdapi.PlaydateGraphics) PlaydateGraphics {
        return .{
            .api = graphics_api,
        };
    }

    fn clearInternal(self: @This(), comptime color_or_pattern: anytype) void {
        switch (@TypeOf(color_or_pattern)) {
            pdapi.LCDSolidColor => self.api.clear(@intCast(@intFromEnum(color_or_pattern))),
            c_int => self.api.clear(@intCast(color_or_pattern)),
            else => {
                @compileError("Invalid type passed to clear");
            },
        }
    }

    pub fn clear(self: @This(), comptime color: pdapi.LCDSolidColor) void {
        self.clearInternal(color);
    }

    pub fn clearPattern(self: @This(), comptime pattern: pdapi.LCDPattern) void {
        self.clearInternal(@intFromPtr(&pattern));
    }

    pub fn drawText(self: @This(), message: []const u8, pos: Vector2) void {
        _ = self.api.drawText(message.ptr, message.len, self.text_encoding, pos.x, pos.y);
    }

    pub fn loadBitmap(self: @This(), file_path: []const u8) Bitmap {
        return Bitmap.init(self.api, file_path);
    }

    pub fn drawBitmap(self: @This(), bitmap: Bitmap, pos: Vector2) void {
        self.api.drawBitmap(bitmap.bitmap, pos.x, pos.y, bitmap.flip);
    }
};

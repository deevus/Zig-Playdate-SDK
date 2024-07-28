const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");
const math = @import("math.zig");

const Vector2i = math.Vector2i;
const Vector2 = math.Vector2;

const Transformer = struct {
    org: Vector2,
    scale: f32,
    rot: f32,

    fn apply(tr: @This(), p: Vector2) Vector2 {
        return p.rotate(tr.rot).scale(tr.scale).add(tr.org);
    }
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

const ClearScreenOptions = union(enum) {
    color: pdapi.LCDSolidColor,
    pattern: *pdapi.LCDPattern,
};

const DrawCircleParameters = struct {
    position: Vector2i,
    radius: ?i32 = 1,
    color: pdapi.LCDSolidColor = .ColorBlack,
};

const DrawLineParameters = struct {
    start: Vector2i,
    end: Vector2i,
    color: pdapi.LCDSolidColor = .ColorBlack,
    thickness: i32 = 1,
};

const DrawLinesParameters = struct {
    origin: Vector2,
    scale: f32,
    rotation: f32,
    points: []const Vector2,
    connect: bool = true,
    thickness: i32 = 1,
    color: pdapi.LCDSolidColor = .ColorBlack,
};

const DrawBitmapParameters = struct {
    bitmap: Bitmap,
    position: Vector2i,
    rotation: f32 = 0.0,
    center: Vector2 = .{ .x = 0.5, .y = 0.5 },
    scale: Vector2 = Vector2.one(),
};

pub const PlaydateGraphics = struct {
    api: *const pdapi.PlaydateGraphics,
    text_encoding: pdapi.PDStringEncoding = .UTF8Encoding,

    pub fn init(graphics_api: *const pdapi.PlaydateGraphics) PlaydateGraphics {
        return .{
            .api = graphics_api,
        };
    }

    pub fn clear(self: @This(), comptime clear_option: ClearScreenOptions) void {
        switch (clear_option) {
            .color => |color| self.api.clear(@intCast(@intFromEnum(color))),
            .pattern => |pattern| self.api.clear(@intFromPtr(pattern)),
        }
    }

    pub fn drawText(self: @This(), message: []const u8, pos: Vector2i) void {
        _ = self.api.drawText(message.ptr, message.len, self.text_encoding, pos.x, pos.y);
    }

    pub fn loadBitmap(self: @This(), file_path: []const u8) Bitmap {
        return Bitmap.init(self.api, file_path);
    }

    pub fn drawBitmap(self: @This(), bitmap: Bitmap, pos: Vector2i) void {
        self.api.drawBitmap(bitmap.bitmap, pos.x, pos.y, bitmap.flip);
    }

    pub fn drawBitmapEx(self: @This(), params: DrawBitmapParameters) void {
        self.api.drawRotatedBitmap(
            params.bitmap.bitmap,
            params.position.x,
            params.position.y,
            params.rotation,
            params.center.x,
            params.center.y,
            params.scale.x,
            params.scale.y,
        );
    }

    pub fn drawCircle(self: @This(), params: DrawCircleParameters) void {
        const circumference = if (params.radius) |r| r * 2 else 2;

        self.api.fillEllipse(params.position.x, params.position.y, circumference, circumference, 0.0, 0.0, @intCast(@intFromEnum(params.color)));
    }

    pub fn drawLine(self: @This(), params: DrawLineParameters) void {
        self.api.drawLine(params.start.x, params.start.y, params.end.x, params.end.y, params.thickness, @intCast(@intFromEnum(params.color)));
    }

    pub fn drawLines(self: @This(), params: DrawLinesParameters) void {
        const t = Transformer{
            .org = params.origin,
            .scale = params.scale,
            .rot = params.rotation,
        };

        const points = params.points;
        const bound = if (params.connect) points.len else (points.len - 1);
        for (0..bound) |i| {
            const v0 = t.apply(points[i]).toVector2i();
            const v1 = t.apply(points[(i + 1) % points.len]).toVector2i();

            self.drawLine(.{
                .start = v0,
                .end = v1,
                .thickness = params.thickness,
                .color = params.color,
            });
        }
    }
};

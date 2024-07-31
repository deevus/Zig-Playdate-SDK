const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");
const math = @import("math.zig");
const Bitmap = @import("graphics.zig").Bitmap;

pub const Sprite = struct {
    api: *const pdapi.PlaydateSprite,
    sprite: *pdapi.LCDSprite,

    pub fn init(sprite_api: *const pdapi.PlaydateSprite) Sprite {
        return .{
            .api = sprite_api,
            .sprite = sprite_api.newSprite().?,
        };
    }

    pub fn copy(self: @This()) Sprite {
        return .{
            .api = self.api,
            .sprite = self.api.copy(self.sprite).?,
        };
    }

    pub fn setBounds(self: @This(), bounds: pdapi.PDRect) void {
        self.api.setBounds(self.sprite, bounds);
    }

    pub fn getBounds(self: @This()) pdapi.PDRect {
        return self.api.getBounds(self.sprite);
    }

    pub fn moveTo(self: @This(), position: math.Vector2) void {
        self.api.moveTo(self.sprite, position.x, position.y);
    }

    pub fn moveBy(self: @This(), offset: math.Vector2) void {
        self.api.moveBy(self.sprite, offset.x, offset.y);
    }

    pub fn getPosition(self: @This()) math.Vector2 {
        var position = math.Vector2.zero();

        self.api.getPosition(self.sprite, &position.x, &position.y);

        return position;
    }

    pub fn setCenter(self: @This(), center: math.Vector2) void {
        self.api.setCenter(self.sprite, center.x, center.y);
    }

    pub fn getCenter(self: @This()) math.Vector2 {
        var center = math.Vector2.zero();

        self.api.getCenter(self.sprite, &center.x, &center.y);

        return center;
    }

    pub fn setImage(self: @This(), bitmap: Bitmap) void {
        self.api.setImage(self.sprite, bitmap.bitmap, bitmap.flip);
    }

    pub fn setSize(self: @This(), size: math.Vector2) void {
        self.api.setSize(self.sprite, size.x, size.y);
    }

    pub fn setZIndex(self: @This(), z_index: i16) void {
        self.api.setZIndex(self.sprite, z_index);
    }

    pub fn getZIndex(self: @This()) i16 {
        return self.api.getZIndex(self.sprite);
    }

    pub fn setTag(self: @This(), tag: u8) void {
        self.api.setTag(self.sprite, tag);
    }

    pub fn getTag(self: @This()) u8 {
        return self.api.getTag(self.sprite);
    }

    pub fn setDrawMode(self: @This(), draw_mode: pdapi.LCDBitmapDrawMode) void {
        self.api.setDrawMode(self.sprite, draw_mode);
    }

    pub fn setImageFlip(self: @This(), flip: pdapi.LCDBitmapFlip) void {
        self.api.setImageFlip(self.sprite, flip);
    }

    pub fn getImageFlip(self: @This()) pdapi.LCDBitmapFlip {
        return self.api.getImageFlip(self.sprite);
    }

    pub fn setStencil(self: @This(), stencil: Bitmap) void {
        self.api.setStencil(self.sprite, stencil.bitmap);
    }

    pub fn setStencilImage(self: @This(), stencil: Bitmap, tile: i32) void {
        self.api.setStencilImage(self.sprite, stencil.bitmap, @intCast(tile));
    }

    pub fn setStencilPattern(self: @This(), pattern: *pdapi.LCDPattern) void {
        self.api.setStencilPattern(self.sprite, pattern);
    }

    pub fn clearStencil(self: @This()) void {
        self.api.clearStencil(self.sprite);
    }

    pub fn setClipRect(self: @This(), clip_rect: pdapi.LCDRect) void {
        self.api.setClipRect(self.sprite, clip_rect);
    }

    pub fn clearClipRect(self: @This()) void {
        self.api.clearClipRect(self.sprite);
    }

    pub fn setClipRectsInRange(self: @This(), start_z: i32, end_z: i32) void {
        self.api.setClipRectsInRange(self.sprite, @intCast(start_z), @intCast(end_z));
    }

    pub fn setUpdatesEnabled(self: @This(), enabled: bool) void {
        self.api.setUpdatesEnabled(self.sprite, @intCast(@intFromBool(enabled)));
    }

    pub fn updatesEnabled(self: @This()) bool {
        return self.api.updatesEnabled(self.sprite) > 0;
    }

    pub fn setVisible(self: @This(), visible: bool) void {
        self.api.setVisible(self.sprite, @intCast(@intFromBool(visible)));
    }

    pub fn isVisible(self: @This()) bool {
        return self.api.isVisible(self.sprite) > 0;
    }

    pub fn setOpaque(self: @This(), to: bool) void {
        self.api.setOpaque(self.sprite, @intCast(@intFromBool(to)));
    }

    pub fn markDirty(self: @This()) void {
        self.api.markDirty(self.sprite);
    }

    pub fn setIgnoresDrawOffset(self: @This(), ignores_draw_offset: bool) void {
        self.api.setIgnoresDrawOffset(self.sprite, @intCast(@intFromBool(ignores_draw_offset)));
    }

    pub fn setUpdateFunction(self: @This(), update_function: pdapi.LCDSpriteUpdateFunction) void {
        self.api.setUpdateFunction(self.sprite, update_function);
    }

    pub fn setDrawFunction(self: @This(), draw_function: pdapi.LCDSpriteDrawFunction) void {
        self.api.setDrawFunction(self.sprite, draw_function);
    }

    pub fn setUserdata(self: @This(), userdata: ?*anyopaque) void {
        self.api.setUserdata(self.sprite, userdata);
    }

    pub fn getUserdata(self: @This()) ?*anyopaque {
        return self.api.getUserdata(self.sprite);
    }

    pub fn addToDisplayList(self: @This()) void {
        self.api.addSprite(self.sprite);
    }

    pub fn removeFromDisplayList(self: @This()) void {
        self.api.removeSprite(self.sprite);
    }

    pub fn setCollisionsEnabled(self: @This(), enabled: bool) void {
        self.api.setCollisionsEnabled(self.sprite, @intCast(@intFromBool(enabled)));
    }

    pub fn collisionsEnabled(self: @This()) bool {
        return self.api.collisionsEnabled(self.sprite) > 0;
    }

    pub fn setCollideRect(self: @This(), collide_rect: pdapi.PDRect) void {
        self.api.setCollideRect(self.sprite, collide_rect);
    }

    pub fn getCollideRect(self: @This()) pdapi.PDRect {
        return self.api.getCollideRect(self.sprite);
    }

    pub fn clearCollideRect(self: @This()) void {
        self.api.clearCollideRect(self.sprite);
    }

    pub fn setCollisionResponseFunction(self: @This(), response_function: pdapi.LCDSpriteCollisionFilterProc) void {
        self.api.setCollisionResponseFunction(self.sprite, response_function);
    }

    pub fn checkCollisions(self: @This(), goal: math.Vector2) pdapi.SpriteCollisionInfo {
        return self.api.checkCollisions(self.sprite, goal.x, goal.y, null, null, null);
    }

    pub fn moveWithCollisions(self: @This(), goal: math.Vector2) pdapi.SpriteCollisionInfo {
        return self.api.moveWithCollisions(self.sprite, goal.x, goal.y, null, null, null);
    }

    pub fn deinit(self: @This()) void {
        self.api.freeSprite(self.sprite);
    }
};

pub const PlaydateSprite = struct {
    api: *const pdapi.PlaydateSprite,

    pub fn init(sprite_api: *const pdapi.PlaydateSprite) PlaydateSprite {
        return .{ .api = sprite_api };
    }

    pub fn newSprite(self: @This()) Sprite {
        return Sprite.init(self.api);
    }

    pub fn querySpritesAtPoint(self: @This(), point: math.Vector2) []pdapi.LCDSprite {
        var len: i32 = 0;

        var results = self.api.querySpritesAtPoint(point.x, point.y, &len);

        return results[0..len];
    }
};

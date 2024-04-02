const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");

const Allocator = std.mem.Allocator;
const pd = @import("playdate.zig");

pub const PlaydateAllocator = struct {
    api: *const pdapi.PlaydateAPI,

    pub fn init(api: *const pdapi.PlaydateAPI) PlaydateAllocator {
        return .{ .api = api };
    }

    pub fn allocator(self: *PlaydateAllocator) std.mem.Allocator {
        return .{
            .ptr = self,
            .vtable = &.{
                .alloc = alloc,
                .resize = resize,
                .free = free,
            },
        };
    }

    fn alloc(
        ctx: *anyopaque,
        n: usize,
        _: u8,
        _: usize,
    ) ?[*]u8 {
        const self: *PlaydateAllocator = @alignCast(@ptrCast(ctx));

        // No need for manual alignment calculation as playdate.system.realloc handles it.
        const ptr = self.api.system.realloc(null, n); // Allocating new memory

        if (ptr == null) return null;

        return @alignCast(@ptrCast(ptr));
    }

    fn resize(
        ctx: *anyopaque,
        buf: []u8,
        _: u8,
        new_size: usize,
        _: usize,
    ) bool {
        const self: *PlaydateAllocator = @alignCast(@ptrCast(ctx));

        _ = self.api.system.realloc(buf.ptr, new_size);
        // It's assumed that the consumer of this API will handle the returned pointer correctly.
        return true; // Return true on successful resize.
    }

    fn free(
        ctx: *anyopaque,
        buf: []u8,
        _: u8,
        _: usize,
    ) void {
        const self: *PlaydateAllocator = @alignCast(@ptrCast(ctx));

        _ = self.api.system.realloc(buf.ptr, 0); // Intentionally ignore the return value as we're freeing memory.
    }
};

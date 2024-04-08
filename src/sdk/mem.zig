const std = @import("std");
const pdapi = @import("playdate_api_definitions.zig");

const Allocator = std.mem.Allocator;
const pd = @import("playdate.zig");

pub const PlaydateAllocator = struct {
    api: *const pdapi.PlaydateSys,

    pub fn init(api: *const pdapi.PlaydateSys) PlaydateAllocator {
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
        ptr_align: u8,
        return_address: usize,
    ) ?[*]u8 {
        _ = ptr_align;
        _ = return_address;

        const self: *PlaydateAllocator = @alignCast(@ptrCast(ctx));

        // No need for manual alignment calculation as playdate.system.realloc handles it.
        const ptr = self.api.realloc(null, n); // Allocating new memory

        if (ptr == null) return null;

        return @ptrCast(ptr);
    }

    fn resize(
        _: *anyopaque,
        buf: []u8,
        _: u8,
        new_size: usize,
        _: usize,
    ) bool {
        return new_size <= buf.len;
    }

    fn free(
        ctx: *anyopaque,
        buf: []u8,
        _: u8,
        _: usize,
    ) void {
        const self: *PlaydateAllocator = @alignCast(@ptrCast(ctx));

        _ = self.api.realloc(buf.ptr, 0);
    }
};

pub const Memory = struct {
    api: *const pdapi.PlaydateSys,
    pd_allocator: PlaydateAllocator,

    pub fn init(api: *const pdapi.PlaydateSys) Memory {
        return .{
            .api = api,
            .pd_allocator = PlaydateAllocator.init(api),
        };
    }
};

patch -b /usr/lib/partman/mount.d/70btrfs -- << '_END'
24c24
< 		options="${options:+$options,}subvol=@"
---
> 		options="${options:+$options,}subvol=@,ssd,noatime,space_cache,commit=120,compress=zstd"
31c31
< 		options="${options:+$options,}subvol=@home"
---
> 		options="${options:+$options,}subvol=@home,ssd,noatime,space_cache,commit=120,compress=zstd"
_END

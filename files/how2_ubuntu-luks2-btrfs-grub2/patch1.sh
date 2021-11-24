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

patch -b /usr/lib/partman/fstab.d/btrfs -- << '_END'
30,32c30,32
< 				pass=1
< 				home_options="${options:+$options,}subvol=@home"
< 				options="${options:+$options,}subvol=@"
---
> 				pass=0
> 				home_options="${options:+$options,}subvol=@home,ssd,noatime,space_cache,commit=120,compress=zstd"
> 				options="${options:+$options,}subvol=@,ssd,noatime,space_cache,commit=120,compress=zstd"
36,37c36,37
< 				pass=2
< 				options="${options:+$options,}subvol=@home"
---
> 				pass=0
> 				options="${options:+$options,}subvol=@home,ssd,noatime,space_cache,commit=120,compress=zstd"
40c40
< 				pass=2
---
> 				pass=0
55c55
< 	echo "$home_path" "$home_mp" btrfs "$home_options" 0 2
---
> 	echo "$home_path" "$home_mp" btrfs "$home_options" 0 0
_END

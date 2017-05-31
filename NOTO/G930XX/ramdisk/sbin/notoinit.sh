#!/system/bin/sh
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Busybox
if [ -e /su/xbin/busybox ]; then
	BB=/su/xbin/busybox;
else if [ -e /sbin/busybox ]; then
	BB=/sbin/busybox;
else
	BB=/system/xbin/busybox;
fi;
fi;

MTWEAKS_PATH=/data/.mtweaks

# Mount
$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,rw /system;
$BB mount -o remount,rw /data;
$BB mount -o remount,rw /;

# Set I/O Scheduler tweaks mmcblk0
	chmod 644 /sys/block/mmcblk0/queue/scheduler
	echo maple > /sys/block/mmcblk0/queue/scheduler
	echo 2048 > /sys/block/mmcblk0/queue/read_ahead_kb
  chmod 644 /sys/block/mmcblk0/queue/iosched/writes_starved
	echo 4 > /sys/block/mmcblk0/queue/iosched/writes_starved
  chmod 644 /sys/block/mmcblk0/queue/iosched/fifo_batch
	echo 16 > /sys/block/mmcblk0/queue/iosched/fifo_batch
	echo 350 > /sys/block/mmcblk0/queue/iosched/sync_read_expire
	echo 550 > /sys/block/mmcblk0/queue/iosched/sync_write_expire
	echo 250 > /sys/block/mmcblk0/queue/iosched/async_read_expire
	echo 450 > /sys/block/mmcblk0/queue/iosched/async_write_expire
	echo 10 > /sys/block/mmcblk0/queue/iosched/sleep_latency_multiple

# Set I/O Scheduler tweaks sda
  chmod 644 /sys/block/sda/queue/scheduler
	echo maple > /sys/block/sda/queue/scheduler
	echo 512 > /sys/block/sda/queue/read_ahead_kb
	echo 4 > /sys/block/sda/queue/iosched/writes_starved
	echo 16 > /sys/block/sda/queue/iosched/fifo_batch
	echo 350 > /sys/block/sda/queue/iosched/sync_read_expire
	echo 550 > /sys/block/sda/queue/iosched/sync_write_expire
	echo 250 > /sys/block/sda/queue/iosched/async_read_expire
	echo 450 > /sys/block/sda/queue/iosched/async_write_expire
	echo 10 > /sys/block/sda/queue/iosched/sleep_latency_multiple

# Set I/O Scheduler tweaks sdb
	chmod 644 /sys/block/sdb/queue/scheduler
  echo deadline > /sys/block/sdb/queue/scheduler

# Set I/O Scheduler tweaks sdc
	chmod 644 /sys/block/sdc/queue/scheduler
	echo deadline > /sys/block/sdc/queue/scheduler

# Set I/O Scheduler tweaks sdd
	chmod 644 /sys/block/sdd/queue/scheduler
	echo deadline > /sys/block/sdd/queue/scheduler

# Enable FSYNC
	echo "N" > /sys/module/sync/parameters/fsync_enabled

# Set VM Preferences
  echo "0" > /proc/sys/vm/laptop_mode
	echo "1" > /proc/sys/vm/overcommit_memory

# Don't treat storage as rotational
	echo 0 > /sys/block/mmcblk0/queue/rotational
	echo 0 > /sys/block/loop0/queue/rotational
	echo 0 > /sys/block/loop1/queue/rotational
	echo 0 > /sys/block/loop2/queue/rotational
	echo 0 > /sys/block/loop3/queue/rotational
	echo 0 > /sys/block/loop4/queue/rotational
	echo 0 > /sys/block/loop5/queue/rotational
	echo 0 > /sys/block/loop6/queue/rotational
	echo 0 > /sys/block/loop7/queue/rotational
	echo 0 > /sys/block/ram0/queue/rotational
	echo 0 > /sys/block/ram1/queue/rotational
	echo 0 > /sys/block/ram2/queue/rotational
	echo 0 > /sys/block/ram3/queue/rotational
	echo 0 > /sys/block/ram4/queue/rotational
	echo 0 > /sys/block/ram5/queue/rotational
	echo 0 > /sys/block/ram6/queue/rotational
	echo 0 > /sys/block/ram7/queue/rotational
	echo 0 > /sys/block/ram8/queue/rotational
	echo 0 > /sys/block/ram9/queue/rotational
	echo 0 > /sys/block/ram10/queue/rotational
	echo 0 > /sys/block/ram11/queue/rotational
	echo 0 > /sys/block/ram12/queue/rotational
	echo 0 > /sys/block/ram13/queue/rotational
	echo 0 > /sys/block/ram14/queue/rotational
	echo 0 > /sys/block/ram15/queue/rotational

# Knox set to 0 on working system
/sbin/resetprop -n ro.boot.warranty_bit "0"
/sbin/resetprop -n ro.warranty_bit "0"

# Fix some safetynet flags
/sbin/resetprop -n ro.boot.veritymode "enforcing"
/sbin/resetprop -n ro.boot.verifiedbootstate "green"
/sbin/resetprop -n ro.boot.flash.locked "1"
/sbin/resetprop -n ro.boot.ddrinfo "00000001"

#-------------------------
# MTWEAKS
#-------------------------

	# Make internal storage directory.
    if [ ! -d $MTWEAKS_PATH ]; then
	    $BB mkdir $MTWEAKS_PATH;
    fi;

	$BB chmod 0777 $MTWEAKS_PATH;
	$BB chown 0.0 $MTWEAKS_PATH;

	# Delete backup directory
	$BB rm -rf $MTWEAKS_PATH/bk;

    # Make backup directory.
	$BB mkdir $MTWEAKS_PATH/bk;
	$BB chmod 0777 $MTWEAKS_PATH/bk;
	$BB chown 0.0 $MTWEAKS_PATH/bk;

	# Save original voltages
	$BB cat /sys/devices/system/cpu/cpufreq/mp-cpufreq/cluster1_volt_table > $MTWEAKS_PATH/bk/cpuCl1_stock_voltage
	$BB cat /sys/devices/system/cpu/cpufreq/mp-cpufreq/cluster0_volt_table > $MTWEAKS_PATH/bk/cpuCl0_stock_voltage
	$BB cat /sys/devices/14ac0000.mali/volt_table > $MTWEAKS_PATH/bk/gpu_stock_voltage
	$BB chmod -R 755 $MTWEAKS_PATH/bk/*;

# Deepsleep fix
su -c 'echo "temporary none" >> /sys/class/scsi_disk/0:0:0:0/cache_type'
su -c 'echo "temporary none" >> /sys/class/scsi_disk/0:0:0:1/cache_type'
su -c 'echo "temporary none" >> /sys/class/scsi_disk/0:0:0:2/cache_type'
su -c 'echo "temporary none" >> /sys/class/scsi_disk/0:0:0:3/cache_type'

# "97zipalignOnBoot"
for files in `find /data/app/ -name '*.apk'` ; do
	zipalign -c 4 $files;
	ZIPCHECK=$?;
	if [ $ZIPCHECK -eq 1 ]; then
			zipalign -f 4 $files /cache/$(basename $files);
			if [ -e /cache/$(basename $files) ]; then
				cp -f -p /cache/$(basename $files) $files
				rm /cache/$(basename $files)
			fi
	fi;
done;

# Unmount
$BB mount -t rootfs -o remount,rw rootfs;
$BB mount -o remount,ro /system;
$BB mount -o remount,rw /data;
$BB mount -o remount,ro /;

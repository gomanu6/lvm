# lvm
Setup LVM configurations

Steps to Maintain and manage LVM partitions on the Server

#### Check disks
lsblk -f
lsblk -o NAME,UUID,SIZE,FSTYPE,TYPE,MOUNTPOINT
-o = specify columns

df -hT
T = print file system type

#### Check PV, VG and LV
pvdisplay
vgdisplay
lvdisplay

#### Prepare Partitions prior to using LVM
- fidsk
- create primary partition
- t = change partition type to Linux LVM (31)
- view and write changes to disk

#### Create Physical Volume
pvcreate -v /dev/sda1 /dev/sda2

-v = verbose


#### Create VOlume Group
vgcreate -v name_of_volume_group /dev/sda1 /dev/sda2

-v = verbose


#### Create Logical Volume
lvcreate -v -L 5G -n name_of_lv name_of_volume_group

-L, --size      = size of new LV e.g 5G, 200M etc
-l, --extents   = Number[%], logical extents, 
                    %VG     = total size of VG
                    %FREE   = remaining free space in the VG,
                    %PVS    = free space in specified PV
                    %ORIGIN = for a snapshot specifies the size in relation to the LV,
                    100%ORIGIN = space for whole origin


#### Format the LV
mkfs.ext4 -v -L volume_label /dev/name_of_volume_group/name_of_lv

-v  = verbose
-L  = set new volume label
-O  = Create a filesystem with given features
-E  = Extended options


#### Mount the LV
mkdir -p /mnt/mountpoint
mount -v /dev/name_of_volume_group/name_of_lv /mnt/mountpoint


#### Resize a LV
lvextend or lvresize    

##### Set LV size
lvextend -L8G /dev/name_of_volume_group/name_of_lv

##### Increase LV by 5GB
lvextend -L+5G /dev/name_of_volume_group/name_of_lv

##### Decrease LV by 3GB
lvextend -L-3G /dev/name_of_volume_group/name_of_lv

##### Run after changing LV size
e2fsck -v -f /dev/name_of_volume_group/name_of_lv

-f  = force check
-p  = Automatically repair
-v  = verbose

resize2fs /dev/name_of_volume_group/name_of_lv

-M  = Shrink the file system to minimize its size
-F  = Flush the Filesystem buffer
-p  = Prints out percentage compleion bars




#### Extend VG with another PV
create partition
vgextend -v name_of_volume_group /dev/new/drive


##### Other Options
lvreduce, vgreduce


#### Delete LV, VG, PV

lvremove /dev/name_of_volume_group/name_of_lv
vgremove name_of_volume_group
pvremove /dev/sda1 /dev/sda2

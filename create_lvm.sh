#! /bin/bash

. ./lvm.config


function create_lvm_partition () {
    local partition_name=$1

    # imported variables
    local vg_name="${volume_group_name}"

    # created variables
    local vg_path="/dev/${vg_name}/"
    local lv_name=""
    local lv_path="/dev/${vg_name}/${lv_name}"
    local lv_size="${default_lvm_size}"
    local volume_label=""

    if [ lvcreate -v -L "${lv_size}" -n "${lv_name}" "${vg_name}" ]; then
        echo "[create_lvm]: created new LV '${lv_name}'"
        if [ mkfs.ext4 -v -L "${volume_label}" "${lv_path}" ]; then
            echo "[create_lvm]: Partioning new LV"
            mount -v -L "${lv_path}" "${new_user_data_dir}"
            chown -v "$username:$smb_users_group" "$new_user_data_dir"
        else
            echo "[create_lvm]: WARNING Problem Partioning new LV"
            exit 1
        fi


    else
        echo "[create_lvm]: WARNING Error creating new LV '${lv_name}'"
        exit 1
    fi
        




}


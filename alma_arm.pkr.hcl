source "arm" "alma" {
  file_urls             = ["https://repo.almalinux.org/rpi/9/images/AlmaLinux-9-RaspberryPi-9.4-20240801.aarch64.raw.xz"]
  file_checksum_url     = "https://repo.almalinux.org/rpi/9/images/CHECKSUM"
  file_checksum_type    = "sha256"
  file_target_extension = "xz"
  file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]
  image_build_method    = "reuse"
  image_path            = "alma-9.4.img"
  image_size            = "3G"
  image_type            = "dos"
  image_partitions {
    name         = "boot"
    type         = "c"
    start_sector = "8192"
    filesystem   = "fat"
    size         = "286M"
    mountpoint   = "/boot"
  }
  image_partitions {
    name         = "root"
    type         = "83"
    start_sector = "593920"
    filesystem   = "ext4"
    size         = "2.2G"
    mountpoint   = "/"
  }
  image_chroot_env             = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  qemu_binary_source_path      = "/usr/bin/qemu-aarch64-static"
  qemu_binary_destination_path = "/usr/bin/qemu-aarch64-static"
}

build {
  sources = ["source.arm.alma"]

  provisioner "file" {
    source      = "config.txt"
    destination = "/boot/config.txt"
  }

  provisioner "file" {
    source      = "user-data.yaml"
    destination = "/boot/user-data"
  }

  provisioner "shell" {
    inline = [
      "chmod 755 /boot/config.txt",
      "chmod 755 /boot/user-data"
    ]
  }
}

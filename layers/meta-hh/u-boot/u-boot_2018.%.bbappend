FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot:"

inherit ${@oe.utils.conditional('MACHINE', 'odroid-xu4-hc2', 'uboot-boot-scr', '', d)}

COMPATIBLE_MACHINE_odroid-xu4-hc2  = "odroid-xu4-hc2"

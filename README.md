# homeautomation_hc2

Home automation project based on yocto (thud)
i.c.w. odroid support layers

Goal:

- I - Release Reproducability:
DONE - a: Fresh Yocto based build (thud at the moment)
DONE       - Prepare and build scripts
          
    - b: Resulting image directly transferrable / installable on uSD
          - Deploy script: BUSY
DONE          - Generarte WIC image
DONE          - Add bootloaders+armtz to image 
REJECT          - Be able to load linux from wic image
                  -> u-boot is not able to find Linux
                      but it does see partitions
                     > mmc part
                       Partition Map for MMC device 0  --   Partition Type: DOS

                       Part    Start Sector    Num Sectors     UUID            Type
                         1     8192            42598           98d225a3-01     0c Boot
                         2     57344           74268           98d225a3-02     83

                     > mmc read 0x43000000 0x74268 0x1c0
                     > md 0x43000000 50
                      43000000: 6f646461 355f736e 2e32312e 726f2e34    addons_5.12.4.or
                      43000010: 742e6769 782e7261 62200a7a 35303737    ig.tar.xz. b7705
                      43000020: 32323231 33363662 63353963 65336162    1222b663c95cba3e
                      43000030: 31653532 36326338 20643738 34323431    25e18c2687d 1424
                      43000040: 646b2038 616c7065 2d616d73 6f646461    8 kdeplasma-addo
                      43000050: 355f736e 2e32312e 75302d34 746e7562    ns_5.12.4-0ubunt
               -> WIC Images are very limited in their options (not supporting adding raw files
                     like the bl1.bin.hardkernel etc, so manual HDD img is the next step
BUSY:          - Generate a manual sdimg


    - c: Verified on Odroid XU4-HC2

- II - Domoticz Integration
    - a: Domoticz part of release
    - b: influxdb: Receiving all detailed forwarded data from domoticz
- III - Stability/Security/Performance
    - a: Partitioning considerations on SDD for updates
           e.g. [IMAGE_A]||[IMAGE_B]||[DATA]||[LOGGING] partition setup
    - b: Read-only rootfilesystem 
           e.g.: Ramfs based (e.g. via initramfs)
    - c: Bootable directly from SSD
    
- IV - Smart power management
- V - ...



Status:
Deployed image does not boot device (or at least no output on console seen
 -> check u-boot configuration files (u-boot.ini/scr)

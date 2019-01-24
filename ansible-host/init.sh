#!/bin/bash
sudo su -
ssh-keygen -f id_rsa -t rsa -N ''
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2QdIEjlrYnWri4+YgQJ8O82FGEWOTtdf/3iZBGmjR6uo8xUrIE9iZhH3OSLITmjQC1LDzRmaVctHVYl7hbmzFWJTgEsVO2q+QXbout+yAEx8C5XUg1YdZSDjbnkCe0AA1qGz3KWIudpCDZGRov/kkIL32ZF+PXiDbqaYN7p3su8QrYfHTqo9B9PhYS2FaununIYMDAkOaWAORidzU8kzYzFIjFiUZTNVH8oIyM+PkLc+rsRRLVONRU00HWoXrzEo1tLPxeVpn/81iPjYrGO5K2MKmqeDYR5OIgAu8deZ7n/xLiZl5qYrtEA2/K46fDZTOzEAOE1SrRzfcvVnLg4Rn trishulshah@Trishs-MacBook-Pro.local" >> /root/.ssh/authorized_keys

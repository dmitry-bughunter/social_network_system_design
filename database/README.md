### Оценка кол-ва дисков

Все данные будут храниться в PostgreSQL, кроме картинок, они будут лежать в S3 (например Ceph).
#### Посты, лента

```
traffic_per_second = 28.2 GB/s
iops = 618
capacity = 31.5 Mb/s * 365 * 86400 = 947 TB
capacity_with_reserve = 947 TB + 20% = 1089 TB

HDD:
    Disks_for_capacity = 1089 TB / 18 TB = 60.5
    Disks_for_throughput = 28.2 GB/s * 1024 / 100 MB/s = 288.7
    Disks_for_iops = 618 / 100 = 6.1
    Disks = max(ceil(60.5), ceil(288.7), ceil(6.1)) = 289
 
SSD(sata):
    Disks_for_capacity = 1089 TB / 20 TB = 54.4
    Disks_for_throughput = 28.2 GB/s * 1024 / 500 MB/s = 57.7
    Disks_for_iops = 618 / 1000 = 0.6
    Disks = max(ceil(54.4), ceil(57.7), ceil(0.6)) = 58

SSD(nVME):
    Disks_for_capacity = 1089 TB / 15.36 TB = 70.8
    Disks_for_throughput = 28.2 GB/s / 3 GB/s = 9.4
    Disks_for_iops = 618 / 10000 = 0.06
    Disks = max(ceil(70.8), ceil(9.4), ceil(0.06)) = 71

Решение: можно горячие данные хранить на ssd, а остальную часть на hdd.
Например:
8 SSD nVME по 15.37 Tb + 81 HDD по 18 ТБ.
Disks_for_capacity = 1089 TB / (15.36TB * 8) + (18TB * 54) = 0.99
Disks_for_throughput = 28.2 GB/s / (3 GB/s * 8) + (54 * 100Mb/s) = 0.96
Disks_for_iops = 618 / (10000 * 8) + (54 * 100) = 0,0072

0.99 < 1
0.96 < 1
0.0072 <1 
```

#### Реакции

```
traffic_per_second = 57.6 Kb/s
iops = 1157
capacity = 17,3 Kb/s * 365 * 86400 = 520 GB
capacity_with_reserve = 520 TB + 20% = 624 GB

HDD:
Disks_for_capacity = 624 GB / 1 TB = 0.6
Disks_for_throughput = 57.6 Kb/s / 100 MB/s = 0.0006
Disks_for_iops = 1157 / 100 = 11.5
Disks = max(ceil(0.6), ceil(0.0006), ceil(11.5)) = 12

SSD(sata):
Disks_for_capacity = 624 GB / 1 TB = 0.6
Disks_for_throughput = 57.6 Kb/s / 500 MB/s = 0.00012
Disks_for_iops = 1157 / ~ 1000 = ~ 1
Disks = max(ceil(0.6), ceil(0.00012), ceil(1)) = 1

Решение: 1 SSD(sata) диск на 1Тб
```

#### Подписки

```
traffic_per_second = 4Kb/s
iops = 24
capacity = 264 Byte/s * 365 * 86400 = 7.7 Gb
capacity_with_reserve = 7.7 Gb + 20% = 9.3 Gb  

HDD:
Disks_for_capacity = 9.3 Gb / 16 GB = 0.58
Disks_for_throughput = 4 Kb/s / 100 MB/s = 0.00004
Disks_for_iops = 24 / 100 = 0.24
Disks = max(ceil(0.58), ceil(0.00004), ceil(0.24)) = 1

Решение: 1 HDD на 16Гб

Т.к. подписки не требуют большого объёма и пропускной способности и iops, 
то можно разместить их на другой диск и не покупать отдельный для них.
```
#### Локации

```
traffic_per_second = 165.4 Mb/s  
iops = 18
capacity = 190B/s * 365 * 86400 = 5.58 Gb
capacity_with_reserve = 5.58 Gb  + 20% = 6.4 Gb

HDD:
Disks_for_capacity = 6.4 Gb / 8 GB = 0.8
Disks_for_throughput = 165.4 Mb/s / 100 MB/s = 1.65
Disks_for_iops = 18 / 100 = 0.2
Disks = max(ceil(0.8), ceil(1.65), ceil(0.2)) = 2

Решение: 2 HDD на 8Гб
```


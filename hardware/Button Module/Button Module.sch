EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	2750 2850 2700 2850
Wire Wire Line
	2800 2850 2750 2850
Connection ~ 2750 2850
Wire Wire Line
	2750 2950 2750 2850
Wire Wire Line
	2800 2950 2750 2950
$Comp
L Connector:Conn_01x01_Male J6
U 1 1 5E38EB6E
P 3000 2950
F 0 "J6" H 2972 2882 50  0001 R CNN
F 1 "B" H 2950 2950 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 3000 2950 50  0001 C CNN
F 3 "~" H 3000 2950 50  0001 C CNN
	1    3000 2950
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x01_Male J1
U 1 1 5E38A935
P 2200 2850
F 0 "J1" H 2308 3031 50  0001 C CNN
F 1 "A" H 2150 2850 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 2200 2850 50  0001 C CNN
F 3 "~" H 2200 2850 50  0001 C CNN
	1    2200 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	2400 2950 2450 2950
$Comp
L Connector:Conn_01x01_Male J2
U 1 1 5E38AF59
P 2200 2950
F 0 "J2" H 2308 3131 50  0001 C CNN
F 1 "A" H 2150 2950 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x01_P2.54mm_Vertical" H 2200 2950 50  0001 C CNN
F 3 "~" H 2200 2950 50  0001 C CNN
	1    2200 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	2450 2850 2500 2850
Wire Wire Line
	2450 2950 2450 2850
Connection ~ 2450 2850
Wire Wire Line
	2400 2850 2450 2850
$Comp
L switches:MOM-SPST SW1
U 1 1 5E388C6C
P 2600 2850
F 0 "SW1" H 2600 3077 60  0000 C CNB
F 1 "B3F-4055" H 2600 2986 40  0000 C CNN
F 2 "switches:B3F-40XX" H 2500 2725 40  0001 L TNN
F 3 "" H 2525 2625 60  0001 C CNN
F 4 "-" H 2500 3050 40  0001 L BNN "Part"
F 5 "Switch" H 2500 3150 40  0001 L BNN "Family"
	1    2600 2850
	1    0    0    -1  
$EndComp
$EndSCHEMATC

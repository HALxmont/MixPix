v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 440 -290 440 -190 {
lab=Vas}
N 710 -290 710 -180 {
lab=Vmid}
N 440 -190 440 -180 {
lab=Vas}
N 480 -150 670 -150 {
lab=Vas}
N 710 -390 710 -350 {
lab=Vsrc}
N 440 -390 710 -390 {
lab=Vsrc}
N 440 -390 440 -350 {
lab=Vsrc}
N 570 -470 570 -390 {
lab=Vsrc}
N 440 -120 440 -60 {
lab=VSS}
N 440 -60 1130 -60 {
lab=VSS}
N 1030 -210 1030 -60 {
lab=VSS}
N 710 -240 990 -240 {
lab=Vmid}
N 440 -240 530 -240 {
lab=Vas}
N 530 -240 530 -150 {
lab=Vas}
N 330 -500 530 -500 {
lab=ibias}
N 290 -580 290 -530 {
lab=VDD}
N 290 -580 1030 -580 {
lab=VDD}
N 570 -580 570 -530 {
lab=VDD}
N 570 -500 600 -500 {
lab=VDD}
N 600 -580 600 -500 {
lab=VDD}
N 240 -500 290 -500 {
lab=VDD}
N 240 -580 240 -500 {
lab=VDD}
N 240 -580 290 -580 {
lab=VDD}
N 440 -320 710 -320 {
lab=VDD}
N 670 -580 670 -320 {
lab=VDD}
N 710 -120 710 -60 {
lab=VSS}
N 710 -150 740 -150 {
lab=VSS}
N 740 -150 740 -60 {
lab=VSS}
N 400 -150 440 -150 {
lab=VSS}
N 400 -150 400 -60 {
lab=VSS}
N 400 -60 440 -60 {
lab=VSS}
N 1030 -580 1030 -490 {
lab=VDD}
N 1030 -430 1030 -270 {
lab=OUT}
N 1030 -460 1060 -460 {
lab=VDD}
N 1060 -580 1060 -460 {
lab=VDD}
N 1030 -580 1060 -580 {
lab=VDD}
N 480 -550 480 -500 {
lab=ibias}
N 480 -550 890 -550 {
lab=ibias}
N 890 -550 890 -460 {
lab=ibias}
N 890 -460 990 -460 {
lab=ibias}
N 290 -470 290 -270 {
lab=ibias}
N 1030 -360 1080 -360 {
lab=OUT}
N 1060 -580 1110 -580 {
lab=VDD}
N 380 -320 400 -320 {
lab=IN_M}
N 750 -320 780 -320 {
lab=IN_M}
N 970 -320 1030 -320 {
lab=OUT}
N 880 -320 910 -320 {
lab=Vmid}
N 880 -320 880 -240 {
lab=Vmid}
N 1030 -240 1090 -240 {
lab=VSS}
N 1090 -240 1090 -60 {
lab=VSS}
N 290 -420 370 -420 {
lab=ibias}
N 370 -500 370 -420 {
lab=ibias}
N 570 -430 590 -430 {
lab=Vsrc}
N 530 -240 540 -240 {
lab=Vas}
N 790 -270 790 -240 {
lab=Vmid}
C {devices/ipin.sym} 90 -550 0 0 {name=p2 lab=IN_M
}
C {devices/ipin.sym} 90 -530 0 0 {name=p1 lab=IN_P}
C {devices/ipin.sym} 90 -570 0 0 {name=p9 lab=ibias}
C {devices/ipin.sym} 90 -490 0 0 {name=p4 lab=VDD}
C {devices/ipin.sym} 90 -470 0 0 {name=p5 lab=VSS}
C {devices/lab_wire.sym} 380 -320 0 0 {name=l8 sig_type=std_logic lab=IN_M}
C {devices/lab_wire.sym} 780 -320 0 1 {name=l9 sig_type=std_logic lab=IN_P
\\
}
C {devices/lab_wire.sym} 1080 -360 0 1 {name=l13 sig_type=std_logic lab=OUT}
C {devices/lab_wire.sym} 290 -270 0 1 {name=l18 sig_type=std_logic lab=ibias}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 730 -320 0 1 {name=M2
L=1.2
W=12
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 420 -320 0 0 {name=M1
L=1.2
W=12
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 1010 -460 0 0 {name=M5
L=1
W=5.12
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 690 -150 0 0 {name=M4
L=0.5
W=1.5
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 460 -150 0 1 {name=M3
L=0.5
W=1.5
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {devices/lab_wire.sym} 1110 -580 0 1 {name=l25 sig_type=std_logic lab=VDD
}
C {devices/lab_wire.sym} 1130 -60 0 1 {name=l1 sig_type=std_logic lab=VSS
}
C {devices/capa.sym} 940 -320 1 0 {name=C1
m=1
value=63f
footprint=1206
device="ceramic capacitor"}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 1010 -240 0 0 {name=M6
L=1
W=25
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 550 -500 0 0 {name=M7
L=1
W=1
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 310 -500 0 1 {name=M8
L=1
W=2
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'" 
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'" 
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {devices/lab_pin.sym} 590 -430 0 1 {name=l2 sig_type=std_logic lab=Vsrc}
C {devices/lab_pin.sym} 540 -240 0 1 {name=l3 sig_type=std_logic lab=Vas}
C {devices/lab_pin.sym} 790 -270 0 1 {name=l4 sig_type=std_logic lab=Vmid}
C {devices/opin.sym} 70 -510 0 0 {name=p3 lab=OUT}

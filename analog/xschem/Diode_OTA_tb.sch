v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 630 -550 630 -530 { lab=V1V8}
N 630 -470 630 -450 { lab=GND}
N 1280 -40 1280 -20 { lab=GND}
N 1280 -120 1280 -100 { lab=#net1}
N 1260 -520 1260 -500 { lab=GND}
N 1120 -520 1120 -500 { lab=V1V8}
N 1710 -230 1710 -210 { lab=GND}
N 1710 -320 1710 -290 { lab=out}
N 1280 -140 1280 -120 { lab=#net1}
N 1360 -320 1440 -320 { lab=out}
N 1440 -320 1710 -320 { lab=out}
N 1710 -320 1730 -320 {
lab=out}
N 1000 -280 1020 -280 {
lab=#net2}
N 1000 -360 1020 -360 {
lab=in}
N 1560 -610 1560 -320 {
lab=out}
N 1000 -760 1180 -760 {
lab=in}
N 1000 -760 1000 -610 {
lab=in}
N 1240 -760 1560 -760 {
lab=out}
N 1560 -760 1560 -610 {
lab=out}
N 700 -350 700 -330 { lab=#net3}
N 700 -270 700 -250 { lab=#net3}
N 700 -360 810 -360 {
lab=#net3}
N 700 -360 700 -350 {
lab=#net3}
N 940 -210 940 -190 { lab=#net2}
N 940 -130 940 -110 { lab=GND}
N 940 -280 940 -210 {
lab=#net2}
N 940 -280 1000 -280 {
lab=#net2}
N 870 -360 1000 -360 {
lab=in}
N 1000 -610 1000 -360 {
lab=in}
N 700 -330 700 -270 {
lab=#net3}
N 900 -410 900 -360 {
lab=in}
N 1000 -910 1180 -910 {
lab=in}
N 1000 -910 1000 -740 {
lab=in}
N 1240 -910 1560 -910 {
lab=out}
N 1560 -910 1560 -740 {
lab=out}
N 810 -360 810 -280 {
lab=#net3}
N 870 -360 870 -280 {
lab=in}
C {devices/code_shown.sym} 18.75 -1151.875 0 0 {name=NGSPICE
only_toplevel=true
value="
.param CM_VOLTAGE = 0.9
.param OUTPUT_VOLTAGE = 0.9
.control
set hcopydevtype = svg
set nolegend
set color0=white
set color1=black
set color2=blue
set color3=red

save all
tran 10u 50m
plot out 
*ac dec 200 10 1000Meg
*settype decibel out
*plot vdb(out)
*let phase_val = 180/PI*cph(out)
*let phase_margin_val = 180 + 180/PI*cph(out)
*settype phase phase_val
*plot phase_val
*meas ac phase_margin find phase_margin_val when vdb(out)=0
*meas ac crossover_freq WHEN vdb(out)=0

let id1  = @m.x1.xm1.msky130_fd_pr__pfet_01v8_lvt[id]
let id2  = @m.x1.xm2.msky130_fd_pr__pfet_01v8_lvt[id]
let id3  = @m.x1.xm3.msky130_fd_pr__nfet_01v8_lvt[id]
let id4  = @m.x1.xm4.msky130_fd_pr__nfet_01v8_lvt[id]
let id5  = @m.x1.xm5.msky130_fd_pr__pfet_01v8_lvt[id]
let id6  = @m.x1.xm6.msky130_fd_pr__nfet_01v8_lvt[id]
let id7  = @m.x1.xm7.msky130_fd_pr__pfet_01v8_lvt[id]
let id8  = @m.x1.xm8.msky130_fd_pr__pfet_01v8_lvt[id]
let gm1  = @m.x1.xm1.msky130_fd_pr__pfet_01v8_lvt[gm]
let gm2  = @m.x1.xm2.msky130_fd_pr__pfet_01v8_lvt[gm]
let gm3  = @m.x1.xm3.msky130_fd_pr__nfet_01v8_lvt[gm]
let gm4  = @m.x1.xm4.msky130_fd_pr__nfet_01v8_lvt[gm]
let gm5  = @m.x1.xm5.msky130_fd_pr__pfet_01v8_lvt[gm]
let gm6  = @m.x1.xm6.msky130_fd_pr__nfet_01v8_lvt[gm]
let gm7  = @m.x1.xm7.msky130_fd_pr__pfet_01v8_lvt[gm]
let gm8  = @m.x1.xm8.msky130_fd_pr__pfet_01v8_lvt[gm]
let gds2  = @m.x1.xm2.msky130_fd_pr__pfet_01v8_lvt[gds]
let gds4  = @m.x1.xm4.msky130_fd_pr__nfet_01v8_lvt[gds]
let gds5  = @m.x1.xm5.msky130_fd_pr__pfet_01v8_lvt[gds]
let gds6  = @m.x1.xm6.msky130_fd_pr__nfet_01v8_lvt[gds]


let cgs6  = @m.x1.xm6.msky130_fd_pr__nfet_01v8_lvt[cgg]

*print v(inp)
*print v(inm)
*print v(out)
let v_offset = v(inp)-v(inm)
*print v_offset

*print cgs6
print id1
print id2
print id3
print id4
print id5
print id6
print id7
*print id8

print gm2
print gm6

print gm1/id1
print gm2/id2
print gm3/id3
print gm4/id4
print gm5/id5
print gm6/id6
print gm7/id7
print gm8/id8

let Av1 = gm2/(gds2+gds4)
let Av2 = gm6/(gds6 + gds5)
let Av  = Av1*Av2

print Av1
print Av2
print 20*log10(Av)  

.endc
"}
C {devices/code.sym} 760 -850 0 0 {name=STDCELL_MODELS 
only_toplevel=true
place=end
format="tcleval(@value )"
value="[sky130_models]"
name=s1 only_toplevel=false value=blabla}
C {devices/vsource.sym} 630 -500 0 0 {name=V1 value=1.8}
C {devices/gnd.sym} 630 -450 0 0 {name=l2 lab=GND}
C {devices/lab_pin.sym} 630 -550 0 0 {name=l3 sig_type=std_logic lab=V1V8
}
C {devices/isource.sym} 1280 -70 0 0 {name=I0 value=45u
}
C {devices/gnd.sym} 1280 -20 0 0 {name=l1 lab=GND}
C {devices/lab_pin.sym} 1120 -520 0 0 {name=l21 sig_type=std_logic lab=V1V8
}
C {devices/gnd.sym} 1260 -520 2 0 {name=l22 lab=GND}
C {devices/capa.sym} 1710 -260 0 0 {name=C1
m=1
value=150f
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 1710 -210 0 0 {name=l24 lab=GND}
C {devices/code.sym} 760 -680 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
*.lib \\\\$::SKYWATER_MODELS\\\\/models/sky130.lib.spice tt
.lib /home/icarosix/asic/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.option wnflag=1
"}
C {devices/lab_pin.sym} 1730 -320 0 1 {name=l5 sig_type=std_logic lab=out}
C {OTA3_kh_PVersion.sym} 1180 -320 0 0 {name=x1}
C {devices/gnd.sym} 700 -190 0 0 {name=l4 lab=GND}
C {devices/vsource.sym} 940 -160 0 0 {name=V3 value=0.9}
C {devices/gnd.sym} 940 -110 0 0 {name=l7 lab=GND}
C {devices/lab_pin.sym} 900 -410 0 0 {name=l6 sig_type=std_logic lab=in
}
C {devices/vsource.sym} 700 -220 0 0 {name=V4 value=1.8}
C {sky130_fd_pr/diode.sym} 840 -360 3 0 {name=D1
model=diode_pw2nd_05v5
area=1e12
dtemp=-5
}
C {sky130_fd_pr/cap_mim_m3_1.sym} 1210 -760 1 0 {name=C2 model=cap_mim_m3_1 W=10 L=10 MF=1 spiceprefix=X}
C {devices/res.sym} 1210 -910 1 0 {name=R1
value=100000k
footprint=1206
device=resistor
m=1}
C {devices/isource.sym} 840 -280 3 0 {name=I1 value=10n}

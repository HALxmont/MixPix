v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 800 -350 800 -330 { lab=GND}
N 800 -430 800 -410 { lab=#net1}
N 800 -450 800 -430 {
lab=#net1}
N 800 -450 940 -450 {
lab=#net1}
N 1030 -450 1030 -420 {
lab=#net1}
N 940 -450 1030 -450 {
lab=#net1}
N 1030 -450 1210 -450 {
lab=#net1}
N 1210 -450 1210 -420 {
lab=#net1}
N 1210 -370 1210 -360 {
lab=#net2}
N 800 -330 800 -300 {}
C {devices/code_shown.sym} 458.75 -561.875 0 0 {name=NGSPICE
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
dc V2 -5 0 100u

plot I(V1) I(V3)

hardcopy Inverse.svg I(V1) I(V3)


.endc
"}
C {devices/code.sym} 890 -680 0 0 {name=STDCELL_MODELS 
only_toplevel=true
place=end
format="tcleval(@value )"
value="[sky130_models]"
name=s1 only_toplevel=false value=blabla}
C {devices/vsource.sym} 800 -380 0 0 {name=V2 value=0}
C {devices/gnd.sym} 800 -300 0 0 {name=l16 lab=GND}
C {devices/code.sym} 760 -680 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
*.lib \\\\$::SKYWATER_MODELS\\\\/models/sky130.lib.spice tt
.lib /home/icarosix/asic/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.option wnflag=1
"}
C {devices/gnd.sym} 1030 -300 0 0 {name=l1 lab=GND}
C {devices/vsource.sym} 1210 -330 0 0 {name=V1 value=0}
C {devices/vsource.sym} 1030 -330 0 0 {name=V3 value=0}
C {devices/gnd.sym} 1210 -300 0 0 {name=l2 lab=GND}
C {devices/diode.sym} 1030 -390 0 0 {name=D1 model=D1N914 area=1}
C {devices/diode.sym} 1210 -400 0 0 {name=D2 model=D1N914 area=1}

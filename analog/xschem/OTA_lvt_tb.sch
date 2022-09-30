v {xschem version=3.0.0 file_version=1.2 }
G {}
K {}
V {}
S {}
E {}
N 760 -490 760 -470 { lab=V1V8}
N 760 -410 760 -390 { lab=GND}
N 1280 -40 1280 -20 { lab=GND}
N 1280 -120 1280 -100 { lab=#net1}
N 750 -160 750 -140 { lab=GND}
N 750 -240 750 -220 { lab=#net2}
N 750 -320 750 -300 { lab=INP}
N 750 -320 770 -320 { lab=INP}
N 1260 -520 1260 -500 { lab=GND}
N 1120 -520 1120 -500 { lab=V1V8}
N 1000 -360 1020 -360 { lab=INP}
N 1000 -280 1020 -280 { lab=INM}
N 1710 -230 1710 -210 { lab=GND}
N 1710 -320 1710 -290 { lab=out}
N 1280 -140 1280 -120 { lab=#net1}
N 1440 -140 1440 -100 { lab=INM}
N 1440 -40 1440 -20 { lab=GND}
N 1440 -120 1460 -120 { lab=INM}
N 1440 -220 1440 -200 { lab=out}
N 1360 -320 1440 -320 { lab=out}
N 1440 -320 1710 -320 { lab=out}
N 1710 -320 1730 -320 {
lab=out}
N 1440 -240 1440 -220 {
lab=out}
N 1440 -320 1440 -300 {
lab=out}
N 1440 -300 1440 -240 {
lab=out}
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
*dc V3 -20m 20m 1u
plot out inp
hardcopy Output.svg xlabel "time[s]" ylabel "output[mV]" title "Outputvoltage"  out
reset
ac dec 200 10 1000Meg
settype decibel out
plot vdb(out)
hardcopy Magnitude.svg xlabel "frequency[Hz]" ylabel "Av[dB]" title "Voltagegain"  vdb(out)
let phase_val = 180/PI*cph(out)
let phase_margin_val = 180 + 180/PI*cph(out)
settype phase phase_val
plot phase_val
hardcopy Phase.svg xlabel "frequency[Hz]" ylabel "phase[deg]" title "Phaseshift"  phase_val
meas ac phase_margin find phase_margin_val when vdb(out)=0
meas ac crossover_freq WHEN vdb(out)=0

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
C {devices/code.sym} 890 -680 0 0 {name=STDCELL_MODELS 
only_toplevel=true
place=end
format="tcleval(@value )"
value="[sky130_models]"
name=s1 only_toplevel=false value=blabla}
C {devices/vsource.sym} 760 -440 0 0 {name=V1 value=1.8}
C {devices/gnd.sym} 760 -390 0 0 {name=l2 lab=GND}
C {devices/lab_pin.sym} 760 -490 0 0 {name=l3 sig_type=std_logic lab=V1V8
}
C {devices/isource.sym} 1280 -70 0 0 {name=I0 value=45u
}
C {devices/gnd.sym} 1280 -20 0 0 {name=l1 lab=GND}
C {devices/vsource.sym} 750 -190 0 0 {name=V2 value=\{CM_VOLTAGE\}}
C {devices/gnd.sym} 750 -140 0 0 {name=l16 lab=GND}
C {devices/vsource.sym} 750 -270 0 0 {name=V3 value="dc 0 ac 1 sin(0, 10u, 100))"}
C {devices/lab_pin.sym} 770 -320 2 0 {name=l18 sig_type=std_logic lab=INP


}
C {devices/lab_pin.sym} 1000 -360 0 0 {name=l19 sig_type=std_logic lab=INP
}
C {devices/lab_pin.sym} 1000 -280 0 0 {name=l20 sig_type=std_logic lab=INM
}
C {devices/lab_pin.sym} 1120 -520 0 0 {name=l21 sig_type=std_logic lab=V1V8
}
C {devices/gnd.sym} 1260 -520 2 0 {name=l22 lab=GND}
C {devices/capa.sym} 1710 -260 0 0 {name=C1
m=1
value=150f
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 1710 -210 0 0 {name=l24 lab=GND}
C {devices/res.sym} 1440 -170 0 0 {name=R1
value=10E6
footprint=1206
device=resistor
m=1}
C {devices/capa.sym} 1440 -70 0 0 {name=C2
m=1
value=1
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 1440 -20 0 0 {name=l4 lab=GND}
C {devices/lab_pin.sym} 1460 -120 0 1 {name=l6 sig_type=std_logic lab=INM
}
C {devices/code.sym} 760 -680 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
*.lib \\\\$::SKYWATER_MODELS\\\\/models/sky130.lib.spice tt
.lib /home/icarosix/asic/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.option wnflag=1
"}
C {devices/lab_pin.sym} 1730 -320 0 1 {name=l5 sig_type=std_logic lab=out}
C {OTA.sym} 1180 -320 0 0 {name=x1}

#!/usr/bin/env python3
"""Plot archived waveforms. Requires matplotlib, not a hardware simulator."""
from analyze_archive import ROOT,read_vcd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
f=next((ROOT/'results/archive/test_run_dir').rglob('Top.vcd'));n,ev=read_vcd(f)
x=[t for t,v in ev if n['Top.io_txd'] in v];y=[v[n['Top.io_txd']] for t,v in ev if n['Top.io_txd'] in v]
fig,ax=plt.subplots(figsize=(10,3),layout='constrained');ax.step(x,y,where='post',color='#12677c',lw=1.4)
for t,label in [(151,'0A'),(1251,'00'),(2351,'00'),(3451,'00')]:
 ax.axvspan(t,t+1000,color='#12677c',alpha=.07);ax.text(t+500,1.17,'0x'+label,ha='center')
ax.set(ylim=(-.2,1.4),yticks=[0,1],xlabel='Archived VCD time (ns)',ylabel='TXD',title='FIR result 10 serialized as four little-endian UART bytes');ax.grid(axis='x',alpha=.2)
fig.savefig(ROOT/'docs/figures/top-uart-trace.png',dpi=180)

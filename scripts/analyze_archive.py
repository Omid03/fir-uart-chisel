#!/usr/bin/env python3
"""Analyze supplied VCDs, without running Chisel or HDL simulation."""
from pathlib import Path
import re,bisect,json,csv,hashlib
ROOT=Path(__file__).resolve().parents[1]
def read_vcd(f):
 head,body=re.split(r'\$enddefinitions\s+\$end',f.read_text(),maxsplit=1)
 assert re.search(r'\$timescale\s+1ns\s+\$end',head)
 names={};stack=[]
 for l in head.splitlines():
  s=l.split()
  if not s:continue
  if s[0]=='$scope':stack.append(s[2])
  elif s[0]=='$upscope':stack.pop()
  elif s[0]=='$var':names['.'.join(stack+[s[4]])]=s[3]
 vals={};events=[];t=0
 for l in body.splitlines():
  l=l.strip()
  if not l:continue
  if l[0]=='#':events.append((t,vals.copy()));t=int(l[1:])
  elif l[0] in 'bB':
   v,c=l[1:].split();vals[c]=int(v,2) if set(v)<=set('01') else None
  elif l[0] in '01xzXZ':vals[l[1:]]=int(l[0]) if l[0] in '01' else None
 events.append((t,vals.copy()));return names,events

def transfers(n,events,top,base):
 prev={};rows=[]
 for t,v in events:
  if v.get(n[top+'.clock'])==1 and prev.get(n[top+'.clock'])==0 and prev.get(n[top+'.reset'])==0:
   if prev.get(n[base+'_valid'])==1 and prev.get(n[base+'_ready'])==1:rows.append({'time_ns':t,'value':prev[n[base+'_bits']]})
  prev=v
 return rows

def decode(n,ev,top):
 key=n[top+'.io_txd'];trans=[];old=None;times=[x[0] for x in ev]
 for t,v in ev:
  a=v.get(key)
  if a!=old:trans.append((t,a));old=a
 def at(t):
  assert t<=times[-1], 'Incomplete frame'
  return ev[bisect.bisect_right(times,t)-1][1].get(key)
 frames=[];end=-1
 for i,(t,value) in enumerate(trans):
  if value==0 and i and trans[i-1][1]==1 and t>=end:
   bits=[at(t+50+j*100) for j in range(10)]
   assert bits[0]==0 and bits[9]==1 and all(b in [0,1] for b in bits)
   frames.append({'start_ns':t,'byte':sum(bits[j+1]<<j for j in range(8)),'stop_bit':bits[9]});end=t+1000
 return frames

def main():
 result={}
 for f in sorted((ROOT/'results/archive/test_run_dir').rglob('*.vcd')):
  n,ev=read_vcd(f);top=f.stem
  rec={'source':str(f.relative_to(ROOT)),'sha256':hashlib.sha256(f.read_bytes()).hexdigest(),'last_timestamp_ns':ev[-1][0]}
  if top=='FIR':
   rec['inputs']=transfers(n,ev,top,'FIR.io_in');rec['outputs']=transfers(n,ev,top,'FIR.io_out')
   assert [x['value'] for x in rec['inputs']]==[10,20,30]
   assert [x['value'] for x in rec['outputs']]==[10,40,100]
  else:
   rec['inputs']=transfers(n,ev,top,top+('.io_firIn' if top=='Top' else '.io_channel'));rec['frames']=decode(n,ev,top)
   assert [x['byte'] for x in rec['frames']]==([10,0,0,0] if top=='Top' else [85])
   if top=='Top':rec['reconstructed_word']=sum(x['byte']<<(8*i) for i,x in enumerate(rec['frames']))
  result[top]=rec
 (ROOT/'results/vcd-analysis.json').write_text(json.dumps(result,indent=2)+'\n')
 with (ROOT/'results/fir-transfers.csv').open('w',newline='') as f:
  w=csv.writer(f);w.writerow(['input_time_ns','input_value','output_transfer_ns','output_value'])
  for a,b in zip(result['FIR']['inputs'],result['FIR']['outputs']):w.writerow([a['time_ns'],a['value'],b['time_ns'],b['value']])
 with (ROOT/'results/uart-frames.csv').open('w',newline='') as f:
  w=csv.writer(f);w.writerow(['capture','start_ns','byte_hex','stop_bit'])
  for top in ['BufferedTx','Top']:
   for x in result[top]['frames']:w.writerow([top,x['start_ns'],f"{x['byte']:02X}",x['stop_bit']])
 print('PASS: archived FIR outputs 10,40,100; UART 55; Top 0A 00 00 00; sampled 8N1 framing valid.')
 print('Historical waveform analysis only; no HDL simulation.')
if __name__=='__main__':main()

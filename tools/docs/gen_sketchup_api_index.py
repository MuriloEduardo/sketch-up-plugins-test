#!/usr/bin/env python3
"""Gera docs/reference/sketchup-api-index.md a partir dos stubs YARD (SketchUp/ruby-api-stubs, MIT).

Uso: python3 gen_sketchup_api_index.py <pasta stubs> > docs/reference/sketchup-api-index.md
"""
import os,re,sys
root=sys.argv[1]
out=[]
files=sorted(os.path.join(d,f) for d,_,fs in os.walk(root) for f in fs if f.endswith('.rb'))
for path in files:
    lines=open(path,encoding='utf-8').read().split('\n')
    rel=os.path.relpath(path,root)
    comment=[]; entries=[]; cls=None; cls_doc=''; cls_ver=''
    for ln in lines:
        s=ln.strip()
        if s.startswith('#'):
            comment.append(s[1:].strip()); continue
        m=re.match(r'(class|module)\s+([\w:]+)(\s*<\s*([\w:]+))?',s)
        if m and cls is None:
            cls=m.group(2)+(' < '+m.group(4) if m.group(4) else '')
            txt=[c for c in comment if c and not c.startswith('@') and not c.startswith('Copyright') and not c.startswith('License')]
            cls_doc=txt[0] if txt else ''
            v=[c for c in comment if c.startswith('@version')]
            cls_ver=v[0].replace('@version','').strip() if v else ''
        m=re.match(r'def\s+(self\.)?([^\s(]+)(\(.*\))?',s)
        if m:
            txt=[]
            for c in comment:
                if c.startswith('@'): break
                txt.append(c)
            first=re.sub(r'^(Class Methods|Instance Methods)\s+','',' '.join(t for t in txt if t)).split('. ')[0][:150]
            ver=[c.replace('@version','').strip() for c in comment if c.startswith('@version')]
            dep=any(c.startswith('@deprecated') for c in comment)
            ov=[c.replace('@overload','').strip() for c in comment if c.startswith('@overload')]
            sig=(ov[0] if ov else m.group(2)+(m.group(3) or ''))
            sig=re.sub(r'^self\.','',sig)
            if m.group(1) and not sig.startswith('self.') and not ov: pass
            prefix='.' if m.group(1) else '#'
            entries.append(f"- `{prefix}{sig}`{' ['+ver[0]+']' if ver else ''}{' **DEPRECATED**' if dep else ''} — {first}")
        if s and not s.startswith('#'): comment=[]
    consts=[re.match(r'([A-Z][A-Z0-9_]+)\s*=',l.strip()).group(1) for l in lines if re.match(r'\s+[A-Z][A-Z0-9_]+\s*=',l)]
    out.append(f"\n## {cls or rel}\n_{rel}_ {('['+cls_ver+']') if cls_ver else ''}\n\n{cls_doc}\n")
    if consts: out.append('Constants: '+', '.join(consts)+'\n')
    out.extend(entries)
print('# SketchUp Ruby API — method index\n\nGenerated from SketchUp/ruby-api-stubs. `.` = module/class method, `#` = instance method, [SketchUp X] = min version.\n'+'\n'.join(out))

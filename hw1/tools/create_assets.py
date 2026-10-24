"""Create original geometric event posters. Only needed to regenerate assets.

Run from the project root with Python + Pillow. Bundled PNGs need no Python.
"""
from pathlib import Path
from math import sin, cos, pi
from PIL import Image, ImageDraw, ImageFont

OUT = Path('assets/images')
OUT.mkdir(parents=True, exist_ok=True)
W, H = 1200, 700
FONT = 'assets/fonts/Manrope-ExtraBold.ttf'


def poster(top, bottom):
    im = Image.new('RGB', (W, H))
    d = ImageDraw.Draw(im)
    for y in range(H):
        t = y / H
        d.line((0, y, W, y), fill=tuple(int(a*(1-t)+b*t) for a, b in zip(top, bottom)))
    return im, d


def label(d, title, sub, color):
    d.text((66, 405), title, font=ImageFont.truetype(FONT, 68), fill=color)
    d.text((70, 590), sub, font=ImageFont.truetype(FONT, 21), fill=color)


im, d = poster((205, 200, 233), (177, 174, 217))
for x in range(0, W, 60):
    d.line((x, 0, x, H), fill='#b7b3d6', width=1)
for y in range(0, H, 60):
    d.line((0, y, W, y), fill='#b7b3d6', width=1)
for r in [170, 250, 330]:
    d.ellipse((770-r, 260-r, 770+r, 260+r), outline='#eeeaf9', width=3)
d.rounded_rectangle((610, 95, 930, 415), 66, fill='#303b4b')
d.rounded_rectangle((632, 115, 908, 387), 48, fill='#233930')
d.rounded_rectangle((663, 145, 877, 358), 33, fill='#d5ef8a')
for x in range(650, 920, 46):
    d.line((x, 73, x, 95), fill='#303b4b', width=12)
    d.line((x, 415, x, 438), fill='#303b4b', width=12)
for y in range(140, 405, 46):
    d.line((587, y, 610, y), fill='#303b4b', width=12)
    d.line((930, y, 953, y), fill='#303b4b', width=12)
d.line((749, 200, 707, 250, 749, 300), fill='#233930', width=13)
d.line((791, 200, 833, 250, 791, 300), fill='#233930', width=13)
d.ellipse((1025, 112, 1063, 150), fill='#eaf3ba')
label(d, 'MAKE WHAT\nCOMES NEXT.', 'CAMPUS / TECHNOLOGY / 2026', '#263c35')
im.save(OUT/'technology.png', optimize=True)

im, d = poster((240, 180, 141), (231, 151, 114))
for x in [650, 750, 850]:
    d.rounded_rectangle((x, 65, x+160, 480), 80, fill='#f8d8aa', outline='#edc28d', width=3)
for i in range(6):
    r=45+i*24
    d.ellipse((930-r, 280-r, 930+r, 280+r), outline='#455b43', width=8)
d.ellipse((890, 240, 970, 320), fill='#ebad83')
d.polygon([(630, 122), (660, 305), (565, 323), (535, 140)], fill='#334d3f')
d.ellipse((544, 290, 660, 344), fill='#334d3f')
d.line((630, 122, 765, 88), fill='#334d3f', width=18)
d.line((765, 88, 795, 255), fill='#334d3f', width=18)
d.ellipse((699, 236, 799, 282), fill='#334d3f')
label(d, 'FIND YOUR\nOWN RHYTHM.', 'CAMPUS / ARTS & CULTURE / 2026', '#334d3f')
im.save(OUT/'arts.png', optimize=True)

im, d = poster((148, 173, 110), (112, 148, 96))
d.rounded_rectangle((505, 60, 1110, 645), 24, fill='#376450')
d.rectangle((551, 105, 1064, 601), outline='#e8e9c7', width=5)
d.rectangle((595, 105, 1020, 601), outline='#e8e9c7', width=4)
d.line((551, 353, 1064, 353), fill='#e8e9c7', width=5)
d.line((595, 235, 1020, 235), fill='#e8e9c7', width=4)
d.line((595, 470, 1020, 470), fill='#e8e9c7', width=4)
d.line((807, 235, 807, 470), fill='#e8e9c7', width=4)
d.ellipse((842, 155, 1022, 335), fill='#dbed8f')
d.arc((816, 153, 951, 339), -85, 85, fill='#f8ffe0', width=6)
d.arc((913, 153, 1048, 339), 95, 265, fill='#f8ffe0', width=6)
label(d, 'A LITTLE\nMORE PLAY.', 'CAMPUS / SPORTS & MOVEMENT / 2026', '#f6f1d9')
im.save(OUT/'sports.png', optimize=True)

# Original app icon, exported to Android launcher densities and web icons.
icon=Image.new('RGB',(512,512),'#215c43')
di=ImageDraw.Draw(icon)
di.ellipse((232,100,310,340),fill='#d5ef8a')
di.ellipse((105,175,263,292),fill='#d5ef8a')
di.ellipse((267,175,425,292),fill='#d5ef8a')
di.line((256,260,256,405),fill='#d5ef8a',width=19)
for size in [192,512]:
    icon.resize((size,size),Image.Resampling.LANCZOS).save(f'web/icons/Icon-{size}.png')
    icon.resize((size,size),Image.Resampling.LANCZOS).save(f'web/icons/Icon-maskable-{size}.png')
icon.resize((32,32),Image.Resampling.LANCZOS).save('web/favicon.png')
for density,size in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    icon.resize((size,size),Image.Resampling.LANCZOS).save(f'android/app/src/main/res/mipmap-{density}/ic_launcher.png')
print('Created 3 original posters and launcher icons.')

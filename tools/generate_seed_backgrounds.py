from pathlib import Path
from PIL import Image, ImageDraw
import random

W, H = 480, 854
OUT = Path('app/assets/images/backgrounds/seed')
OUT.mkdir(parents=True, exist_ok=True)

PALETTES = {
    'beijing-forbidden-city': [('#f3b873', '#811f1f'), ('#f0d296', '#9e2b23'), ('#7387b8', '#791c23')],
    'shanghai-bund': [('#c2dee8', '#507180'), ('#f2c696', '#52717e'), ('#66749a', '#2e4258')],
    'xian-city-wall': [('#eec68b', '#925330'), ('#deae6e', '#7e4b2f'), ('#707399', '#694132')],
    'hangzhou-west-lake': [('#c3e4d7', '#52938b'), ('#edd39d', '#5c9383'), ('#7a92aa', '#447075')],
    'chengdu-kuanzhai-alley': [('#dae2b8', '#6f8e51'), ('#efc48f', '#826244'), ('#718b7f', '#4a5b49')],
    'nanjing-qinhuai-river': [('#eacaaa', '#8d4a3e'), ('#f5d697', '#9a4a3c'), ('#6b7ba0', '#6e363e')],
    'guangzhou-chen-clan': [('#e0dab4', '#5a8276'), ('#f0c384', '#667e70'), ('#6a8091', '#415e60')],
}


def rgb(value):
    value = value.lstrip('#')
    return tuple(int(value[index:index + 2], 16) for index in (0, 2, 4))


def gradient(image, first, second):
    a, b = rgb(first), rgb(second)
    pixels = image.load()
    for y in range(H):
        ratio = y / (H - 1)
        ratio = ratio * ratio * (3 - 2 * ratio)
        color = tuple(int(a[index] * (1 - ratio) + b[index] * ratio) for index in range(3))
        for x in range(W):
            pixels[x, y] = color


def roof(draw, center_x, y, width, height, body, roof_color, accent):
    draw.rectangle((center_x-width//2, y, center_x+width//2, y+height), fill=body)
    draw.polygon([(center_x-width//2-20, y), (center_x+width//2+20, y), (center_x+width//2, y-28), (center_x-width//2, y-28)], fill=roof_color)
    draw.polygon([(center_x-width//2-20, y), (center_x-width//2-4, y-18), (center_x-width//2-36, y-10)], fill=roof_color)
    draw.polygon([(center_x+width//2+20, y), (center_x+width//2+4, y-18), (center_x+width//2+36, y-10)], fill=roof_color)
    draw.rectangle((center_x-width//2+8, y+12, center_x+width//2-8, y+17), fill=accent)


def beijing(draw, variant):
    draw.rectangle((0, 530, W, H), fill=(75, 35, 27))
    draw.rectangle((0, 530, W, 710), fill=(132, 35, 34))
    roof(draw, W//2, 480, 260, 150, (136,36,34), (183,128,38), (235,190,86))
    roof(draw, W//2, 410, 180, 75, (125,34,32), (198,145,43), (239,196,96))
    draw.rounded_rectangle((W//2-50, 585, W//2+50, 710), 12, fill=(76,31,27))
    draw.polygon([(0,760), (W,720), (W,H), (0,H)], fill=(182,150,118))


def shanghai(draw, variant):
    horizon = 535
    draw.rectangle((0, horizon, W, H), fill=(48,89,111))
    for index in range(14):
        y = horizon + 20 + index * 18
        draw.line((20, y, W-20, y), fill=(120,170,180), width=2)
    x = 15
    for index, width in enumerate([45,38,53,32,48]):
        height = 95 + [10,35,0,20,50][index]
        draw.rectangle((x, horizon-height, x+width, horizon), fill=(80,75,68))
        x += width + 7
    for center, top, width in [(285,230,42), (335,150,30), (382,205,38), (428,260,27)]:
        draw.rectangle((center-width//2, top, center+width//2, horizon), fill=(45,63,79))
    center = 330
    draw.line((center,150,center,horizon), fill=(58,63,76), width=8)
    draw.ellipse((center-28,265,center+28,321), fill=(111,84,113))
    draw.ellipse((center-16,205,center+16,237), fill=(153,104,135))
    draw.line((center,90,center,205), fill=(58,63,76), width=5)


def xian(draw, variant):
    draw.rectangle((0,500,W,H), fill=(139,87,52))
    for x in range(0, W, 42):
        draw.rectangle((x,480,x+24,510), fill=(139,87,52))
    roof(draw, W//2, 430, 180, 100, (110,65,43), (63,53,46), (177,121,64))
    roof(draw, W//2, 370, 125, 60, (102,59,40), (57,49,44), (176,116,60))
    draw.polygon([(210,710), (270,710), (360,H), (120,H)], fill=(176,137,95))


def hangzhou(draw, variant):
    horizon = 500
    draw.rectangle((0, horizon, W, H), fill=(69,135,139))
    draw.polygon([(0,470), (70,420), (140,455), (210,400), (300,458), (390,410), (W,460), (W,horizon), (0,horizon)], fill=(68,111,96))
    for index in range(13):
        y = horizon + 25 + index * 22
        draw.arc((40,y-5,W-40,y+12), 0, 180, fill=(156,206,194), width=2)
    center = 355
    draw.rectangle((center-9,330,center+9,510), fill=(74,68,55))
    for y, width in [(360,78), (395,65), (430,53), (463,42)]:
        draw.polygon([(center-width//2,y), (center+width//2,y), (center,y-22)], fill=(66,73,60))
    for x, y, size in [(70,670,24), (150,750,20), (270,690,23), (385,775,18)]:
        draw.ellipse((x-size,y-size//2,x+size,y+size//2), fill=(55,123,87))


def chengdu(draw, variant):
    draw.polygon([(0,310), (165,420), (185,H), (0,H)], fill=(117,96,67))
    draw.polygon([(W,320), (315,430), (290,H), (W,H)], fill=(97,82,62))
    draw.polygon([(165,420), (315,430), (360,H), (120,H)], fill=(167,142,101))
    for x, y in [(110,430), (360,455), (78,520), (398,560)]:
        draw.line((x,y-20,x,y), fill=(50,35,25), width=2)
        draw.ellipse((x-10,y,x+10,y+24), fill=(175,55,40))
    random.seed(variant)
    for x in [25,45,430,452]:
        draw.line((x,100,x+random.randint(-10,10),560), fill=(61,96,56), width=7)
        for y in range(160,500,70):
            draw.ellipse((x-30,y,x+5,y+14), fill=(66,115,61))


def nanjing(draw, variant):
    horizon = 510
    draw.rectangle((0,horizon,W,H), fill=(78,102,123))
    for index in range(12):
        y = horizon + 18 + index * 25
        draw.line((20,y,W-20,y), fill=(145,168,179), width=2)
    for x in range(0,W,80):
        draw.rectangle((x,horizon-85,x+70,horizon), fill=(217,205,177))
        draw.polygon([(x-6,horizon-85), (x+76,horizon-85), (x+58,horizon-120), (x+12,horizon-120)], fill=(58,57,52))
    draw.arc((75,510,405,730), 180, 360, fill=(180,162,130), width=28)
    draw.arc((145,560,335,720), 180, 360, fill=(76,96,111), width=35)


def guangzhou(draw, variant):
    draw.rectangle((50,470,430,720), fill=(211,193,150))
    draw.polygon([(30,490), (450,490), (410,430), (70,430)], fill=(60,83,77))
    draw.polygon([(70,430), (410,430), (365,375), (115,375)], fill=(68,91,83))
    for x in range(120,370,35):
        draw.ellipse((x-5,360,x+5,375), fill=(180,132,62))
    for x in [115,190,265,340]:
        draw.rectangle((x,555,x+45,720), fill=(91,54,43))
    draw.polygon([(0,720), (W,700), (W,H), (0,H)], fill=(174,160,130))


RENDERERS = {
    'beijing-forbidden-city': beijing,
    'shanghai-bund': shanghai,
    'xian-city-wall': xian,
    'hangzhou-west-lake': hangzhou,
    'chengdu-kuanzhai-alley': chengdu,
    'nanjing-qinhuai-river': nanjing,
    'guangzhou-chen-clan': guangzhou,
}

for journey_id, journey_palettes in PALETTES.items():
    for variant, (first, second) in enumerate(journey_palettes, 1):
        image = Image.new('RGB', (W, H))
        gradient(image, first, second)
        draw = ImageDraw.Draw(image)
        draw.ellipse((60,95,120,155), fill=(255,231,173) if variant < 3 else (225,223,204))
        RENDERERS[journey_id](draw, variant)
        veil = Image.new('RGBA', (W,H), (0,0,0,0))
        veil_draw = ImageDraw.Draw(veil)
        for y in range(560, H):
            veil_draw.line((0,y,W,y), fill=(30,22,20,int(90*(y-560)/(H-560))))
        image = Image.alpha_composite(image.convert('RGBA'), veil).convert('RGB')
        image.save(OUT / f'{journey_id}-v{variant}.webp', 'WEBP', quality=76, method=6)

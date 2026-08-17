from pathlib import Path

p = Path('app/lib/data/lijiang_old_town_gold_content.dart')
text = p.read_text()
replacements = {
    "清末黄昏，四方街刚散市。虚构商贩和清与姐姐和素守着一驮茶叶；明早买家离城，这笔钱要还两人共同的债。":
        "清末黄昏，四方街刚散市。商贩和清与姐姐和素守着一驮茶叶；明早买家离城，这笔钱要还两人共同的债。",
    "Một buổi chiều cuối thời Thanh, chợ ở Tứ Phương vừa tan. Người buôn hư cấu Hòa Thanh và chị gái Hòa Tố trông một chuyến trà; sáng mai người mua rời thành và số tiền này phải trả món nợ chung của hai chị em.":
        "Một buổi chiều cuối thời Thanh, chợ ở Tứ Phương vừa tan. Người buôn Hòa Thanh và chị gái Hòa Tố trông một chuyến trà; sáng mai người mua rời thành và số tiền này phải trả món nợ chung của hai chị em.",
    "At dusk in the late Qing, the market at Sifang Street has just dispersed. The fictional trader He Qing and his older sister He Su guard a mule-load of tea; the buyer leaves in the morning, and the sale must pay their shared debt.":
        "At dusk in the late Qing, the market at Sifang Street has just dispersed. The trader He Qing and his older sister He Su guard a mule-load of tea; the buyer leaves in the morning, and the sale must pay their shared debt.",
    "Thương nhân từ nhiều hướng tụ về Tứ Phương; người mua của hai chị em chỉ là một đoàn trong số đó. Với họ, giao dịch sáng mai không phải phông nền lịch sử mà là cơ hội thực sự để trả nợ.":
        "Chiều đó, Hòa Thanh tận mắt thấy vài đoàn ngựa, la chen vào phố Tứ Phương từ các ngõ khác nhau. Chị cậu phải kiễng chân tìm ba lần mới nhận ra người đã hẹn sáng mai tới nhận trà.",
    "Traders arriving from different directions gather at Sifang Street; the siblings’ buyer is only one group among them. For the pair, tomorrow’s sale is not historical scenery but their immediate chance to clear debt.":
        "That afternoon, He Qing watches several caravans squeeze into Sifang Street from different lane mouths. His sister rises on tiptoe three times before recognizing the buyer due to collect the tea the next morning.",
    "Kênh nước chạy sát các phố ngõ và nhiều cầu bắc thẳng qua dòng nước. Ngày thường chúng kéo buôn bán và đời sống lại gần nhau; khi có cháy, nguồn nước cũng ở rất gần nhà gỗ.":
        "Hòa Thanh cúi xuống thấy ánh nước ngay dưới cầu. Những nhà gần đám cháy nhất đã kéo xô gỗ ra đầu ngõ, nhưng chuyến trà nằm ngang trên cầu chặn lối.",
    "Canals run beside the lanes and many bridges cross the water directly. In ordinary life they pull trade and homes close together; during fire they also put water close to timber houses.":
        "He Qing looks down and sees the water glint beneath the bridge. The households nearest the fire have dragged wooden buckets to the lane mouth, but the tea load lying across the bridge blocks them.",
    "Hai chị em chuyển phần trà chưa ngấm nước vào sát tường, không ai nhắc người mua sáng mai. Món nợ chung từ cuộc cãi vã xem ai quyết định trở thành thiệt hại cả hai đều phải gánh.":
        "Hai chị em chuyển số trà chưa ngấm nước vào sát tường. Hòa Tố đếm đến bao thứ năm thì dừng lại và đẩy bao còn bán được vào khoảng giữa hai người.",
    "The siblings move the dry sacks to the wall and neither mentions the morning buyer. Their shared debt changes from an argument over who gets to decide into a loss both must carry.":
        "The siblings move the dry tea against the wall. He Su pauses at the fifth sack and pushes the one still saleable into the space between them.",
}
for old, new in replacements.items():
    if old not in text:
        raise SystemExit(f'missing alignment marker: {old[:70]}')
    text = text.replace(old, new, 1)
p.write_text(text)

p = Path('app/test/lijiang_old_town_gold_test.dart')
text = p.read_text()
old = "expect(story, contains('虚构商贩和清'));"
new = "expect(story, contains('商贩和清'));"
if old not in text:
    raise SystemExit('test marker missing')
p.write_text(text.replace(old, new, 1))

from __future__ import annotations

import json
import os
import re
from pathlib import Path

BASE_SHA = os.environ["BASE_SHA"]
ROOT = Path.cwd()


def dart_string(value: str) -> str:
    # JSON double-quoted strings are valid Dart string literals for this content.
    return json.dumps(value, ensure_ascii=False)


def find_statement_end(text: str, start: int) -> int:
    paren = bracket = brace = 0
    quote = None
    escaped = False
    for index in range(start, len(text)):
        ch = text[index]
        if quote is not None:
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == quote:
                quote = None
            continue
        if ch in ("'", '"'):
            quote = ch
            continue
        if ch == "(":
            paren += 1
        elif ch == ")":
            paren -= 1
        elif ch == "[":
            bracket += 1
        elif ch == "]":
            bracket -= 1
        elif ch == "{":
            brace += 1
        elif ch == "}":
            brace -= 1
        elif ch == ";" and paren == bracket == brace == 0:
            return index + 1
    raise AssertionError("statement end not found")


def find_matching(text: str, start: int, opener: str, closer: str) -> int:
    assert text[start] == opener
    depth = 0
    quote = None
    escaped = False
    for index in range(start, len(text)):
        ch = text[index]
        if quote is not None:
            if escaped:
                escaped = False
            elif ch == "\\":
                escaped = True
            elif ch == quote:
                quote = None
            continue
        if ch in ("'", '"'):
            quote = ch
            continue
        if ch == opener:
            depth += 1
        elif ch == closer:
            depth -= 1
            if depth == 0:
                return index
    raise AssertionError(f"matching {closer} not found")


def declaration_start(text: str, name: str) -> int:
    match = re.search(rf"^(?:const|final)\s+{re.escape(name)}\b", text, re.M)
    if not match:
        raise AssertionError(f"declaration not found: {name}")
    return match.start()


def list_close(text: str, name: str) -> int:
    start = declaration_start(text, name)
    equals = text.find("=", start)
    opening = text.find("[", equals)
    if opening < 0:
        raise AssertionError(f"list opening not found: {name}")
    return find_matching(text, opening, "[", "]")


def replace_named_statement(text: str, declaration_regex: str, replacement: str) -> str:
    match = re.search(declaration_regex, text, re.M)
    if not match:
        raise AssertionError(f"statement not found: {declaration_regex}")
    start = match.start()
    end = find_statement_end(text, start)
    return text[:start] + replacement + text[end:]


def extract_story_levels(text: str) -> list[list[str]]:
    start = declaration_start(text, "shanghaiBundOnePassLevels")
    opening = text.find("[", text.find("=", start))
    closing = find_matching(text, opening, "[", "]")
    section = text[opening:closing + 1]
    calls = re.findall(r"_bundLevel\(\[(.*?)\]\)", section, re.S)
    assert len(calls) == 10, f"expected 10 Story levels, got {len(calls)}"
    levels: list[list[str]] = []
    for call in calls:
        strings = re.findall(r"'((?:\\.|[^'])*)'", call)
        levels.append(strings)
    assert [len(v) for v in levels] == [1, 1, 2, 2, 2, 2, 2, 2, 2, 2]
    return levels


paragraph_translations = {
    1: [
        (
            "Lâm Ngạn 24 tuổi, lớn lên ở Ngoại Than và thường giúp gia đình sắp xếp chứng từ vận tải, khai báo hải quan. Tối nay anh chuẩn bị sang Lục Gia Chủy cho công việc mới ngày mai. Mẹ đợi gần Tòa nhà Hải quan, mang theo bản sao vận đơn đường biển cũ của ông ngoại. Anh nói qua Hoàng Phố là rời Thượng Hải cũ để bước vào Thượng Hải mới. Mẹ không giữ anh lại, chỉ đưa vận đơn. Hai người đi về phía nam dọc bờ sông. Đến bến phà đường Đông Kim Lăng, anh từng muốn trả tờ giấy nhưng cuối cùng vẫn cất vào túi. Khi phà rời bờ tây, Ngoại Than lùi xa và các tòa nhà Lục Gia Chủy tiến gần. Anh chợt thấy con sông không chia Thượng Hải thành quá khứ và tương lai; lên bờ đông, anh tiếp tục đi tới công việc mới cùng tờ chứng từ cũ.",
            "Lin An is twenty-four, grew up on the Bund, and often helped his family sort freight and customs documents. Tonight he is preparing to cross to Lujiazui for a new job the next day. His mother waits near the Customs House with a copy of an old maritime bill of lading left by his maternal grandfather. Lin says crossing the Huangpu will mean leaving old Shanghai and entering new Shanghai. His mother does not ask him to stay; she simply hands him the bill. They walk south along the river. At the East Jinling Road ferry, he briefly wants to return the document but finally puts it in his bag. As the ferry leaves the west bank, the Bund recedes and Lujiazui draws nearer. He suddenly feels that the river does not divide Shanghai into past and future; after landing on the east bank, he continues toward his new work with the old document still with him.",
        )
    ],
    2: [
        (
            "Lâm Ngạn 24 tuổi, quen thuộc việc giao nhận và khai báo hải quan của gia đình. Ngày mai anh sẽ vào đội thanh toán của một công ty công nghệ tài chính ở Lục Gia Chủy. Tối nay anh gặp mẹ ở Ngoại Than, gần Tòa nhà Hải quan; bà mang theo bản sao vận đơn đường biển cũ của ông ngoại. Anh đùa rằng cuối cùng mình cũng qua sông, như đi từ Thượng Hải cũ sang Thượng Hải mới. Mẹ chỉ hỏi anh có muốn mang tờ vận đơn đi không. Họ đi về phía nam dọc bờ tây Hoàng Phố, giữa các tòa nhà lịch sử, ánh đèn tàu và Lục Gia Chủy sáng lên ở bờ đông. Anh nhiều lần muốn trả tờ giấy, nhưng tại bến phà đường Đông Kim Lăng vẫn cất nó vào túi. Khi phà rời bờ, anh hiểu rằng con sông không chia thành phố thành quá khứ và tương lai: người, hàng hóa, thông tin và tiền vẫn đổi cách thức để lưu chuyển giữa hai bờ. Anh không đổi lựa chọn nghề nghiệp, nhưng mang tờ chứng từ cũ tiếp tục đi Lục Gia Chủy.",
            "Lin An, twenty-four, knows his family freight-forwarding and customs business well. The next day he will join a fintech settlement team in Lujiazui. That evening he meets his mother on the Bund near the Customs House; she brings a copy of an old maritime bill of lading left by his maternal grandfather. He jokes that he is finally crossing the river, as if moving from old Shanghai into new Shanghai. His mother only asks whether he wants to take the bill with him. They walk south along the west bank of the Huangpu, with historic Bund buildings behind them, vessel lights on the river, and Lujiazui lit across the water. He repeatedly considers returning the old paper, yet at the East Jinling Road ferry he puts it in his bag. Once the ferry leaves, he understands that the river does not divide the city into past and future: people, goods, information, and money keep moving between the banks through changing means. He keeps his new career choice and carries the old document toward Lujiazui.",
        )
    ],
    3: [
        (
            "Lâm Ngạn 24 tuổi, từ nhỏ đã quen với việc giao nhận và tờ khai hải quan của gia đình. Ngày mai anh sẽ làm trong đội thanh toán của một công ty công nghệ tài chính ở Lục Gia Chủy. Chiều tối, anh gặp mẹ ở Ngoại Than gần Tòa nhà Hải quan. Bà đưa anh bản sao vận đơn đường biển cũ của ông ngoại. Nhìn sang bờ đối diện, anh nói qua Hoàng Phố là rời Thượng Hải cũ để bước vào Thượng Hải mới. Mẹ không giữ anh lại, chỉ hỏi anh có muốn mang vận đơn đi không. Hai người đi về phía nam, ánh đèn các công trình lịch sử phản xuống mặt nước và tàu thuyền đi qua trước mắt.",
            "Lin An is twenty-four and has known his family freight-forwarding and customs paperwork since childhood. The next day he will join a fintech settlement team in Lujiazui. At dusk he first meets his mother on the Bund near the Customs House. She hands him a copy of an old maritime bill of lading left by his maternal grandfather. Looking across the river, he says that crossing the Huangpu means leaving old Shanghai and entering new Shanghai. His mother does not ask him to stay; she only asks whether he wants to take the bill. They walk south as lights from the historic buildings fall across the water and vessels pass in front of them.",
        ),
        (
            "Trước khi đến bến phà đường Đông Kim Lăng, Lâm Ngạn nhiều lần muốn trả vận đơn cho mẹ. Bà chỉ nhắc chuyện hồi nhỏ anh từng gấp thuyền giấy bằng tờ khai hải quan bỏ đi. Trước khi lên phà, anh vẫn cất vận đơn vào túi. Khi phà rời bờ tây, Ngoại Than lùi xa và Lục Gia Chủy tiến gần. Anh nhận ra con sông không chia Thượng Hải thành quá khứ và tương lai; hàng hóa, giấy tờ, tín dụng, thông tin và vốn chỉ đổi công cụ để tiếp tục lưu chuyển. Sang bờ đông, anh không quay về tiếp quản việc nhà cũng không từ bỏ công việc mới, mà mang tờ chứng từ bình thường ấy tiếp tục tới Lục Gia Chủy.",
            "Before reaching the East Jinling Road ferry, Lin An repeatedly wants to return the bill to his mother. She only recalls how he used discarded customs forms to fold paper boats as a child. Before boarding, he still puts the bill in his bag. As the ferry leaves the west bank, the Bund recedes and Lujiazui approaches. He realizes that the river does not divide Shanghai into past and future; goods, documents, credit, information, and capital simply change tools as they continue to move. On the east bank, he neither returns to take over the family business nor abandons his new job. He carries the ordinary old document onward to Lujiazui.",
        ),
    ],
    4: [
        (
            "Lâm Ngạn 24 tuổi, gia đình nhiều năm làm giao nhận và chứng từ hải quan. Ngày mai anh sẽ trình diện tại đội thanh toán của một công ty công nghệ tài chính ở Lục Gia Chủy. Anh xem công việc này là một bước ngoặt dứt khoát: từ tàu, hàng hóa và giấy tờ sang tài khoản và thanh toán số. Chiều tối anh gặp mẹ gần Tòa nhà Hải quan ở Ngoại Than. Bà vừa xong một ngày làm chứng từ và đưa anh bản sao vận đơn đường biển cũ của ông ngoại, chỉ là một giấy tờ thương mại bình thường. Nhìn sang bờ bên kia, anh nói mình cuối cùng cũng sắp rời Thượng Hải cũ để bước vào Thượng Hải mới. Mẹ không phản đối, chỉ hỏi có mang tờ giấy theo không. Khi họ đi về phía nam, các tòa nhà lịch sử, đèn tàu và cao ốc bờ đông cùng xuất hiện trong tầm mắt.",
            "Lin An is twenty-four, and his family has worked for years with freight forwarding and customs documents. The next day he will report to a fintech settlement team in Lujiazui. He imagines the job as a complete turn: from ships, cargo, and paper into accounts and digital settlement. At dusk he meets his mother near the Bund Customs House. She has just finished a day of document work and gives him a copy of an old maritime bill of lading left by his maternal grandfather, an ordinary commercial document. Looking across the Huangpu, he says he is finally about to leave old Shanghai and enter new Shanghai. His mother does not object; she simply asks whether he wants to take the paper. As they walk south, historic Bund buildings, vessel lights, and towers on the east bank share the same view.",
        ),
        (
            "Gần bến phà đường Đông Kim Lăng, Lâm Ngạn liên tục chạm vào vận đơn trong túi và cho rằng hệ thống của công ty mới chẳng liên quan gì đến tờ giấy cũ. Mẹ không giảng lịch sử, chỉ cười nhắc chuyện anh từng gấp thuyền bằng tờ khai hải quan bỏ đi. Trước cửa soát vé, anh cất vận đơn vào túi máy tính và lên phà một mình. Tòa nhà Hải quan và ánh đèn Ngoại Than nhỏ dần, tàu hàng vẫn chạy trên sông và đường chân trời Phố Đông dâng lên trước mặt. Anh hiểu con sông không chia Thượng Hải thành quá khứ và tương lai: giấy tờ cũ ghi hàng hóa, tín dụng và trách nhiệm thanh toán, còn hệ thống mới xử lý dữ liệu và thanh toán nhanh hơn, nhưng cả hai đều tổ chức sự lưu chuyển. Sang bờ đông, anh vẫn chọn nghề mới nhưng không còn xem tờ chứng từ cũ là quá khứ bắt buộc phải bỏ lại.",
            "Near the East Jinling Road ferry, Lin An keeps touching the bill in his bag and thinks the new company’s system has nothing to do with the old paper. His mother gives no history lecture; she only laughs about how he folded discarded customs forms into paper boats as a child. Before the ticket gate, he puts the bill into his computer bag and boards alone. The Customs House and Bund lights shrink behind him, cargo vessels continue along the river, and the Pudong skyline rises ahead. He understands that the river does not divide Shanghai into past and future: old documents record goods, credit, and payment responsibilities, while new systems process faster data and settlement, but both organize flows. On the east bank he still chooses the new career, yet no longer treats the old document as a past that must be discarded.",
        ),
    ],
    5: [
        (
            "Lâm Ngạn 24 tuổi, lớn lên trong một gia đình gắn với thương mại cảng Thượng Hải. Việc giao nhận của gia đình nhỏ nhưng bàn làm việc luôn có tài liệu đặt chỗ, khai báo hải quan, bản sao vận đơn và chứng từ thanh toán. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy. Anh coi đó là một đường cắt sạch: bờ tây thuộc về tàu, hải quan và giấy tờ; bờ đông thuộc về dữ liệu, tài khoản và hạ tầng tài chính mới. Chiều tối anh gặp mẹ gần Tòa nhà Hải quan. Bà đưa anh bản sao vận đơn cũ của ông ngoại, không phải đồ cổ mà chỉ ghi việc vận chuyển, giao hàng và trách nhiệm của một lô hàng bình thường. Anh nói qua sông là rời Thượng Hải cũ. Mẹ chỉ hỏi: Vậy tờ giấy này thì sao? Khi họ đi về phía nam, công trình lịch sử, đèn tàu và cao ốc Lục Gia Chủy cùng sáng lên.",
            "Lin An is twenty-four and grew up in a family connected to Shanghai port trade. The family freight business is small, but booking records, customs documents, bill-of-lading copies, and settlement vouchers often cover the desk. The next day he will join a fintech settlement team in Lujiazui. He imagines a clean cut: the west bank belongs to ships, customs, and paper; the east bank to data, accounts, and new financial infrastructure. At dusk he meets his mother near the Bund Customs House. She gives him an old bill-of-lading copy left by his maternal grandfather, not an antique but a record of carriage, delivery, and responsibility for an ordinary shipment. He says crossing the river will mean leaving old Shanghai. His mother only asks what that means for the paper. As they walk south, historic buildings, vessel lights, and Lujiazui towers all light up together.",
        ),
        (
            "Trước bến phà đường Đông Kim Lăng, Lâm Ngạn nhiều lần muốn trả vận đơn vì nghĩ thanh toán số không liên quan tới tờ giấy. Mẹ không bảo anh nối nghiệp, chỉ kể chuyện anh từng gấp thuyền bằng tờ khai hải quan bỏ đi. Ở cửa soát vé họ chia tay; anh cất vận đơn vào túi máy tính và lên phà một mình. Ngoại Than và tháp đồng hồ Hải quan lùi lại, tàu hàng chạy theo luồng chính và đường chân trời Phố Đông tiến gần. Trong vài phút nhìn thấy hai bờ cùng lúc, anh nhận ra sông không chia thành phố thành quá khứ và tương lai. Hàng hóa, giấy tờ, tín dụng, thông tin, thanh toán và vốn không đứng yên ở một bờ; chỉ vật mang chúng thay đổi. Đến phía Đông Xương, anh tiếp tục tới Lục Gia Chủy, vẫn chọn nghề mới nhưng mang tờ chứng từ cũ sang cùng mình.",
            "Before the East Jinling Road ferry, Lin An repeatedly considers returning the bill because he thinks digital settlement has nothing to do with the paper. His mother does not ask him to inherit the business; she only recalls his childhood paper boats made from discarded customs forms. They part at the gate, and he puts the bill in his computer bag before boarding alone. The Bund and Customs House clock tower fall behind, cargo ships move along the main channel, and the Pudong skyline approaches. During the few minutes when both banks are visible together, he realizes that the river does not divide the city into past and future. Goods, documents, credit, information, settlement, and capital do not stay on one bank; their carriers keep changing. Reaching the Dongchang Road side, he continues toward Lujiazui, still choosing the new career but carrying the old document across.",
        ),
    ],
    6: [
        (
            "Lâm Ngạn 24 tuổi, lớn lên trong gia đình gắn với thương mại cảng Thượng Hải. Cha mẹ làm giao nhận và chứng từ; anh quen nhìn xác nhận đặt chỗ, hồ sơ khai quan, bản sao vận đơn và chứng từ thanh toán. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy, tham gia thanh toán và giao nhận vốn giữa các tổ chức nhanh hơn. Anh xem đó là một sự cắt đứt: bờ tây để lại tàu, hải quan và giấy tờ; bờ đông thuộc về dữ liệu, tài khoản và hạ tầng tài chính mới. Chiều tối anh gặp mẹ gần Tòa nhà Hải quan. Bà đưa bản sao vận đơn cũ của ông ngoại, chỉ ghi việc vận chuyển, giao hàng và trách nhiệm của một lô hàng bình thường. Anh nói ngày mai sẽ đi từ Thượng Hải cũ sang Thượng Hải mới. Mẹ hỏi liệu đổi công cụ có nhất thiết phải bỏ lại những thứ trước kia ở bờ này không. Họ đi về phía nam, giữa công trình lịch sử, tiếng chuông, đèn tàu và mặt kính Phố Đông trong hoàng hôn.",
            "Lin An is twenty-four and grew up in a family tied to Shanghai port trade. His parents handle freight forwarding and trade documents, so he has long seen booking confirmations, customs materials, bill-of-lading copies, and settlement vouchers. The next day he will join a fintech settlement team in Lujiazui working on faster inter-institutional payments and fund settlement. He imagines a break: ships, customs, and paper remain on the west bank, while data, accounts, and new financial infrastructure belong to the east. At dusk he meets his mother near the Bund Customs House. She gives him an old bill-of-lading copy from his maternal grandfather, recording only the carriage, delivery, and responsibility for an ordinary shipment. He says tomorrow he will move from old Shanghai into new Shanghai. His mother asks whether changing tools really means leaving everything earlier on this bank. They walk south among historic buildings, clock sounds, vessel lights, and Pudong glass facades in the dusk.",
        ),
        (
            "Khi gần bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ rằng việc Thượng Hải mở cảng năm 1843 diễn ra trong hệ thống điều ước bất bình đẳng thế kỷ XIX; các chức năng thương mại, vận tải biển, hải quan, ngân hàng và kinh doanh ở Ngoại Than hình thành qua một quá trình dài, không phải trong một đêm. Nhưng với anh, kiến thức ấy vẫn chỉ là bối cảnh. Vận đơn cũ chạm vào cạnh máy tính trong túi; anh nhiều lần muốn trả lại. Mẹ không giảng sử, chỉ nhắc chuyện anh từng gấp thuyền bằng tờ khai bỏ đi. Họ chia tay ở cửa soát vé và anh mang vận đơn lên phà. Khi Ngoại Than và Tòa nhà Hải quan lùi xa, tàu hàng vẫn chuyển động và đường chân trời Phố Đông dâng lên. Anh nhận ra con sông không chia Thượng Hải thành quá khứ và tương lai: vận đơn viết hàng hóa, tín dụng, trách nhiệm và thanh toán trên giấy, còn hệ thống mới biến quan hệ đó thành dữ liệu và chỉ thị thời gian thực. Sang bờ đông, anh tiếp tục tới Lục Gia Chủy; công việc cũ ở lại nhưng tờ chứng từ cũ đi cùng anh.",
            "Near the East Jinling Road ferry, Lin An remembers that Shanghai’s 1843 treaty-port opening occurred within the nineteenth-century unequal-treaty system, and that trade, shipping, customs, banking, and commercial functions on the Bund developed over a long period rather than overnight. Yet he has treated that knowledge as background. The old bill touches the edge of his computer in the bag, and he repeatedly considers returning it. His mother does not lecture him on history; she only mentions his childhood paper boats made from discarded customs forms. They part at the gate and he takes the bill onto the ferry. As the Bund and Customs House fall behind, cargo ships keep moving and the Pudong skyline rises. He realizes that the river does not divide Shanghai into past and future: the old bill records goods, credit, responsibility, and payment on paper, while the new system turns those relationships into data and real-time instructions. On the east bank he continues to Lujiazui; the old work remains behind, but the old document has crossed with him.",
        ),
    ],
    7: [
        (
            "Lâm Ngạn 24 tuổi, lớn lên trong gia đình gắn với thương mại cảng Thượng Hải. Văn phòng giao nhận và chứng từ của cha mẹ không có huyền thoại, chỉ có xác nhận đặt chỗ, hồ sơ khai quan, bản sao vận đơn và những con số thanh toán phải kiểm tra nhiều lần. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy, tham gia thanh toán và giao nhận vốn giữa các tổ chức. Anh thích sự tức thời, rõ ràng và gần như không giấy tờ ấy, nên xem đó là đoạn tuyệt với ngành cũ của gia đình: bờ tây là tàu, hải quan và chứng từ giấy; bờ đông là dữ liệu, tài khoản và hạ tầng tài chính mới. Chiều tối, mẹ đưa anh bản sao vận đơn cũ của ông ngoại gần Tòa nhà Hải quan. Anh nói qua sông là rời Thượng Hải cũ để vào Thượng Hải mới. Mẹ hỏi anh có thật tin một con sông có thể chia cắt rạch ròi như vậy không. Họ đi về phía nam, với kiến trúc lịch sử, tiếng chuông Hải quan, đèn tàu và mặt kính bờ đông chồng lên nhau trong hoàng hôn.",
            "Lin An is twenty-four and grew up in a family tied to Shanghai port trade. His parents’ freight-forwarding and document office has no legends, only booking confirmations, customs materials, bill copies, and settlement figures checked again and again. The next day he will join a fintech settlement team in Lujiazui for inter-institutional payments and fund settlement. He likes its immediate, clear, nearly paperless method and treats it as a break with the family’s old industry: the west bank is ships, customs, and paper credentials; the east bank is data, accounts, and new financial infrastructure. At dusk near the Customs House, his mother gives him an old bill-of-lading copy from his maternal grandfather. He says crossing the river will mean leaving old Shanghai for new Shanghai. His mother asks whether he truly thinks one river can divide things so cleanly. They walk south as historic architecture, the Customs House clock, vessel lights, and glass facades across the river overlap in the dusk.",
        ),
        (
            "Trên đường tới bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ việc mở cảng năm 1843 nằm trong hệ thống điều ước bất bình đẳng thế kỷ XIX, và các chức năng thương mại, vận tải, hải quan, ngân hàng, kinh doanh hình thành qua nhiều thập kỷ chứ không bỗng xuất hiện trong một đêm. Anh hiểu điều đó nhưng vẫn xem là chuyện quá khứ. Vận đơn chạm cạnh máy tính và anh nhiều lần muốn trả lại. Mẹ không lên lớp, chỉ nhắc chuyện thuyền giấy bằng tờ khai bỏ đi. Hai người chia tay ở cửa soát vé; anh cất vận đơn vào túi máy tính và lên phà. Ngoại Than và tháp đồng hồ Hải quan lùi lại, tàu hàng đi theo luồng chính, Lục Gia Chủy cao dần phía trước. Khoảng cách trên sông khiến hai bờ cùng rõ hơn. Anh hiểu giấy tờ cũ viết hàng hóa, tín dụng, trách nhiệm và thanh toán trên giấy, hệ thống mới biến các quan hệ đó thành dữ liệu, thông điệp và thanh toán thời gian thực; hình thức đổi nhưng thành phố vẫn tổ chức lại dòng người, hàng hóa, thông tin và vốn. Sang bờ đông, anh không cần phủ định một bờ mới có thể đi tới bờ kia.",
            "Walking toward the East Jinling Road ferry, Lin An recalls that the 1843 treaty-port opening occurred within the nineteenth-century unequal-treaty system and that trade, shipping, customs, banking, and commercial functions developed over decades rather than appearing overnight. He knows this but has still treated it as belonging only to the past. The bill touches the edge of his computer and he repeatedly wants to return it. His mother gives no lecture, only the paper-boat memory. They part at the gate; he slips the bill into the computer compartment and boards. The Bund and Customs House clock tower recede, cargo ships follow the main channel, and Lujiazui rises ahead. Distance makes both banks clearer at once. He sees that old documents put goods, credit, responsibility, and payment on paper, while the new system turns those relationships into data, messages, and real-time settlement; forms change, but the city still reorganizes flows of people, goods, information, and capital. On the east bank, he no longer needs to deny one side in order to move toward the other.",
        ),
    ],
    8: [
        (
            "Lâm Ngạn 24 tuổi, lớn lên trong gia đình gắn với thương mại cảng Thượng Hải. Công việc giao nhận và chứng từ của cha mẹ rất đời thường: đổi lịch tàu, kiểm tra hồ sơ khai quan, đuổi theo bản sao vận đơn, xác nhận cước và điều kiện thanh toán. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy. Với anh, công việc mới tượng trưng cho tốc độ, tự động hóa và một cuộc sống không còn bị giấy tờ kéo chậm. Anh thậm chí chia hai bờ thành hai thời đại: bờ tây giữ tàu, hải quan, nhà ngân hàng cũ và tủ hồ sơ của cha mẹ; bờ đông đại diện dữ liệu, tài khoản và hạ tầng tài chính mới. Chiều tối gần Tòa nhà Hải quan, mẹ đưa anh bản sao vận đơn cũ đã ngả vàng của ông ngoại, chỉ ghi một lô hàng bình thường. Anh nói ngày mai mình sẽ rời Thượng Hải cũ để vào Thượng Hải mới. Mẹ hỏi anh đổi công việc hay muốn bỏ cả nguồn gốc ở bờ này. Họ đi về phía nam giữa kiến trúc Ngoại Than, tiếng chuông Hải quan, tàu thuyền và mặt kính bờ đông.",
            "Lin An is twenty-four and grew up in a family tied to Shanghai port trade. His parents’ freight and document work is thoroughly ordinary: changing sailing dates, checking customs materials, chasing bill copies, and confirming freight and settlement terms. The next day he will join a fintech settlement team in Lujiazui. To him, the job means speed, automation, and a life no longer slowed by paper. He even divides the banks into two eras: the west bank keeps ships, customs, old bank buildings, and his parents’ filing cabinets; the east represents data, accounts, and new financial infrastructure. At dusk near the Customs House, his mother gives him a yellowing old bill copy from his maternal grandfather, recording nothing secret, only an ordinary shipment. He says tomorrow he will leave old Shanghai and enter new Shanghai. His mother asks whether he is changing jobs or trying to leave his own origins on this bank. They walk south among Bund architecture, the Customs House clock, river traffic, and glass facades across the water.",
        ),
        (
            "Gần bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ việc mở cảng năm 1843 diễn ra trong hệ thống điều ước bất bình đẳng; sau đó các cơ quan thương mại, vận tải, hải quan, ngân hàng và kinh doanh ở bờ tây Hoàng Phố trải qua quá trình tập trung và biến đổi lâu dài, không phải một đường thẳng có thể xóa bằng ba chữ hiện đại hóa. Anh nhiều lần định trả vận đơn. Mẹ không giảng sử, chỉ cười nhắc chuyện anh từng gấp thuyền bằng tờ khai bỏ đi. Họ chia tay ở cửa soát vé, và anh mang tờ giấy lên phà. Khi bờ sáng của Ngoại Than lùi lại và đường chân trời Phố Đông dâng lên, khoảng cách mặt nước cho anh thấy hai bờ cùng lúc. Anh hiểu con sông không chia thành phố thành quá khứ và tương lai: vận đơn giấy ghi hàng hóa, tín dụng, trách nhiệm và thanh toán; hệ thống mới dùng dữ liệu, thông điệp và chỉ thị thời gian thực. Công cụ và tốc độ đổi, nhưng thành phố vẫn sắp xếp lại cách người, hàng, thông tin và vốn đến với nhau. Tới phía Đông Xương, anh vẫn rời công việc cũ và mong đợi nghề mới, chỉ không còn xem bờ tây là nền cũ phải xóa.",
            "Near the East Jinling Road ferry, Lin An recalls that the 1843 opening occurred within the unequal-treaty system and that trade, shipping, customs, banking, and commercial institutions on the west bank of the Huangpu went through long processes of concentration and change, not a straight line that can be flattened into the word modernization. He repeatedly prepares to return the old bill. His mother gives no history lesson; she only laughs about the paper boats he folded from discarded customs forms. They part at the gate and he takes the document onto the ferry. As the bright Bund shoreline recedes and the Pudong skyline rises, the water lets him see both banks at once. He realizes that the river does not divide the city into past and future: paper bills record goods, credit, responsibility, and payment, while new systems use data, messages, and real-time instructions. Tools and speed change, but the city still reorganizes how people, goods, information, and capital reach one another. At Dongchang Road, he still leaves the family’s old work and looks forward to the new career, but no longer treats the west bank as a background that must be erased.",
        ),
    ],
    9: [
        (
            "Lâm Ngạn 24 tuổi, lớn lên trong gia đình gắn với thương mại cảng Thượng Hải. Cha mẹ làm giao nhận và chứng từ, hằng ngày đổi lịch tàu, kiểm tra hồ sơ khai quan, đuổi theo bản sao vận đơn, xác nhận cước và điều kiện thanh toán. Khi nhỏ anh chỉ thấy giấy tờ chiếm bàn ăn; lớn lên anh chọn con đường khác. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy, tham gia hệ thống thanh toán và giao nhận vốn giữa các tổ chức. Kết nối tài khoản tự động khiến anh tin mình cuối cùng thoát khỏi sự chậm chạp của giấy tờ và cảng. Anh chia hai bờ thành hai thời đại: bờ tây là tàu, hải quan, nhà ngân hàng cũ và tủ hồ sơ; bờ đông là dữ liệu, thuật toán, thanh toán thời gian thực và hạ tầng tài chính mới. Chiều tối, mẹ đưa anh bản sao vận đơn cũ của ông ngoại gần Tòa nhà Hải quan. Tờ giấy không có giá trị sưu tầm, chỉ ghi một lô hàng bình thường. Anh nói ngày mai mình sẽ rời Thượng Hải cũ. Mẹ không bảo anh nối nghiệp, chỉ hỏi anh đổi công việc hay định để cả nguồn gốc lại ở bờ này. Họ đi về phía nam, để Hoàng Phố cùng lúc thu kiến trúc lịch sử, tiếng chuông Hải quan, tàu thuyền và mặt kính Phố Đông vào hoàng hôn.",
            "Lin An is twenty-four and grew up in a family connected to Shanghai port trade. His parents’ freight and document work means changing sailing dates, checking customs files, chasing bill copies, and confirming freight and settlement terms. As a child he only saw paperwork taking over the dining table; as an adult he chose another path. The next day he will join a fintech settlement team in Lujiazui working on inter-institutional payment and fund-settlement systems. Automated account connections make him believe he has finally escaped the slowness of paper and port work. He divides the banks into two eras: ships, customs, old bank buildings, and filing cabinets on the west; data, algorithms, real-time settlement, and new financial infrastructure on the east. At dusk his mother gives him an old bill-of-lading copy from his maternal grandfather near the Customs House. The paper has no collectible value and records only an ordinary shipment. He says tomorrow he will leave old Shanghai. His mother does not ask him to inherit the business; she asks whether he is changing jobs or leaving his origins on this bank as well. Walking south, they see the Huangpu hold historic architecture, the Customs House clock, river traffic, and Pudong glass together in the dusk.",
        ),
        (
            "Gần bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ việc mở cảng năm 1843 nằm trong hệ thống điều ước bất bình đẳng, sau đó các cơ quan thương mại, vận tải, hải quan, ngân hàng và kinh doanh ở Ngoại Than cùng vùng lân cận phát triển và tái tổ chức qua nhiều thập kỷ; đó tuyệt nhiên không phải câu chuyện nhẹ nhàng thành phố cũ bỗng thành hiện đại. Trước đây anh để kiến thức ấy trong sách giáo khoa. Anh nhiều lần muốn trả vận đơn nhưng mẹ chỉ nhắc chuyện thuyền giấy. Họ chia tay ở cửa soát vé và anh lên phà với tờ giấy trong túi máy tính. Ngoại Than lùi thành một dải sáng, tàu hàng tiếp tục trên luồng chính và Phố Đông dâng lên trước mặt. Khoảng cách mở hai bờ cùng lúc, khiến đường thẳng cũ đến mới anh từng tin trở nên quá hẹp. Vận đơn viết hàng hóa, tín dụng, trách nhiệm, thông tin và thanh toán trên giấy; hệ thống hôm nay biến chúng thành dữ liệu, thông điệp, quy tắc và thanh toán thời gian thực. Công cụ thay đổi nhưng nhu cầu tổ chức lưu chuyển liên tục tái cấu trúc. Sang phía Đông Xương, anh đi Lục Gia Chủy, không tiếp quản việc nhà nhưng cũng không nghi ngờ nghề mới; anh chỉ thấy Ngoại Than không phải nền cũ bị đường chân trời mới đào thải và Lục Gia Chủy không phải tương lai bắt đầu từ số không.",
            "Near the East Jinling Road ferry, Lin An recalls that the 1843 treaty-port opening belonged to the unequal-treaty system and that trade, shipping, customs, banking, and commercial institutions around the Bund developed and reorganized over decades; this was never a light story of an old city suddenly becoming modern. He had kept that knowledge in textbooks. He repeatedly considers returning the bill, but his mother only mentions the paper boats. They part at the gate and he boards with the document in his computer bag. The Bund recedes into a bright line, cargo ships continue along the main channel, and Pudong rises ahead. The water opens both banks at once and makes his old straight line from old to new seem too narrow. The bill writes goods, credit, responsibility, information, and payment on paper; today’s system turns them into data, messages, rules, and real-time settlement. Tools change while the need to organize flows keeps being restructured. At Dongchang Road he walks toward Lujiazui, neither taking over the family business nor doubting the new career; he simply sees that the Bund is not an old background eliminated by a new skyline and Lujiazui is not a future that began from zero.",
        ),
    ],
    10: [
        (
            "Lâm Ngạn 24 tuổi, lớn lên trong gia đình gắn với thương mại cảng Thượng Hải. Công việc giao nhận và chứng từ của cha mẹ hằng ngày là đổi lịch tàu gấp, kiểm tra đi kiểm tra lại hồ sơ khai quan, tìm bản sao vận đơn, xác nhận cước và điều kiện thanh toán. Khi nhỏ anh khó chịu vì giấy tờ chiếm bàn ăn; lên đại học anh càng tin rằng mới nghĩa là thoát khỏi quy trình giấy. Ngày mai anh sẽ vào đội thanh toán công nghệ tài chính ở Lục Gia Chủy, tham gia hệ thống thanh toán và giao nhận vốn giữa các tổ chức. Kết nối tài khoản tự động khiến anh xem nghề mới như một sự cắt đứt: bờ tây Hoàng Phố giữ tàu, hải quan, nhà ngân hàng cũ và tủ hồ sơ của cha mẹ; bờ đông thuộc về dữ liệu, thuật toán, thanh toán thời gian thực và hạ tầng tài chính mới. Chiều tối anh gặp mẹ gần Tòa nhà Hải quan ở Ngoại Than. Bà đưa bản sao vận đơn cũ đã ngả vàng của ông ngoại, chỉ ghi một lô hàng bình thường. Anh nói ngày mai sẽ rời Thượng Hải cũ để vào Thượng Hải mới. Mẹ không yêu cầu anh nối nghiệp cũng không biện hộ cho ngành cũ, chỉ hỏi anh đổi công việc hay muốn bỏ cả nguồn gốc ở bờ này. Khi họ đi về phía nam, kiến trúc lịch sử, tiếng chuông Hải quan, du thuyền, tàu công vụ và ánh chiều phản trên mặt kính bờ đông cùng nằm trong một hình ảnh chuyển động của Hoàng Phố.",
            "Lin An is twenty-four and grew up in a family tied to Shanghai port trade. His parents’ freight and document work is the daily routine of last-minute sailing changes, repeated customs checks, chasing a bill copy, and confirming freight and settlement terms. As a child he resented paperwork covering the dining table; at university he became more willing to believe that new meant escaping paper processes. The next day he will join a fintech settlement team in Lujiazui working on inter-institutional payment and fund-settlement systems. Automated account connections make him interpret the new career as a complete cut: ships, customs, old bank buildings, and his parents’ filing cabinets remain on the west bank of the Huangpu; data, algorithms, real-time settlement, and new financial infrastructure belong to the east. At dusk he meets his mother on the Bund near the Customs House. She gives him a yellowing old bill-of-lading copy left by his maternal grandfather, recording only an ordinary shipment. He says tomorrow he will leave old Shanghai for new Shanghai. His mother neither asks him to inherit the business nor defends the old industry; she asks whether he is changing jobs or leaving his origins on this bank. As they walk south, historic architecture, the Customs House clock, tour boats, working vessels, and sunset reflected from glass across the river share one moving Huangpu scene.",
        ),
        (
            "Gần bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ mình không hề thiếu kiến thức về thành phố dưới chân. Việc Thượng Hải mở cảng năm 1843 diễn ra trong hệ thống điều ước bất bình đẳng thế kỷ XIX; sau đó thương mại, vận tải, hải quan, ngân hàng và các cơ quan kinh doanh ở Ngoại Than cùng vùng lân cận tập trung và tái tổ chức trong thời gian dài. Kinh tế đô thị cận đại không khởi động trong một ngày, và Phố Đông hiện đại cũng không xóa sạch lịch sử tài chính, vận tải của bờ tây. Trước kia, lịch sử ấy chỉ nằm trong sách và bảng trưng bày. Vận đơn cũ chạm cạnh máy tính và anh nhiều lần muốn trả lại; mẹ chỉ cười nhắc chuyện thuyền giấy bằng tờ khai bỏ đi. Họ chia tay ở cửa soát vé, anh đặt vận đơn vào ngăn máy tính và lên phà một mình. Khi Ngoại Than và tháp đồng hồ Hải quan lùi thành dải sáng, tàu hàng vẫn chạy trên luồng chính và đường chân trời Phố Đông dâng lên. Hai bờ cùng rõ làm anh thấy con sông không chia Thượng Hải thành quá khứ và tương lai. Vận đơn viết hàng hóa, tín dụng, trách nhiệm, thông tin và thanh toán trên giấy; hệ thống hôm nay biến các quan hệ tương tự thành dữ liệu, thông điệp, quy tắc và thanh toán thời gian thực. Công cụ, tốc độ và đường chân trời thay đổi, nhưng thành phố vẫn tổ chức lại cách người, hàng, thông tin và vốn đến với nhau. Sang phía Đông Xương, anh vẫn đi Lục Gia Chủy, không tiếp quản việc nhà và vẫn mong đợi nghề mới; khi ngoái lại, Ngoại Than không còn là nền cũ chờ bị đào thải và Lục Gia Chủy cũng không cần độc chiếm chữ tương lai. Tờ chứng từ cũ đã cùng anh qua sông.",
            "Near the East Jinling Road ferry, Lin An remembers that he is not ignorant of the city beneath his feet. Shanghai’s 1843 treaty-port opening occurred within the nineteenth-century unequal-treaty system; trade, shipping, customs, banking, and commercial institutions around the Bund then underwent long processes of concentration and reorganization. The modern urban economy did not start on a single day, and modern Pudong did not erase the west bank’s financial and shipping history. Previously, that history had stayed behind the glass of textbooks and displays. The old bill touches the edge of his computer and he repeatedly wants to return it; his mother only laughs about paper boats made from discarded customs forms. They part at the gate, and he puts the bill in the computer compartment before boarding alone. As the Bund and Customs House clock tower recede into a bright line, cargo ships continue along the main channel and the Pudong skyline rises. Seeing both banks clearly at once, he realizes that the river does not divide Shanghai into past and future. The old bill writes goods, credit, responsibility, information, and payment on paper; today’s system turns similar relationships into data, messages, rules, and real-time settlement. Tools, speed, and skylines change, but the city keeps reorganizing how people, goods, information, and capital reach one another. At Dongchang Road he still walks toward Lujiazui, does not take over the family business, and still looks forward to the new career; when he looks back, the Bund is no longer an old background waiting to be eliminated, and Lujiazui no longer needs to monopolize the word future. The old document has crossed the river with him.",
        ),
    ],
}

source_support = {
    "这个晚上，他先到外滩和母亲见面。": (
        "Tối hôm đó, trước tiên anh đến Ngoại Than gặp mẹ.",
        "That evening, he first goes to the Bund to meet his mother.",
    ),
    "林岸说，过了黄浦江，就是离开旧上海，进入新上海。": (
        "Lâm Ngạn nói rằng qua Hoàng Phố nghĩa là rời Thượng Hải cũ và bước vào Thượng Hải mới.",
        "Lin An says that crossing the Huangpu means leaving old Shanghai and entering new Shanghai.",
    ),
    "第二天，他将到陆家嘴一家金融科技公司的结算团队上班。": (
        "Ngày hôm sau, anh sẽ làm việc trong đội thanh toán của một công ty công nghệ tài chính ở Lục Gia Chủy.",
        "The next day, he will work on the settlement team of a fintech company in Lujiazui.",
    ),
    "母亲在海关大楼附近等他，手里夹着一张外祖父留下的旧海运提单副本。": (
        "Mẹ đợi anh gần Tòa nhà Hải quan, cầm một bản sao vận đơn đường biển cũ do ông ngoại để lại.",
        "His mother waits near the Customs House holding a copy of an old maritime bill of lading left by his maternal grandfather.",
    ),
    "轮渡离开西岸，他看见外滩慢慢退远，陆家嘴的高楼越来越近。": (
        "Khi phà rời bờ tây, anh thấy Ngoại Than dần lùi xa và những tòa nhà cao tầng của Lục Gia Chủy ngày càng gần.",
        "As the ferry leaves the west bank, he sees the Bund recede while Lujiazui’s towers draw closer.",
    ),
    "林岸二十四岁，在外滩长大，也常帮家里整理货运和报关单。": (
        "Lâm Ngạn 24 tuổi, lớn lên ở Ngoại Than và thường giúp gia đình sắp xếp chứng từ vận tải và tờ khai hải quan.",
        "Lin An is twenty-four, grew up on the Bund, and often helps his family organize freight documents and customs declarations.",
    ),
    "货物、文件、信用、信息和资金只是换了工具继续流动。": (
        "Hàng hóa, giấy tờ, tín dụng, thông tin và vốn chỉ thay đổi công cụ rồi tiếp tục lưu chuyển.",
        "Goods, documents, credit, information, and capital simply change tools and continue to flow.",
    ),
    "接近金陵东路轮渡站时，林岸想起上海1843年的开埠发生在十九世纪不平等条约体系下，此后外滩的贸易、航运、海关、银行与商业功能经过长期发展，并非一夜形成。": (
        "Khi gần bến phà đường Đông Kim Lăng, Lâm Ngạn nhớ rằng việc Thượng Hải mở cảng năm 1843 diễn ra trong hệ thống điều ước bất bình đẳng thế kỷ XIX; sau đó các chức năng thương mại, vận tải, hải quan, ngân hàng và kinh doanh của Ngoại Than phát triển trong thời gian dài chứ không hình thành chỉ trong một đêm.",
        "Near the East Jinling Road ferry, Lin An recalls that Shanghai’s 1843 treaty-port opening occurred within the nineteenth-century unequal-treaty system and that the Bund’s trade, shipping, customs, banking, and commercial functions developed over a long period rather than overnight.",
    ),
}


def generate_support_file(levels: list[list[str]]) -> str:
    lines = [
        "import 'package:pinyin/pinyin.dart';",
        "",
        "import 'journey_data.dart';",
        "",
        "class ShanghaiBundParagraphSupport {",
        "  const ShanghaiBundParagraphSupport({",
        "    required this.chinese,",
        "    required this.vietnamese,",
        "    required this.english,",
        "  });",
        "",
        "  final String chinese;",
        "  final String vietnamese;",
        "  final String english;",
        "}",
        "",
        "const _paragraphSupport = <int, List<ShanghaiBundParagraphSupport>>{",
    ]
    for level in range(1, 11):
        supports = paragraph_translations[level]
        assert len(levels[level - 1]) == len(supports)
        lines.append(f"  {level}: <ShanghaiBundParagraphSupport>[")
        for chinese, (vietnamese, english) in zip(levels[level - 1], supports):
            lines += [
                "    ShanghaiBundParagraphSupport(",
                f"      chinese: {dart_string(chinese)},",
                f"      vietnamese: {dart_string(vietnamese)},",
                f"      english: {dart_string(english)},",
                "    ),",
            ]
        lines.append("  ],")
    lines += [
        "};",
        "",
        "const _sourceSupport = <String, ShanghaiBundParagraphSupport>{",
    ]
    for chinese, (vietnamese, english) in source_support.items():
        lines += [
            f"  {dart_string(chinese)}: ShanghaiBundParagraphSupport(",
            f"    chinese: {dart_string(chinese)},",
            f"    vietnamese: {dart_string(vietnamese)},",
            f"    english: {dart_string(english)},",
            "  ),",
        ]
    lines += [
        "};",
        "",
        "String _pinyin(String chinese) => PinyinHelper.getPinyinE(",
        "      chinese,",
        "      separator: ' ',",
        "      format: PinyinFormat.WITH_TONE_MARK,",
        "    );",
        "",
        "int shanghaiBundLevelForParagraphs(List<String> paragraphs) {",
        "  for (final entry in _paragraphSupport.entries) {",
        "    final expected = entry.value;",
        "    if (expected.length != paragraphs.length) continue;",
        "    var matches = true;",
        "    for (var index = 0; index < expected.length; index++) {",
        "      if (expected[index].chinese != paragraphs[index]) {",
        "        matches = false;",
        "        break;",
        "      }",
        "    }",
        "    if (matches) return entry.key;",
        "  }",
        "  throw StateError('Shanghai Bund Story paragraphs do not match any canonical level');",
        "}",
        "",
        "ReadingAnnotation shanghaiBundReadingAnnotationFor(",
        "  int level,",
        "  int paragraphIndex,",
        "  String chinese,",
        ") {",
        "  final supports = _paragraphSupport[level];",
        "  if (supports == null || paragraphIndex >= supports.length) {",
        "    throw StateError(",
        "      'Missing Shanghai Bund paragraph support for Lv$level paragraph ${paragraphIndex + 1}',",
        "    );",
        "  }",
        "  final support = supports[paragraphIndex];",
        "  if (support.chinese != chinese) {",
        "    throw StateError(",
        "      'Stale Shanghai Bund paragraph support at Lv$level paragraph ${paragraphIndex + 1}',",
        "    );",
        "  }",
        "  return ReadingAnnotation(",
        "    pinyin: _pinyin(chinese),",
        "    vietnamese: support.vietnamese,",
        "    english: support.english,",
        "  );",
        "}",
        "",
        "List<WordExample> shanghaiBundWordExamples(String source) {",
        "  final support = _sourceSupport[source];",
        "  if (support == null || support.chinese != source) {",
        "    throw StateError('Missing Shanghai Bund vocabulary source support: $source');",
        "  }",
        "  return List<WordExample>.unmodifiable(<WordExample>[",
        "    WordExample(",
        "      chinese: source,",
        "      pinyin: _pinyin(source),",
        "      vietnamese: support.vietnamese,",
        "      english: support.english,",
        "    ),",
        "    WordExample(",
        "      chinese: '故事原句：$source',",
        "      pinyin: _pinyin('故事原句：$source'),",
        "      vietnamese: 'Câu trong truyện: ${support.vietnamese}',",
        "      english: 'Story sentence: ${support.english}',",
        "    ),",
        "    WordExample(",
        "      chinese: '回看故事原句：$source',",
        "      pinyin: _pinyin('回看故事原句：$source'),",
        "      vietnamese: 'Đọc lại câu trong truyện: ${support.vietnamese}',",
        "      english: 'Review the story sentence: ${support.english}',",
        "    ),",
        "  ]);",
        "}",
        "",
    ]
    return "\n".join(lines)


shanghai_path = ROOT / "app/lib/data/shanghai_bund_one_pass.dart"
shanghai = shanghai_path.read_text()
levels = extract_story_levels(shanghai)
(ROOT / "app/lib/data/shanghai_bund_level_support.dart").write_text(
    generate_support_file(levels)
)

support_import = "import 'shanghai_bund_level_support.dart';"
if support_import not in shanghai:
    imports = list(re.finditer(r"^import\s+['\"][^'\"]+['\"];\n", shanghai, re.M))
    assert imports
    insert_at = imports[-1].end()
    shanghai = shanghai[:insert_at] + support_import + "\n" + shanghai[insert_at:]

match = re.search(r"^JourneyLevelContent _bundLevel\(", shanghai, re.M)
assert match
start = match.start()
end = find_statement_end(shanghai, start)
bund_level_replacement = """JourneyLevelContent _bundLevel(List<String> paragraphs) {
  final level = shanghaiBundLevelForParagraphs(paragraphs);
  return JourneyLevelContent(
    storyParagraphs: List<String>.unmodifiable(paragraphs),
    storyAnnotations: List<ReadingAnnotation>.unmodifiable(<ReadingAnnotation>[
      for (var i = 0; i < paragraphs.length; i++)
        shanghaiBundReadingAnnotationFor(level, i, paragraphs[i]),
    ]),
    words: const <WordEntry>[],
    discoveries: const <DiscoveryEntry>[],
    wonderQuestion: '',
    expressQuestion: '',
  );
}"""
shanghai = shanghai[:start] + bund_level_replacement + shanghai[end:]

match = re.search(r"^WordEntry _w\(", shanghai, re.M)
assert match
start = match.start()
end = find_statement_end(shanghai, start)
word_replacement = """WordEntry _w(
  String word,
  String pinyin,
  String pos,
  String zh,
  String vi,
  String en,
  String source,
) =>
    WordEntry(
      word: word,
      pinyin: pinyin,
      partOfSpeech: pos,
      simpleChinese: zh,
      translation: vi,
      englishDefinition: en,
      symbol: '◇',
      examples: shanghaiBundWordExamples(source),
    );"""
shanghai = shanghai[:start] + word_replacement + shanghai[end:]

discovery_close = list_close(shanghai, "shanghaiBundOnePassDiscoveries")
new_discoveries = """
  DiscoveryEntry(
    text: '外滩现海关大楼于1927年建成。它见证了更早开始、又持续变化的上海对外贸易与城市史，因此不能把1843年开埠时的外滩与1927年的现建筑当成同一个时间切片。',
    simpleChinese: '现海关大楼1927年建成，不能把不同年代的外滩混成同一时刻。',
    vietnamese: 'Tòa nhà Hải quan hiện nay ở Ngoại Than được hoàn thành năm 1927; không thể gộp Ngoại Than năm 1843 và công trình hiện tại vào cùng một lát cắt thời gian.',
    english: 'The present Bund Customs House was completed in 1927, so the Bund of 1843 and the current building cannot be collapsed into the same historical moment.',
    pinyin: 'Wàitān xiàn Hǎiguān Dàlóu yú yī jiǔ èr qī nián jiànchéng. Tā jiànzhèng le gèng zǎo kāishǐ, yòu chíxù biànhuà de Shànghǎi duìwài màoyì yǔ chéngshì shǐ, yīncǐ bùnéng bǎ yī bā sì sān nián kāibù shí de Wàitān yǔ yī jiǔ èr qī nián de xiàn jiànzhù dàngchéng tóng yí gè shíjiān qiēpiàn.',
  ),
  DiscoveryEntry(
    text: '现代陆家嘴金融城是在1990年浦东开发开放以后持续发展形成的。把这一现代金融空间直接倒置到十九世纪，会混淆外滩近代贸易金融史与浦东后来形成的城市功能。',
    simpleChinese: '现代陆家嘴金融城是在1990年浦东开发开放以后逐步形成的。',
    vietnamese: 'Khu tài chính Lục Gia Chủy hiện đại phát triển dần sau khi Phố Đông bắt đầu công cuộc khai phát và mở cửa năm 1990; không nên đảo ngược không gian hiện đại này vào thế kỷ XIX.',
    english: 'Modern Lujiazui Financial City developed after Pudong’s development and opening began in 1990; projecting that modern financial space directly back into the nineteenth century would blur distinct historical stages.',
    pinyin: 'Xiàndài Lùjiāzuǐ Jīnróngchéng shì zài yī jiǔ jiǔ líng nián Pǔdōng kāifā kāifàng yǐhòu chíxù fāzhǎn xíngchéng de. Bǎ zhè yí xiàndài jīnróng kōngjiān zhíjiē dàozhì dào shíjiǔ shìjì, huì hùnxiáo Wàitān jìndài màoyì jīnróng shǐ yǔ Pǔdōng hòulái xíngchéng de chéngshì gōngnéng.',
  ),
"""
shanghai = shanghai[:discovery_close] + new_discoveries + shanghai[discovery_close:]

trace_close = list_close(shanghai, "shanghaiBundOnePassDiscoveryTraces")
new_traces = """
  RemediatedDiscoveryTrace(
    discoveryIndex: 6,
    storyEventIds: <String>['BD2-E2', 'BD2-E5'],
    sourceIds: <String>['shanghai-gov-customs-house-1927'],
  ),
  RemediatedDiscoveryTrace(
    discoveryIndex: 7,
    storyEventIds: <String>['BD2-E5', 'BD2-E9'],
    sourceIds: <String>['shanghai-gov-pudong-lujiazui-development'],
  ),
"""
shanghai = shanghai[:trace_close] + new_traces + shanghai[trace_close:]

trace_start = declaration_start(shanghai, "shanghaiBundOnePassDiscoveryTraces")
discovery_plan = """const _shanghaiBundDiscoveryPlan = <List<int>>[
  <int>[0],
  <int>[4],
  <int>[3, 0],
  <int>[6, 4],
  <int>[5, 3],
  <int>[6, 1],
  <int>[2, 6],
  <int>[3, 7],
  <int>[7, 5],
  <int>[1, 6, 7],
];

JourneyLevelContent shanghaiBundOnePassLevelContent(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  final base = shanghaiBundOnePassRemediation.levelContent(level);
  final discoveries = _shanghaiBundDiscoveryPlan[level - 1]
      .map((index) => shanghaiBundOnePassDiscoveries[index])
      .toList(growable: false);
  return JourneyLevelContent(
    storyParagraphs: base.storyParagraphs,
    storyAnnotations: base.storyAnnotations,
    words: base.words,
    discoveries: List<DiscoveryEntry>.unmodifiable(discoveries),
    wonderQuestion: base.wonderQuestion,
    expressQuestion: base.expressQuestion,
  );
}

"""
shanghai = shanghai[:trace_start] + discovery_plan + shanghai[trace_start:]

source_start = declaration_start(shanghai, "shanghaiBundOnePassSources")
source_end = list_close(shanghai, "shanghaiBundOnePassSources")
source_section = shanghai[source_start:source_end]
bill_pattern = re.compile(
    r"RemediatedSourceBinding\(\s*id:\s*'shanghai-port-trade-document-context',.*?\),",
    re.S,
)
replacement = (
    "RemediatedSourceBinding("
    "id:'shanghai-port-trade-document-context',"
    "publisher:'全国人民代表大会 / 《中华人民共和国海商法》',"
    "scope:'提单用于证明海上货物运输合同、承运人接收或装船，并作为承运人据以交付货物的单证之法律边界'),"
)
source_section, count = bill_pattern.subn(replacement, source_section, count=1)
assert count == 1
extra_sources = """
  RemediatedSourceBinding(
    id: 'shanghai-gov-customs-house-1927',
    publisher: '上海市人民政府 / 上海市文化和旅游局',
    scope: '外滩现海关大楼1927年建成及其历史建筑时间边界',
  ),
  RemediatedSourceBinding(
    id: 'shanghai-gov-pudong-lujiazui-development',
    publisher: '上海市人民政府 / 浦东新区人民政府',
    scope: '1990年浦东开发开放以后陆家嘴现代金融城持续发展形成的时间边界',
  ),
"""
source_section = source_section + extra_sources
shanghai = shanghai[:source_start] + source_section + shanghai[source_end:]
shanghai_path.write_text(shanghai)

runtime_path = ROOT / "app/lib/data/batch_one_adaptive_story_levels.dart"
runtime = runtime_path.read_text()
old_branch = "_ => shanghaiBundOnePassRemediation.levelContent(level),"
assert runtime.count(old_branch) == 1
runtime = runtime.replace(
    old_branch,
    "shanghaiBundJourneyId => shanghaiBundOnePassLevelContent(level),\n"
    "    _ => shanghaiBundOnePassRemediation.levelContent(level),",
    1,
)

build_match = re.search(r"^JourneyLevelContent buildBatchOneGoldLevel\(", runtime, re.M)
assert build_match
helpers = """String shanghaiBundWonderQuestionForLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  if (level == 1) {
    return '林岸为什么最后没有把旧提单留在西岸？';
  }
  if (level <= 5) {
    return '林岸为什么在过江后不再把两岸理解成过去和未来？';
  }
  return '历史时间层次为什么让“旧上海到新上海”的直线说法变得不够准确？';
}

String shanghaiBundExpressQuestionForLevel(int requestedLevel) {
  final level = requestedLevel.clamp(1, 10).toInt();
  if (level == 1) {
    return '轮渡、旧提单和两岸距离怎样共同推动林岸做出选择？';
  }
  if (level <= 5) {
    return '旧海运提单与陆家嘴结算工作在故事里共同组织了哪些流动？';
  }
  return '结合外滩长期形成的贸易金融功能与陆家嘴现代结算，解释“变化的是载体，不是流动本身”是否充分。';
}

"""
runtime = runtime[:build_match.start()] + helpers + runtime[build_match.start():]

runtime = replace_named_statement(
    runtime,
    r"^\s*final wonderQuestion =",
    """  final wonderQuestion = experience.id == shanghaiBundJourneyId
      ? shanghaiBundWonderQuestionForLevel(level)
      : base.wonderQuestion;""",
)
runtime = replace_named_statement(
    runtime,
    r"^\s*final expressQuestion =",
    """  final expressQuestion = experience.id == shanghaiBundJourneyId
      ? shanghaiBundExpressQuestionForLevel(level)
      : base.expressQuestion;""",
)

memory_match = re.search(r"^BatchOneJourneyMemorySpec\? batchOneMemorySpecFor\(", runtime, re.M)
assert memory_match
memory_function = r"""BatchOneJourneyMemorySpec _shanghaiBundMemorySpecForLevel(
  int phoenixLevel,
) {
  final level = phoenixLevel.clamp(1, 10).toInt();
  final culturalPoint = switch (level) {
    1 =>
      '黄浦江把外滩与浦东放进同一条真实跨江关系里；林岸必须实际离开西岸，故事的选择才会发生。',
    2 =>
      '东金线把浦西金陵东路与浦东东昌路连接起来，轮渡让“过江”成为可执行的城市行动，而不是抽象隐喻。',
    3 =>
      '海运提单把货物、承运、交付与责任固定成可追踪的商业关系，旧单据因此不是怀旧道具，而是家庭工作经验的具体载体。',
    4 =>
      '外滩现海关大楼于1927年建成；建筑、黄浦江航运与轮渡共同形成西岸的贸易城市界面，因此不能把1843年的外滩与现建筑混成同一时间切片。',
    5 =>
      '外滩与陆家嘴隔江同时可见，使林岸能够把“旧/新”从替代关系改读成同一城市中不同阶段、不同工具共同组织流动。',
    6 =>
      '上海1843年的开埠发生在十九世纪不平等条约体系下；外滩贸易、航运、海关、银行与商业功能经历长期发展，不能被压缩成中性的一夜现代化。',
    7 =>
      '外滩的贸易、航运、海关、银行与商业机构经过长期聚集和重组；1927年建成的现海关大楼本身也提示需要区分不同历史时段。',
    8 =>
      '旧提单用纸面组织货物、信用、责任与付款；1990年浦东开发开放以后持续形成的现代陆家嘴金融空间，则以新的基础设施和数字系统组织流动。',
    9 =>
      '现代陆家嘴金融核心区并不意味着外滩相关金融与航运历史被清空；两岸需要放在同一城市经济系统的长期重组中理解。',
    _ =>
      '综合1843年的不平等条约背景、1927年现海关大楼的时间边界、1990年后陆家嘴现代金融空间的发展与黄浦江跨江关系，可以区分历史连续性、制度变化与简单“新替旧”叙事。',
  };
  final completionLens = switch (level) {
    1 => '本级收束在一次真实过江与“是否带走旧提单”的选择。',
    2 => '本级把轮渡路线与职业转向放在同一个可行动的城市空间中。',
    3 => '本级用提单的运输与责任关系理解旧纸为什么值得带过江。',
    4 => '本级用1927年现海关大楼的时间边界避免把不同年代的外滩混成一幅静止图。',
    5 => '本级从两岸同时可见理解“旧/新”不是简单替代。',
    6 => '本级加入1843年不平等条约背景，并拒绝中性化的一夜现代化叙事。',
    7 => '本级进一步用长期聚集、制度重组和建筑年代解释外滩功能的形成。',
    8 => '本级比较纸面单据与1990年后现代金融空间中的数字结算如何组织流动。',
    9 => '本级把外滩与陆家嘴放入同一城市经济系统进行多角度判断。',
    _ => '本级综合1843、1927与1990后三个时间层，完成历史、空间与现代金融关系的证据化判断。',
  };
  final storyResult = level == 1
      ? '林岸把旧提单带过黄浦江，仍继续走向新的工作；他没有用丢掉旧纸来证明自己已经离开过去。'
      : level <= 5
          ? '林岸仍选择去陆家嘴开始新工作，但把外祖父留下的旧海运提单一起带过黄浦江，不再把西岸当成必须丢下的过去。'
          : '林岸仍选择离开家庭旧行业、乘轮渡去陆家嘴开始新工作，但他把外祖父留下的旧海运提单带过黄浦江，并开始用历史、空间与流动关系重新判断“旧上海/新上海”的直线说法。';
  final relationshipAnswer = level == 1
      ? '母亲没有劝他留下，只把旧提单交给他，让他自己决定是否带它过江。'
      : level == 2
          ? '母亲没有反驳他的职业选择，只问他要不要把旧提单带走，把判断留给林岸自己。'
          : '母亲没有要求他留下或接班，只把旧提单交给他，并用纸船记忆和问题让他自己判断“换工作”是否等于“切断来路”。';

  return BatchOneJourneyMemorySpec(
    storyResult: storyResult,
    culturalPoint: culturalPoint,
    reviews: <RemediatedMemoryReview>[
      const RemediatedMemoryReview(
        category: 'choice',
        prompt: '到轮渡站前，林岸真正做了什么选择？',
        answer: '他没有把旧提单还给母亲，而是把它放进包里带上轮渡，同时保留去陆家嘴开始新工作的决定。',
        storyEventIds: <String>['BD2-E6', 'BD2-E7', 'BD2-E9'],
      ),
      RemediatedMemoryReview(
        category: 'relationship',
        prompt: '母亲怎样影响林岸，而没有替他选择职业？',
        answer: relationshipAnswer,
        storyEventIds: const <String>['BD2-E2', 'BD2-E3', 'BD2-E6'],
      ),
      RemediatedMemoryReview(
        category: 'place',
        prompt: '为什么这个故事不能随便搬到另一座城市的普通河岸？',
        answer: culturalPoint,
        storyEventIds: const <String>['BD2-E4', 'BD2-E7', 'BD2-E8'],
      ),
      const RemediatedMemoryReview(
        category: 'memory',
        prompt: '哪一个物件把家庭经验、人物选择与过江行动留在一起？',
        answer: '外祖父留下的旧海运提单副本。它跟林岸一起过江，成为“一张过江的旧提单”。',
        storyEventIds: <String>['BD2-E2', 'BD2-E7'],
      ),
    ],
    longTermAnchor: '一张过江的旧提单',
    completionSummary:
        '“双岸行者”完成：林岸没有放弃新职业，也没有通过丢掉旧提单来证明自己属于“新上海”。$completionLens 下一次遇到“新旧替代”的说法时，先分清哪些是可验证的历史与空间事实，哪些只是方便的直线叙事。',
  );
}

"""
runtime = runtime[:memory_match.start()] + memory_function + runtime[memory_match.start():]

memory_match = re.search(r"^BatchOneJourneyMemorySpec\? batchOneMemorySpecFor\(", runtime, re.M)
assert memory_match
brace = runtime.find("{", memory_match.end())
assert brace >= 0
early = """
  if (journeyId == shanghaiBundJourneyId) {
    return _shanghaiBundMemorySpecForLevel(
      phoenixLevel ?? PhoenixLevelController.instance.level,
    );
  }

"""
runtime = runtime[:brace + 1] + early + runtime[brace + 1:]
runtime_path.write_text(runtime)

test_content = r"""import 'package:flutter_test/flutter_test.dart';
import 'package:pinyin/pinyin.dart';
import 'package:phoenix_journeys/data/batch_one_adaptive_story_levels.dart';
import 'package:phoenix_journeys/data/shanghai_bund_level_support.dart';
import 'package:phoenix_journeys/data/shanghai_bund_one_pass.dart';

String pinyinFor(String chinese) => PinyinHelper.getPinyinE(
      chinese,
      separator: ' ',
      format: PinyinFormat.WITH_TONE_MARK,
    );

void main() {
  test('Shanghai reading support follows current level and paragraph identity', () {
    final fingerprints = <String>{};
    for (var level = 1; level <= 10; level++) {
      final content = shanghaiBundOnePassLevels[level - 1];
      expect(shanghaiBundLevelForParagraphs(content.storyParagraphs), level);
      expect(content.storyAnnotations, hasLength(content.storyParagraphs.length));
      for (var index = 0; index < content.storyParagraphs.length; index++) {
        final paragraph = content.storyParagraphs[index];
        final support = shanghaiBundReadingAnnotationFor(level, index, paragraph);
        expect(support.pinyin, pinyinFor(paragraph),
            reason: 'Lv$level paragraph ${index + 1} Pinyin');
        expect(support.vietnamese.trim(), isNotEmpty);
        expect(support.english.trim(), isNotEmpty);
        if (paragraph.contains('提单')) {
          expect(support.vietnamese.toLowerCase(), contains('vận đơn'));
          expect(support.english.toLowerCase(), contains('bill'));
        }
        if (paragraph.contains('轮渡')) {
          expect(support.vietnamese.toLowerCase(), contains('phà'));
          expect(support.english.toLowerCase(), contains('ferry'));
        }
        if (paragraph.contains('1843')) {
          expect(support.vietnamese, contains('1843'));
          expect(support.english, contains('1843'));
        }
        fingerprints.add('${support.vietnamese}|${support.english}');
      }
    }
    expect(fingerprints, hasLength(18));
  });

  test('Shanghai vocabulary separates word gloss from sentence support', () {
    for (final word in shanghaiBundOnePassWords) {
      final trace = shanghaiBundOnePassWordTraces
          .firstWhere((entry) => entry.word == word.word);
      expect(word.examples, hasLength(3), reason: word.word);
      expect(word.examples.first.chinese, trace.sourceText);
      expect(word.examples.first.chinese, contains(word.word));
      expect(word.examples.first.pinyin, pinyinFor(trace.sourceText));
      expect(word.examples.first.vietnamese.trim(), isNotEmpty);
      expect(word.examples.first.english.trim(), isNotEmpty);
      expect(word.examples.first.vietnamese, isNot(word.translation));
      expect(word.examples.first.english, isNot(word.englishDefinition));
      for (final example in word.examples) {
        expect(example.pinyin, pinyinFor(example.chinese));
      }
    }
  });

  test('Shanghai Discovery is current-level and preserves time boundaries', () {
    final expected = <int, List<String>>{
      1: <String>['黄浦江西岸'],
      2: <String>['东金线'],
      3: <String>['海运提单', '黄浦江西岸'],
      4: <String>['1927', '东金线'],
      5: <String>['陆家嘴', '海运提单'],
      6: <String>['1927', '1843'],
      7: <String>['长期发展', '1927'],
      8: <String>['海运提单', '1990'],
      9: <String>['1990', '陆家嘴'],
      10: <String>['1843', '1927', '1990'],
    };
    for (var level = 1; level <= 10; level++) {
      final content = shanghaiBundOnePassLevelContent(level);
      final joined = content.discoveries.map((entry) => entry.text).join('|');
      for (final anchor in expected[level]!) {
        expect(joined, contains(anchor), reason: 'Lv$level $anchor');
      }
      if (level < 4) expect(joined, isNot(contains('1927')));
      if (level < 6) {
        expect(joined, isNot(contains('1843')));
        expect(joined, isNot(contains('不平等条约')));
      }
      if (level < 8) expect(joined, isNot(contains('1990')));
      expect(content.discoveries.length, level <= 2 ? 1 : level == 10 ? 3 : 2);
    }
  });

  test('Shanghai Memory and Completion stay inside current level', () {
    final closures = <String>{};
    for (var level = 1; level <= 10; level++) {
      final spec = batchOneMemorySpecFor(
        shanghaiBundJourneyId,
        phoenixLevel: level,
      )!;
      final joined =
          '${spec.storyResult}|${spec.culturalPoint}|${spec.completionSummary}|${spec.reviews.map((e) => e.answer).join('|')}';
      closures.add('${spec.culturalPoint}|${spec.completionSummary}');
      expect(spec.reviews.map((entry) => entry.category).toSet(),
          containsAll(<String>{'choice', 'relationship', 'place', 'memory'}));
      expect(spec.storyResult, contains('林岸'));
      expect(spec.longTermAnchor, '一张过江的旧提单');
      if (level < 3) expect(joined, isNot(contains('纸船')));
      if (level < 4) expect(joined, isNot(contains('1927')));
      if (level < 6) {
        expect(joined, isNot(contains('1843')));
        expect(joined, isNot(contains('不平等条约')));
      }
      if (level < 8) expect(joined, isNot(contains('1990')));
    }
    expect(closures, hasLength(10));
  });

  test('Shanghai popup and support questions follow current level', () {
    expect(shanghaiBundWonderQuestionForLevel(1), isNot(contains('1843')));
    expect(shanghaiBundExpressQuestionForLevel(1), isNot(contains('结算')));
    expect(shanghaiBundExpressQuestionForLevel(1), contains('轮渡'));
    expect(shanghaiBundExpressQuestionForLevel(4), contains('结算'));
    expect(shanghaiBundWonderQuestionForLevel(6), contains('历史时间层次'));
  });

  test('Shanghai Fact Pack uses authoritative legal and time provenance', () {
    final bill = shanghaiBundOnePassSources.firstWhere(
      (entry) => entry.id == 'shanghai-port-trade-document-context',
    );
    expect(bill.publisher, contains('全国人民代表大会'));
    expect(bill.scope, contains('海上货物运输合同'));
    expect(bill.scope, contains('交付货物'));

    final customs = shanghaiBundOnePassSources.firstWhere(
      (entry) => entry.id == 'shanghai-gov-customs-house-1927',
    );
    expect(customs.publisher, contains('上海市人民政府'));
    expect(customs.scope, contains('1927'));

    final lujiazui = shanghaiBundOnePassSources.firstWhere(
      (entry) => entry.id == 'shanghai-gov-pudong-lujiazui-development',
    );
    expect(lujiazui.publisher, contains('浦东新区人民政府'));
    expect(lujiazui.scope, contains('1990'));
  });

  test('Shanghai keeps its independent narrative engine', () {
    final story = shanghaiBundOnePassLevels
        .map((level) => level.storyParagraphs.join())
        .join();
    for (final anchor in <String>[
      '林岸',
      '母亲',
      '旧海运提单',
      '黄浦江',
      '轮渡',
      '外滩',
      '陆家嘴',
    ]) {
      expect(story, contains(anchor));
    }
    for (final term in <String>['中轴观察', '东侧记录', '错误路线', '标准路线']) {
      expect(story, isNot(contains(term)));
    }
    for (final term in <String>['许澄', '周岚', '校展', '金光画面', '旧照片被风吹落']) {
      expect(story, isNot(contains(term)));
    }
  });
}
"""
(ROOT / "app/test/shanghai_bund_preserve_first_contract_test.dart").write_text(
    test_content
)

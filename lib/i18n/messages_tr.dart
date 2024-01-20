// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a tr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'tr';

  static m0(num) =>
      "${Intl.plural(num, one: 'Görevi Sil', other: 'Görevleri Sil')}";

  static m1(num) =>
      "${Intl.plural(num, one: 'Günlük', other: 'Her ${num} günde bir')}";

  static m2(num) =>
      "${Intl.plural(num, one: 'Haftalık', other: 'Her ${num} haftada bir')}";

  static m3(num) =>
      "${Intl.plural(num, one: 'Aylık', other: 'Her ${num} ayda bir')}";

  static m4(num) =>
      "${Intl.plural(num, one: 'Yıllık', other: 'Her ${num} yılda bir')}";

  static m5(num) => "${Intl.plural(num, one: 'Etiket', other: 'Etiketler')}";

  static m6(num) =>
      "${Intl.plural(num, one: 'Ögeyi Sil', other: 'Ögeleri Sil')}";

  static m7(num) =>
      "${Intl.plural(num, one: 'İşaretleri kaldır', other: 'İşaretler kaldırıldı')}";

  static m8(num) => "${num} satır";

  static m9(num) => "${num} dakika önce oluşturuldu";

  static m10(num) => "${num} saat önce oluşturuldu";

  static m11(date) => "${date} oluşturuldu";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "p0": m0,
        "p1": m1,
        "p2": m2,
        "p3": m3,
        "p4": m4,
        "p5": m5,
        "p6": m6,
        "p7": m7,
        "v0": m8,
        "v1": m9,
        "v2": m10,
        "v3": m11,
        "w0": MessageLookupByLibrary.simpleMessage("Taskiee"),
        "w1": MessageLookupByLibrary.simpleMessage(
            "Bugün ne yapmayı planlıyorsun?"),
        "w10": MessageLookupByLibrary.simpleMessage("Yeni Liste"),
        "w100": MessageLookupByLibrary.simpleMessage(
            "Hatırlatıcı geçmişe ayarlanamaz"),
        "w101": MessageLookupByLibrary.simpleMessage(
            "Önem derecesine göre sıralandı"),
        "w102":
            MessageLookupByLibrary.simpleMessage("Alfabetik olarak sıralandı"),
        "w103":
            MessageLookupByLibrary.simpleMessage("Son tarihe göre sıralandı"),
        "w104": MessageLookupByLibrary.simpleMessage(
            "Oluşturulma tarihine göre sıralandı"),
        "w105": MessageLookupByLibrary.simpleMessage(
            "Birkaç saniye önce oluşturuldu"),
        "w106": MessageLookupByLibrary.simpleMessage("Genel"),
        "w107": MessageLookupByLibrary.simpleMessage("Bildirimler"),
        "w109":
            MessageLookupByLibrary.simpleMessage("Yedekleme ve Geri Yükleme"),
        "w11": MessageLookupByLibrary.simpleMessage("Yeni Etiket"),
        "w110": MessageLookupByLibrary.simpleMessage("Hakkında"),
        "w111": MessageLookupByLibrary.simpleMessage(
            "Geliştiriciye bir kahve alın :)"),
        "w112": MessageLookupByLibrary.simpleMessage("Dil"),
        "w115":
            MessageLookupByLibrary.simpleMessage("Sistem bildirim ayarları"),
        "w116": MessageLookupByLibrary.simpleMessage("Yazı tipi"),
        "w117": MessageLookupByLibrary.simpleMessage("Tema"),
        "w118": MessageLookupByLibrary.simpleMessage("Renk"),
        "w119": MessageLookupByLibrary.simpleMessage("Ekleme butonu şekli"),
        "w12": MessageLookupByLibrary.simpleMessage("Yeni alt görev"),
        "w120": MessageLookupByLibrary.simpleMessage("Şekil"),
        "w121": MessageLookupByLibrary.simpleMessage("Etiket şekli"),
        "w123":
            MessageLookupByLibrary.simpleMessage("Sıralama çubuğu görünümü"),
        "w124":
            MessageLookupByLibrary.simpleMessage("Kaydırarak silme görünümü"),
        "w125": MessageLookupByLibrary.simpleMessage("Etiket görünümü"),
        "w127": MessageLookupByLibrary.simpleMessage("Bildirim sesi"),
        "w128": MessageLookupByLibrary.simpleMessage("Titreşimi etkinleştir"),
        "w129": MessageLookupByLibrary.simpleMessage("LED\'i etkinleştir"),
        "w13": MessageLookupByLibrary.simpleMessage("Listeyi Düzenle"),
        "w130": MessageLookupByLibrary.simpleMessage("Metin görünümü"),
        "w131": MessageLookupByLibrary.simpleMessage("İkon boyutu"),
        "w132":
            MessageLookupByLibrary.simpleMessage("Uygulamamızı beğendiniz mi?"),
        "w133": MessageLookupByLibrary.simpleMessage("Geribildirim gönder"),
        "w134": MessageLookupByLibrary.simpleMessage(
            "Verilerinizi cihaz deposundan geri yükleyin"),
        "w135": MessageLookupByLibrary.simpleMessage(
            "Verilerinizi cihaz deposuna yedekleyin"),
        "w136": MessageLookupByLibrary.simpleMessage(
            "Lütfen yedekleme dosyasının cihazın indirilenler klasöründe taskiee_backup.json olarak bulunduğundan emin olun"),
        "w137": MessageLookupByLibrary.simpleMessage(
            "Yedeklenen veriler, cihazın indirilenler klasöründe taskiee_backup.json olarak bulunur. E-posta, bluetooth vb. ile başka bir telefona gönderebilirsiniz"),
        "w138": MessageLookupByLibrary.simpleMessage("Sorun bildirin"),
        "w139": MessageLookupByLibrary.simpleMessage("Özellik önerin"),
        "w14": MessageLookupByLibrary.simpleMessage("Etiketi Düzenle"),
        "w140": MessageLookupByLibrary.simpleMessage("Çeviri hatası bildirin"),
        "w141":
            MessageLookupByLibrary.simpleMessage("Çeviriye katkıda bulunun"),
        "w142": MessageLookupByLibrary.simpleMessage(
            "Bildirimlerle ilgili sorun mu yaşıyorsunuz?"),
        "w143": MessageLookupByLibrary.simpleMessage("Bildirim Yardımı"),
        "w144": MessageLookupByLibrary.simpleMessage(
            "Bildirimler zamanında gelmiyor"),
        "w145": MessageLookupByLibrary.simpleMessage(
            "Bazı üreticilerin çok agresif güç tasarrufu eklemesi nedeniyle Taskiee sistem tarafından arka plandan temizlenebilir. Zamanında bildirim almak için aşağıdaki adımları deneyebilirsiniz."),
        "w146": MessageLookupByLibrary.simpleMessage("Olası Çözümler"),
        "w147": MessageLookupByLibrary.simpleMessage(
            "\"Pil optimizasyonunu yoksay\" seçeneğini etkinleştirmek için dokunun"),
        "w149": MessageLookupByLibrary.simpleMessage(
            "Tamamlanan göreve hatırlatıcı ayarlanamaz"),
        "w15": MessageLookupByLibrary.simpleMessage("Listeyi Sil"),
        "w150": MessageLookupByLibrary.simpleMessage("Birincil"),
        "w151": MessageLookupByLibrary.simpleMessage("İkincil"),
        "w152": MessageLookupByLibrary.simpleMessage("Özel"),
        "w153": MessageLookupByLibrary.simpleMessage("Notu Sil"),
        "w154": MessageLookupByLibrary.simpleMessage(
            "Bu notu silmek istediğinizden emin misiniz?"),
        "w155":
            MessageLookupByLibrary.simpleMessage("Hatırlatıcı iptal edildi"),
        "w156": MessageLookupByLibrary.simpleMessage("Hatırlatıcı kuruldu"),
        "w157": MessageLookupByLibrary.simpleMessage("Sıralama türü"),
        "w158": MessageLookupByLibrary.simpleMessage("Alfabetik (A-Z)"),
        "w159": MessageLookupByLibrary.simpleMessage("Alfabetik (Z-A)"),
        "w16": MessageLookupByLibrary.simpleMessage("Etiketi Sil"),
        "w160": MessageLookupByLibrary.simpleMessage("Oluşturulma (En Yeni)"),
        "w161": MessageLookupByLibrary.simpleMessage("Oluşturulma (En Eski)"),
        "w163": MessageLookupByLibrary.simpleMessage(
            "Özel olarak sıralamak için dokunun"),
        "w164": MessageLookupByLibrary.simpleMessage("Listeleri Sırala"),
        "w165": MessageLookupByLibrary.simpleMessage("Etiketleri Sırala"),
        "w166": MessageLookupByLibrary.simpleMessage("Özel Olarak Sırala"),
        "w167": MessageLookupByLibrary.simpleMessage("Not içeriği"),
        "w168": MessageLookupByLibrary.simpleMessage("Görev Notları"),
        "w169": MessageLookupByLibrary.simpleMessage("Notu Düzenle"),
        "w17": MessageLookupByLibrary.simpleMessage("Tamamlananları sil"),
        "w170": MessageLookupByLibrary.simpleMessage("Yeni Not"),
        "w171": MessageLookupByLibrary.simpleMessage("Görünüm"),
        "w19": MessageLookupByLibrary.simpleMessage("Katkıda Bulunun"),
        "w2": MessageLookupByLibrary.simpleMessage("Yıl Seçin"),
        "w20": MessageLookupByLibrary.simpleMessage("Aranacak Ögeler"),
        "w21":
            MessageLookupByLibrary.simpleMessage("Nasıl yardımcı olabiliriz?"),
        "w23": MessageLookupByLibrary.simpleMessage("Sıralama Ölçütü"),
        "w24": MessageLookupByLibrary.simpleMessage("Liste Ekle"),
        "w25": MessageLookupByLibrary.simpleMessage("Etiket Ekle"),
        "w26": MessageLookupByLibrary.simpleMessage("Görev Ekle"),
        "w172": MessageLookupByLibrary.simpleMessage("Özel olarak sırala"),
        "w27": MessageLookupByLibrary.simpleMessage("Not ekle"),
        "w28": MessageLookupByLibrary.simpleMessage("Liste adı"),
        "w29": MessageLookupByLibrary.simpleMessage("Etiket adı"),
        "w3": MessageLookupByLibrary.simpleMessage("Liste Seçin"),
        "w30": MessageLookupByLibrary.simpleMessage("Son tarihi ayarla"),
        "w31": MessageLookupByLibrary.simpleMessage("Tekrarla"),
        "w32": MessageLookupByLibrary.simpleMessage("Bana anımsat"),
        "w33": MessageLookupByLibrary.simpleMessage("Tamamlananları göster"),
        "w34": MessageLookupByLibrary.simpleMessage("Tamamlananları gizle"),
        "w35": MessageLookupByLibrary.simpleMessage("Görevleri filtrele"),
        "w36": MessageLookupByLibrary.simpleMessage("Görevleri sırala"),
        "w37": MessageLookupByLibrary.simpleMessage("Son tarih yok"),
        "w38": MessageLookupByLibrary.simpleMessage("Tarih seçin"),
        "w39": MessageLookupByLibrary.simpleMessage("Önemli olarak işaretle"),
        "w4": MessageLookupByLibrary.simpleMessage("Zaman Seçin"),
        "w40": MessageLookupByLibrary.simpleMessage("Taşı"),
        "w41": MessageLookupByLibrary.simpleMessage("Görevi yeniden adlandır"),
        "w42":
            MessageLookupByLibrary.simpleMessage("Alt görevi yeniden adlandır"),
        "w43": MessageLookupByLibrary.simpleMessage("Görev silindi"),
        "w44": MessageLookupByLibrary.simpleMessage("Alt görev silindi"),
        "w46": MessageLookupByLibrary.simpleMessage("Henüz etiketiniz yok"),
        "w47": MessageLookupByLibrary.simpleMessage(
            "Görevlerinizi filtreleyerek arama yapabilirsiniz"),
        "w48": MessageLookupByLibrary.simpleMessage(
            "Bu ögeleri silmek istediğinizden emin misiniz?"),
        "w49": MessageLookupByLibrary.simpleMessage(
            "Ne aramak istersiniz? İstediğiniz her şeyi arayabilirsin"),
        "w5": MessageLookupByLibrary.simpleMessage("Renk Seçin"),
        "w50": MessageLookupByLibrary.simpleMessage(
            "Maalesef aradığınızı bulamadık"),
        "w51": MessageLookupByLibrary.simpleMessage("Listeler"),
        "w53": MessageLookupByLibrary.simpleMessage("Görevler"),
        "w54": MessageLookupByLibrary.simpleMessage("Notlar"),
        "w55": MessageLookupByLibrary.simpleMessage("Alt Görevler"),
        "w56": MessageLookupByLibrary.simpleMessage("Bugün"),
        "w57": MessageLookupByLibrary.simpleMessage("Yarın"),
        "w58": MessageLookupByLibrary.simpleMessage("Dün"),
        "w59": MessageLookupByLibrary.simpleMessage("gün"),
        "w6": MessageLookupByLibrary.simpleMessage("İkon Seçin"),
        "w60": MessageLookupByLibrary.simpleMessage("hafta"),
        "w61": MessageLookupByLibrary.simpleMessage("ay"),
        "w62": MessageLookupByLibrary.simpleMessage("yıl"),
        "w63": MessageLookupByLibrary.simpleMessage("Bitti"),
        "w64": MessageLookupByLibrary.simpleMessage("İptal"),
        "w65": MessageLookupByLibrary.simpleMessage("Sil"),
        "w66": MessageLookupByLibrary.simpleMessage("Geri Al"),
        "w7": MessageLookupByLibrary.simpleMessage("Etiket Seçin"),
        "w70": MessageLookupByLibrary.simpleMessage("Ara"),
        "w71": MessageLookupByLibrary.simpleMessage("Derecelendirin"),
        "w72": MessageLookupByLibrary.simpleMessage("Önemli"),
        "w73": MessageLookupByLibrary.simpleMessage("Önem derecesi"),
        "w74": MessageLookupByLibrary.simpleMessage("Alfabetik"),
        "w75": MessageLookupByLibrary.simpleMessage("Son tarih"),
        "w76": MessageLookupByLibrary.simpleMessage("Önce En Yeni"),
        "w77": MessageLookupByLibrary.simpleMessage("Önce En Eski"),
        "w78": MessageLookupByLibrary.simpleMessage("Normal"),
        "w79": MessageLookupByLibrary.simpleMessage("Renkli"),
        "w8": MessageLookupByLibrary.simpleMessage("Filtreleri Seçin"),
        "w80": MessageLookupByLibrary.simpleMessage("Versiyon"),
        "w81": MessageLookupByLibrary.simpleMessage("Hepsi"),
        "w82": MessageLookupByLibrary.simpleMessage("Büyük"),
        "w83": MessageLookupByLibrary.simpleMessage("Anladım"),
        "w84": MessageLookupByLibrary.simpleMessage("Daha Büyük"),
        "w85": MessageLookupByLibrary.simpleMessage("Kenarları Renkli"),
        "w86": MessageLookupByLibrary.simpleMessage("Oluşturulma tarihi"),
        "w87": MessageLookupByLibrary.simpleMessage(
            "Bu listeyi ve tüm görevlerini silmek istediğinizden emin misiniz?"),
        "w89": MessageLookupByLibrary.simpleMessage(
            "Taskiee bağımsız geliştirici tarafından yapılmıştır ve diğer dillere çevrilmesi gerekmektedir. Bu yüzden çeviriye katkıda bulunmak istiyorsanız lütfen bana geri bildirim bölümünden e-posta gönderin. Başkalarına ve bana çok yardımı dokunur :)"),
        "w9": MessageLookupByLibrary.simpleMessage("Dil Seçin"),
        "w90": MessageLookupByLibrary.simpleMessage(
            "Bu etiketi silmek istediğinizden emin misiniz?"),
        "w91": MessageLookupByLibrary.simpleMessage(
            "Tamamlanan görevleri silmek istediğinizden emin misiniz?"),
        "w92": MessageLookupByLibrary.simpleMessage(
            "Bu görevi silmek istediğinizden emin misiniz?"),
        "w93": MessageLookupByLibrary.simpleMessage("Lütfen bir liste seçin"),
        "w94": MessageLookupByLibrary.simpleMessage("Metin boş bırakılamaz"),
        "w95": MessageLookupByLibrary.simpleMessage(
            "Veriler başarıyla yedeklendi"),
        "w96": MessageLookupByLibrary.simpleMessage(
            "Veriler başarıyla geri yüklendi"),
        "w97":
            MessageLookupByLibrary.simpleMessage("Bilinmeyen bir hata oluştu"),
        "w98": MessageLookupByLibrary.simpleMessage(
            "Dosya okunurken bir hata oluştu"),
        "w99": MessageLookupByLibrary.simpleMessage("Dosya bulunamadı"),
        "w173": MessageLookupByLibrary.simpleMessage(
            "Tamamlanan görevlerin üstünü çiz"),
        "w174": MessageLookupByLibrary.simpleMessage(
            "Tamamlanan görevleri takvimde göster"),
        "w175": MessageLookupByLibrary.simpleMessage(
            "Tamamlanan görevleri otomatik sil"),
        "w177": MessageLookupByLibrary.simpleMessage(
            "Eğer varsa, uygulama ayarından pil tasarrufunu devre dışı bırakın"),
        "w178": MessageLookupByLibrary.simpleMessage(
            "Eğer varsa, telefon veya uygulama ayarından \"Otomatik Başlat\" açın"),
        "w176": MessageLookupByLibrary.simpleMessage(
            "Uyarı: Etkinleştirildiğinde, şu anki tamamlanmış olan tüm görevlerinizi siler"),
        "w179": MessageLookupByLibrary.simpleMessage(
            "Görünüşe göre bazı değişiklikler yapmışsınız. Onları kaydetmek ister misiniz?"),
        "w180": MessageLookupByLibrary.simpleMessage(
            "Yeni görevi listenin en altına ekle"),
        "w181": MessageLookupByLibrary.simpleMessage(
            "Tamamlanan görevleri listenin altına taşı"),
        "w182": MessageLookupByLibrary.simpleMessage(
            "Listenin tamamlanma oranı hesaplamasına alt görevleri dahil eder"),
        "w183": MessageLookupByLibrary.simpleMessage(
            "Alt görevleri hesaplamaya dahil et"),
        "w184": MessageLookupByLibrary.simpleMessage("Kaydet"),
        "w185": MessageLookupByLibrary.simpleMessage("Hayır"),
        "w186": MessageLookupByLibrary.simpleMessage("Görevi Kaydet"),
        "w189": MessageLookupByLibrary.simpleMessage("Sonraki bitiş tarihini ile hesapla"),
        "w190": MessageLookupByLibrary.simpleMessage("tamamlanma tarihi"),
        "w191": MessageLookupByLibrary.simpleMessage("eski bitiş tarihi (varsayılan)"),
        "w188": MessageLookupByLibrary.simpleMessage(
            "Alt gezinti çubuğunu koyulaştır"),
        "w187": MessageLookupByLibrary.simpleMessage(
            "Uyarı: Zaten bir yedekleme dosyanız varsa, onun üstüne yazmanız gerekir. Aksi halde sistem onu yeni bir dosya olarak oluşturur ve depolama alanınızı gereksiz yere tüketir. Üstüne yazmak için dosyanın üzerine dokunun ve kaydete basın"),
      };
}

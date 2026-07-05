# Uçuş İzleme — GPS'siz Konum Tahmini (3D Görselleştirici)

Bu, [GSP_Kullanmadan_Konum_Tahmini](https://github.com/) ana projesinin çıktısı olan
GPS-kesintisi konum-tahmin kayıtlarını 3 boyutlu, tarayıcı içi bir oynatıcıda
canlandıran bağımsız bir web uygulamasıdır. Ana projede model eğitimi ve analiz
yapılır; bu repo yalnızca sonuçların görselleştirilmesinden sorumludur.

## Nasıl çalıştırılır

```bash
git clone <bu-repo-url>
cd ucus-izleme-app
./serve.sh            # varsayılan port 8090, değiştirmek için: ./serve.sh 9000
```

Sonra tarayıcıda **http://localhost:8090** adresini açın.

> Not: Sayfa veriyi `fetch('./data/ucuslar.json')` ile yüklediği için `file://`
> üzerinden doğrudan açmak çalışmaz (tarayıcı CORS kısıtlaması) — mutlaka
> `serve.sh` ile bir HTTP sunucusu üzerinden çalıştırın.

## Ekran açıklaması

- **Beyaz iz** — gerçek rota (GPS referans, "true").
- **Yeşil (production)** — üretim füzyon modeli tahmini (`v71` / `prod`): ensemble + fizik baseline karışımı.
- **Camgöbeği (AI ensemble)** — sensör-only AI ensemble modeli tahmini (`v66`).
- **Amber (v7)** — tek-model AI tahmini (`v7`).
- **Mor (fizik)** — saf fizik/dead-reckoning baseline tahmini (`fizik`).
- **Zemin ızgarası** — minimum irtifa düzlemi, ölçek etiketiyle birlikte.
- **Dikey çizgi** — o anki noktadan zemine iz düşümü (yerden yükseklik).

Üstteki HUD şeridi anlık uçuş süresini, GPS durumunu (LOCK / KESİNTİ), irtifayı
ve her modelin o anki konum hatasını (metre) gösterir. Her ~60 saniyede bir
30 saniyelik bir GPS kesintisi simüle edilir; kesinti sırasında dört model de
sensör-only tahmin üretir ve gerçek rotadan sapması canlı ölçülür.

### Etkileşim

| Eylem | Kontrol |
|---|---|
| Kamerayı döndür | Sürükle (fare/dokunmatik) |
| Yakınlaş / uzaklaş | Fare tekerleği |
| Uçuş seç | Üstteki sekmeler (chip) |
| Oynat / Duraklat | ▶ / ❚❚ düğmesi |
| Hız | 1× / 4× / 10× düğmeleri |
| Baştan oynat | ⟲ düğmesi |

## Veri formatı

`data/ucuslar.json` — uçuş kayıtları sözlüğü:

```jsonc
{
  "<ucus_id>": {
    "ad": "Görüntülenecek uçuş adı",
    "true": [[kuzey_m, dogu_m, irtifa_m], ...],   // GPS referans rota, 0.5s adımlarla
    "outages": [
      {
        "s": 120,                // kesintinin başladığı örnek indeksi ("true" içinde)
        "prod": [[k,d,i], ...],  // üretim füzyon modeli tahmini (varsa)
        "v66":  [[k,d,i], ...],  // AI ensemble tahmini
        "v7":   [[k,d,i], ...],  // tek-model AI tahmini
        "fizik":[[k,d,i], ...]   // fizik baseline tahmini
        // "prod" yoksa istemci tarafında v71 = 0.6*v66 + 0.4*fizik olarak türetilir
      }
    ]
  }
}
```

Bu dosya, ana projedeki `ciktilar/metrikler/canli_izleme.json` çıktısının bir
kopyasıdır. Ana projeyle veriyi güncel tutmak için o dosyayı yeniden üretip
`data/ucuslar.json` üzerine kopyalamanız yeterlidir.

## Yapı

```
ucus-izleme-app/
├── index.html       # 3D canvas oynatıcı (veri gömülü değil, fetch ile yüklenir)
├── data/
│   └── ucuslar.json # oynatma verisi
├── serve.sh          # basit http.server başlatıcı
└── README.md
```

## Ana proje

Bu görselleştiricinin ürettiği veriler ve altta yatan konum-tahmin modelleri
`GSP_Kullanmadan_Konum_Tahmini` ana reposunda geliştirilir (GPS'siz, yalnızca
sensör verisiyle konum tahmini üzerine bir araştırma projesi).

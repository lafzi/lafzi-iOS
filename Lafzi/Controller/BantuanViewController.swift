//
//  BantuanViewController.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 13/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit
import WebKit

class BantuanViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString("""
            <head>
                <style type='text/css'>
                    body {
                       font-family: 'SourceSansPro-Regular';
                       padding: 0;
                       font-size: 20pt;
                       margin-left: 25pt;
                       margin-right: 25pt;
                    }
                </style>
            </head>
            <body>
            <b>Urutan hasil pencarian</b>
            <br/>Hasil pencarian terurut kecocokan. Hasil yang paling atas adalah hasil yang menurut aplikasi paling cocok,
            sedangkan hasil yang paling bawah yang kemungkinan kurang cocok.
            <br/>
            
            <br/><b>Jika hasil pencarian tidak sesuai harapan...</b>
            <br/>Sebagaimana mesin pencari pada umumnya, aplikasi ini tidak sempurna atau selalu dapat memberikan hasil yang sesuai.
            Ini dipengaruhi juga oleh lafadz pencarian yang dimasukkan. Pastikan lafadz yang dicari memang benar-benar
            ada di dalam Al-Qur\'an dan bukan misalnya hadits, do\'a, atau yang lainnya.
            <br/>
            <br/>Sebagai catatan, aplikasi ini ditujukan untuk mencari lafadz di dalam Al-Qur\'an dengan tulisan latin, dan <b>bukan</b> untuk mencari:
            <br/>
            \u{2022} Terjemahan<br/>
            \u{2022} Nama surat atau nomor ayat<br/>
            \u{2022} Teks Qur\'an dalam huruf Arab
            <br/>
            
            <br/><b>Jika hasil pencarian terlalu banyak...</b>
            <br/>Jika lafadz yang dimasukkan terlalu pendek atau memang sangat umum kemunculannya di dalam Al-Qur\'an,
            misalnya lafadz \"Allah\", maka hasilnya akan sangat banyak. Untuk hasil yang lebih spesifik,
            Anda dapat mencoba masukan yang lebih panjang.
            <br/>
            
            <br/><b>Membagikan ayat hasil pencarian</b>
            <br/>Klik pada salah satu hasil pencarian untuk membuka halaman lanjutan, dan tekan tombol dengan icon share.</body>
        """, baseURL: nil)
    }

}

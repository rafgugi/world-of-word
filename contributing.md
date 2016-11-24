### Let's contribute :)

#### Code

Kode dibuat menggunakan bahasa [coffeescript](http://coffeescript.org). Game ini terdiri dari 3 komponen:
 - HTML page untuk container. Tema menggunakan [foundation](http://foundation.zurb.com/sites.html).
 - Server untuk menangani jalannya game menggunakan [socket.io](http://socket.io) dan [express.js](http://expressjs.com).
 - [React](https://facebook.github.io/react) component untuk menangani tampilan game.

#### Socket protocol

Untuk interaksi client dengan server, dibutuhkan protocol khusus dari masing-masing client dan server. Untuk setiap protokol yang dibuat oleh client, server harus dapat menangani protokol tersebut. Begitu pula sebaliknya. Misalnya pada saat client mengirimkan `init: 'icang'`, maka server akan menambahkan player dengan nama icang.

S | Sender | Protocol | Message | Description
--- | --- | --- | --- | ---
&#x2717; | client | `init` | `name:String` | Pertamakali client menghubungi server, mengirimkan nama.
&#x2717; | client | `chat` | `message:String` | Client menjawab pertanyaan atau sekedar membroadcast pesan.
&#x2717; | server | `clients` | `[ { id:String, name:String } ]` | Server membroadcast siapa saja yang sedang online.
&#x2713; | server | `game` | `{ board:[String], category:String }` | Server memberi soal barupa array dua dimensi berisi huruf acak, serta memberi kategori kata yang harus dicari. Saat pertama game dimulai, server membroadcast ke semua client. Jika ada client yang baru masuk ketika game sudah dimulai, maka server akan mengirim khusus untuk client tersebut.
&#x2713; | server | `chat` | `{ id:String, chat:String }` | Server membroadcast chat dari client atau info dari server.
&#x2713; | server | `timer` | `timer:int` | Server membroadcast siswa waktu dalam 1 game.
&#x2713; | server | `answered` | `[ { col:int, row:int, vertical:boolean, word:String } ]` | Server membroadcast kata apa saja yang sudah dijawab.
&#x2717; | server | `score` | `score:int` | Server mengirim score client ketika score berubah atau saat pertamakali.
&#x2717; | server | `scores` | `[ { id:String, score:int } ]` | Server membroadcast semua score client. Jika ada client yang baru masuk ketika game sudah dimulai, maka server akan mengirim khusus untuk client tersebut.

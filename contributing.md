### Let's contribute :)

#### Code

Game ini terdiri dari 3 komponen:
 - html page untuk container. Tema menggunakan [foundation](http://foundation.zurb.com/sites.html)
 - [socket.io](socket.io) server untuk menangani jalannya game
 - [react](https://facebook.github.io/react) component untuk menangani tampilan game

#### Socket protocol

Untuk interaksi client dengan server, dibutuhkan protocol khusus dari masing-masing client dan server. Untuk setiap protokol yang dibuat oleh client, server harus dapat menangani protokol tersebut. Begitu pula sebaliknya. Misalnya pada saat client mengirimkan `init: 'icang'`, maka server akan menambahkan player dengan nama icang.

##### Client
protocol | value
--- | ---
`init` | `String name` to be registered on server
`send` | `String message` to be broadcasted

##### Server
protocol | value
--- | ---
`game` | `Array[9]` of 9 length strings
`chat` | `{ String name, String chat }`
`timer` | `Number` game timer
`score` | `Number` your score
`scores` | `[ { String name, String score} ]` players scores

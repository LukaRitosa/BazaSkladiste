from flask import Flask, request, jsonify
from flask_mysqldb import MySQL

app=Flask(__name__)

app.config['JSON_AS_ASCII']= False

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER']= 'radnik'
app.config['MYSQL_PASSWORD']='lozinka'
app.config['MYSQL_DB']='baza_skladiste'

mysql=MySQL(app)

@app.route('/proizvodi', methods=['GET'])
def proizvodi():

    curr=mysql.connection.cursor()

    curr.execute("SELECT * FROM proizvodi")
    proizvodi=curr.fetchall()

    curr.close()

    return jsonify(proizvodi)

# (ovo sam upiso u cmd)curl -X POST -F "id_proizvod=32" -F "naziv_proizvoda=Jana jagoda" -F "opis=voda s okusom jagode" -F "cijena=1.60" -F "kolicina_na_skladistu=70" -F "id_kategorija=41" -F "id_dobavljac=80" http://localhost:8000/proizvodi

@app.route('/proizvodi', methods=['POST'])
def insert_proizvod():

    data=request.form
    print(data)

    id_proizvod=data['id_proizvod']
    naziv_proizvoda=data['naziv_proizvoda']
    opis=data['opis']
    cijena=data['cijena']
    kolicina_na_skladistu=data['kolicina_na_skladistu']
    id_kategorija=data['id_kategorija']
    id_dobavljac=data['id_dobavljac']

    cur=mysql.connection.cursor()
    cur.execute('INSERT INTO proizvodi(id_proizvod,naziv_proizvoda,opis,cijena,kolicina_na_skladistu,id_kategorija,id_dobavljac) values(%s,%s,%s,%s,%s,%s,%s)', (id_proizvod,naziv_proizvoda,opis,cijena,kolicina_na_skladistu,id_kategorija,id_dobavljac))
    mysql.connection.commit()
    cur.close()

    return jsonify({'msg':'proizvod '+naziv_proizvoda+' uspješno spremljen'})


if __name__ == '__main__':
    app.run(debug=True, port=8000)
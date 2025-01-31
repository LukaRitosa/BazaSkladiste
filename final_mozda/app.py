from flask import Flask, request, jsonify, render_template, redirect, url_for
from flask_mysqldb import MySQL

app=Flask(__name__)

app.config['JSON_AS_ASCII']= False

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER']= 'root'
app.config['MYSQL_PASSWORD']='root'
app.config['MYSQL_DB']='baza_skladiste'

mysql=MySQL(app)


@app.route('/proizvodi_get', methods=['GET'])
def proizvodi_get():

    curr=mysql.connection.cursor()

    curr.execute("SELECT * FROM proizvodi")
    proizvodi_data=curr.fetchall()

    curr.close()

    return render_template('get_proizvodi.html', proizvodi_data=proizvodi_data)

@app.route('/insert_proizvod_form', methods=['GET'])
def insert_proizvod_form():

    curr = mysql.connection.cursor()

    curr.execute("SELECT * FROM kategorije")
    kategorije = curr.fetchall()

    curr.close()

    curr = mysql.connection.cursor()

    curr.execute("SELECT * FROM dobavljaci")
    dobavljaci = curr.fetchall()

    curr.close()

    return render_template('insert_proizvod.html', kategorije=kategorije, dobavljaci=dobavljaci)

@app.route('/proizvodi_post', methods=['GET', 'POST'])
def insert_proizvod():
    if request.method == 'GET':
        curr = mysql.connection.cursor()

        curr.execute("SELECT * FROM kategorije")
        kategorije = curr.fetchall()

        curr.close()

        curr = mysql.connection.cursor()

        curr.execute("SELECT * FROM dobavljaci")
        dobavljaci = curr.fetchall()

        curr.close()

        return render_template('insert_proizvod.html', kategorije=kategorije, dobavljaci=dobavljaci)

    elif request.method == 'POST':

        try:

            id_proizvod = request.form['id_proizvod']

            naziv_proizvoda = request.form['naziv_proizvoda']

            opis = request.form['opis']

            cijena = request.form['cijena']

            kolicina_na_skladistu = request.form['kolicina_na_skladistu']

            id_kategorija = request.form['id_kategorija']

            id_dobavljac = request.form['id_dobavljac']

            cur = mysql.connection.cursor()

            cur.execute(

                'INSERT INTO proizvodi (id_proizvod, naziv_proizvoda, opis, cijena, kolicina_na_skladistu, id_kategorija, id_dobavljac) '
        
                'VALUES (%s, %s, %s, %s, %s, %s, %s)',

                (id_proizvod, naziv_proizvoda, opis, cijena, kolicina_na_skladistu, id_kategorija, id_dobavljac)

            )

            mysql.connection.commit()

            cur.close()

            return redirect(url_for('proizvodi_get'))

        except Exception as e:

            return f"Došlo je do greške: {e}"




@app.route('/zaposlenici_get', methods=['GET'])
def zaposlenici_get():
    curr = mysql.connection.cursor()
    curr.execute("SELECT * FROM zaposlenici")
    zaposlenici_data = curr.fetchall()
    curr.close()

    return render_template('get_zaposlenici.html', zaposlenici_data=zaposlenici_data)

@app.route('/insert_zaposlenik_form', methods=['GET'])
def insert_zaposlenik_form():
    curr = mysql.connection.cursor()
    curr.execute("SELECT * FROM skladista")
    skladista = curr.fetchall()
    curr.close()

    return render_template('insert_zaposlenik.html', skladista=skladista)

@app.route('/zaposlenik_post', methods=['POST'])
def insert_zaposlenik():
    if request.method == 'POST':
        try:
            ime = request.form['ime']
            prezime = request.form['prezime']
            email = request.form['email']
            telefon = request.form['telefon']
            id_skladiste = request.form['id_skladiste']

            cur = mysql.connection.cursor()

            # dobivanje id-ja
            cur.execute("SELECT MAX(id_zaposlenik) FROM zaposlenici")
            last_id = cur.fetchone()[0]

            next_id = 1 if last_id is None else last_id + 1

            cur.execute('''INSERT INTO zaposlenici (id_zaposlenik, ime, prezime, email, telefon, id_skladiste)
                           VALUES (%s, %s, %s, %s, %s, %s)''',
                        (next_id, ime, prezime, email, telefon, id_skladiste))
            mysql.connection.commit()
            cur.close()

            return redirect(url_for('zaposlenici_get'))

        except Exception as e:
            return f"Došlo je do greške: {e}"

@app.route('/get_zaposlenik/<int:id_zaposlenik>', methods=['GET'])
def get_zaposlenik(id_zaposlenik):
    curr = mysql.connection.cursor()
    curr.execute("SELECT * FROM zaposlenici WHERE id_zaposlenik = %s", (id_zaposlenik,))
    zaposlenik = curr.fetchone()
    curr.close()

    return render_template('get_zaposlenik.html', zaposlenik=zaposlenik)

@app.route('/obrisi_zaposlenik/<int:id_zaposlenik>', methods=['POST'])
def obrisi_zaposlenik(id_zaposlenik):
    try:
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM zaposlenici WHERE id_zaposlenik = %s", (id_zaposlenik,))
        mysql.connection.commit()
        cur.close()

        return redirect(url_for('zaposlenici_get'))

    except Exception as e:
        return f"Došlo je do greške: {e}"



@app.route('/skladista', methods=['GET'])
def get_skladista():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM skladista")
    skladista = cur.fetchall()
    cur.close()
    return render_template('get_skladista.html', skladista_data=skladista)

@app.route('/skladista/novo', methods=['GET'])
def get_insert_form():
    return render_template('insert_skladista.html')

@app.route('/skladista', methods=['POST'])
def insert_skladista():
    try:
        data = request.form
        id_skladista = data['id_skladiste']
        naziv_skladista = data['naziv_skladista']
        lokacija = data['lokacija']

        cur = mysql.connection.cursor()
        cur.execute(
            'INSERT INTO skladista (id_skladiste, naziv_skladista, lokacija) VALUES (%s, %s, %s)',
            (id_skladista, naziv_skladista, lokacija)
        )
        mysql.connection.commit()
        cur.close()

        return redirect(url_for('get_skladista'))

    except Exception as e:
        return f"Dogodila se pogreška: {e}", 500


@app.route('/inventar', methods=['GET'])
def inventar_get():
    curr = mysql.connection.cursor()

    curr.execute("SELECT * FROM inventar")
    inventar_data = curr.fetchall()

    curr.close()

    return render_template('inventar_get.html', inventar_data=inventar_data)


@app.route('/insert_inventar_form', methods=['GET'])
def insert_inventar_form():
    curr = mysql.connection.cursor()

    curr.execute("SELECT * FROM skladista")
    skladista = curr.fetchall()

    curr.execute("SELECT id_proizvod, naziv_proizvoda FROM proizvodi")
    proizvodi = curr.fetchall()

    curr.close()

    return render_template('insert_inventar.html', skladista=skladista, proizvodi=proizvodi)


@app.route('/inventar_post', methods=['POST'])
def insert_inventar():
    try:
       
        id_inventar = request.form['id_inventar']
        id_skladiste = request.form['id_skladiste']
        id_proizvod = request.form['id_proizvod']
        trenutna_kolicina = request.form['trenutna_kolicina']


        cur = mysql.connection.cursor()

 
        cur.execute(
            'INSERT INTO inventar (id_inventar, id_skladiste, id_proizvod, trenutna_kolicina) '
            'VALUES (%s, %s, %s, %s)', 
            (id_inventar, id_skladiste, id_proizvod, trenutna_kolicina)
        )

        mysql.connection.commit()
        cur.close()

        return redirect(url_for('inventar_get'))

    except Exception as e:
        return f"Došlo je do greške: {e}"
"

@app.route('/')
def index():
    return render_template('pocetna.html')

if __name__ == '__main__':
    app.run(debug=True, port=8000)

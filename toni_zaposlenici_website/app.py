from flask import Flask, request, render_template, redirect, url_for
from flask_mysqldb import MySQL

app = Flask(__name__)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'user'
app.config['MYSQL_DB'] = 'baza_skladiste'

mysql = MySQL(app)

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

#pocetna
@app.route('/')
def index():
    return render_template('pocetna.html')

if __name__ == '__main__':
    app.run(debug=True, port=8000)

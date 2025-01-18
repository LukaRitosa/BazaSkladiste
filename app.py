from flask import Flask, request, jsonify, render_template, redirect, url_for
from flask_mysqldb import MySQL

app=Flask(__name__)

app.config['JSON_AS_ASCII']= False

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER']= 'radnik'
app.config['MYSQL_PASSWORD']='lozinka'
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



@app.route('/')
def index():
    return render_template('pocetna.html')
    

if __name__ == '__main__':
    app.run(debug=True, port=8000)

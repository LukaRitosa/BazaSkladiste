# SANJA______________________________________________________________________ #
from flask import Flask, request, jsonify, render_template, redirect, url_for
from flask_mysqldb import MySQL

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'root'
app.config['MYSQL_DB'] = 'baza_skladiste'

mysql = MySQL(app)

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

@app.route('/')
def index():
    return render_template('Početna.html')

if __name__ == '__main__':
    app.run(debug=True, port=8000)

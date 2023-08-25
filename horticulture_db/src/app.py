
import psycopg2
from flask import Flask

from flask import  render_template, request

app = Flask(__name__)

def get_db_connection(database="horticulture_latest",
                      user="postgres",
                      host="localhost",
                      port="5432",
                      password="12345"
                      ):
    
    conn = psycopg2.connect(
        database=database,
        user=user,
        
        host=host,
        port=port,
        password=password,
    )
    return conn


@app.route('/', methods=['GET', 'POST'])

def hello_world():
    print(request.method)
   
    if request.method == "GET":
        return render_template("index.html")

    else:
        license_number = request.form['license_number']
        conn = get_db_connection()
        cur = conn.cursor()
        #query_executed = f"select license_num from license_info where license_num='{license_number}'"
        query_executed= f"""select l.license_num, l.owner_name, trade_name, ci.city_name from license_info l join contact co on l.license_num = co.lid join city_info ci
on co.city_id = ci.city_id where l.license_num = '{license_number}'"""
        cur.execute(query_executed)
        res = cur.fetchone()
        
        
        
        
        cur.close()
        conn.close()
        filename = "success.html"
        if  res is not None  :
            lis = res[0]
            owner = res[1]
            trade = res[2]
            city = res[3]
            return render_template(filename, lis = lis, city = city, owner=owner, trade=trade)
        else:
            return render_template("nosuccess.html")
       
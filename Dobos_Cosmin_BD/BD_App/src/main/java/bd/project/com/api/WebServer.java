package bd.project.com.api;

import bd.project.com.database.SQL_XE;
import bd.project.com.utils.Utils;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static spark.Spark.get;

public class WebServer {
    SQL_XE sql_xe;

    public WebServer(){
        sql_xe = new SQL_XE();
        System.out.println("Database initialized successfully");

        init_routes();
        System.out.println("Web Server Routes initialized successfully");

        System.out.println("Home Page: http://localhost:4567/");
    }

    //Java Spark
    private void init_routes(){
        get("/", (req, res) -> {
            //creem obiectul model de tip HashMap (dictionar)
            Map<String, Object> model = new HashMap<>();
            String templateVariable = "Hello Velocity!";

            //incarcam o variabila in model
            model.put("message", templateVariable);

            //transmitem modelul la functia render din utilities
            return Utils.render(model, "home.html");
        });

        get("/addresses", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            try {
                //scot din baza de date adresele
                List<Map<String, String>> addresses = sql_xe.getAddresses();

                //creez modelul cu datele scoase din abaza de date
                model.put("addresses", addresses);
            }catch (SQLException throwables) {
                throwables.printStackTrace();
            }
            return Utils.render(model, "addresses.html");
        });

        get("/producers", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            try {
                // luam din baza de date producatorii si ii punem in model
                List<Map<String, String>> producers = sql_xe.getProducers();
                model.put("producers", producers);
            }catch (SQLException throwables) {
                throwables.printStackTrace();
            }
            //randam pagina producers transmitand modelul creat
            return Utils.render(model, "producers.html");
        });

        get("/pharmacies", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            try {
                List<Map<String, String>> pharmacies = sql_xe.getPharmacies();
                model.put("pharmacies", pharmacies);
            }catch (SQLException throwables) {
                throwables.printStackTrace();
            }
            return Utils.render(model, "pharmacies.html");
        });

        get("/drugs", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            try {
                List<Map<String, String>> drugs = sql_xe.getDrugs();
                model.put("drugs", drugs);
            }catch (SQLException throwables) {
                throwables.printStackTrace();
            }
            return Utils.render(model, "drugs.html");
        });

        get("/local-drugs", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            try {
                List<Map<String, String>> drugs = sql_xe.getLocalDrugs();
                model.put("local_drugs", drugs);
            }catch (SQLException throwables) {
                throwables.printStackTrace();
            }
            return Utils.render(model, "local-drugs.html");
        });

        get("/bills", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            try {
                List<Map<String, String>> bills = sql_xe.getBills();
                model.put("bills", bills);
            }catch (SQLException throwables) {
                throwables.printStackTrace();
            }
            return Utils.render(model, "bills.html");
        });

        get("/orders", (req, res) -> {
            Map<String, Object> model = new HashMap<>();
            try {
                List<Map<String, String>> orders = sql_xe.getOrders();
                model.put("orders", orders);
            }catch (SQLException throwables) {
                throwables.printStackTrace();
            }
            return Utils.render(model, "orders.html");
        });
    }


}
